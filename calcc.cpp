#include "llvm/ADT/APInt.h"
#include "llvm/IR/ConstantRange.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/NoFolder.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"
#include <cassert>
#include <iostream>

#include "ast.hpp"
#include "parser.hpp"

using namespace llvm;
using namespace std;

static LLVMContext Context;
static IRBuilder<NoFolder> Builder(Context);
static std::unique_ptr<Module> M = llvm::make_unique<Module>("calc", Context);
static std::map<int, Value*> ArgumentValues;
static std::map<std::string, AllocaInst*> MutableValues;

Value* LogErrorV(const char* msg) {
  LogError(msg);
  return nullptr;
}

Value* ArgExprAST::codegen() {
  Value* V = ArgumentValues[n];
  if (!V) {
    LogErrorV("Unknown argument name");
  }
  return V;
}

Value* MutableVarExprAST::codegen() {
  Value* V = MutableValues[name];
  if (!V)
    LogErrorV("Unknown variable name");
  return Builder.CreateLoad(V, name.c_str());
}

Value* IntExprAST::codegen() {
  return ConstantInt::get(Context, APInt(64, val, /*isSigned=*/true));
}

Value* BinaryOpExprAST::codegen() {
  Value* L = lhs->codegen();
  Value* R = rhs->codegen();
  if (!L || !R) return nullptr;
  
  switch (op) {
    case add:
      return Builder.CreateAdd(L, R, "add");
    case sub:
      return Builder.CreateSub(L, R, "sub");
    case mult:
      return Builder.CreateMul(L, R, "mul");
    case division:
      return Builder.CreateSDiv(L, R, "sdiv");
    case mod:
      return Builder.CreateSRem(L, R, "srem");
    case gt:
      return Builder.CreateICmpSGT(L, R, "gt");
    case ge:
      return Builder.CreateICmpSGE(L, R, "ge");
    case lt:
      return Builder.CreateICmpSLT(L, R, "lt");
    case le:
      return Builder.CreateICmpSLE(L, R, "le");
    case eq:
      return Builder.CreateICmpEQ(L, R, "eq");
    case neq:
      return Builder.CreateICmpNE(L, R, "neq");
    case unknown:
    default:
      return LogErrorV("unknown operator");
  }
}

Value* BoolExprAST::codegen() {
  if (val) {
    return ConstantInt::getTrue(Context);
  }
  return ConstantInt::getFalse(Context);
}

Value* IfExprAST::codegen() {
  Value* CndValue = cnd->codegen();
  if (!CndValue)
    return nullptr;
  
  Function* TheFunction = Builder.GetInsertBlock()->getParent();
  BasicBlock* ThenBB = BasicBlock::Create(Context, "then", TheFunction);
  BasicBlock* ElseBB = BasicBlock::Create(Context, "else");
  BasicBlock* MergBB = BasicBlock::Create(Context, "ifcont");

  Builder.CreateCondBr(CndValue, ThenBB, ElseBB);

  Builder.SetInsertPoint(ThenBB);
  Value* ThnValue = thn->codegen();
  if (!ThnValue)
    return nullptr;
  Builder.CreateBr(MergBB);
  ThenBB = Builder.GetInsertBlock();

  TheFunction->getBasicBlockList().push_back(ElseBB);
  Builder.SetInsertPoint(ElseBB);
  Value* ElsValue = els->codegen();
  if (!ElsValue)
    return nullptr;
  Builder.CreateBr(MergBB);
  ElseBB = Builder.GetInsertBlock();
  
  TheFunction->getBasicBlockList().push_back(MergBB);
  Builder.SetInsertPoint(MergBB);
  PHINode* PN = Builder.CreatePHI(Type::getInt64Ty(Context), 2, "iftmp");
  PN->addIncoming(ThnValue, ThenBB);
  PN->addIncoming(ElsValue, ElseBB);
  
  return PN;
}

Value* SeqExprAST::codegen() {
  Value* fstVal = fst->codegen();
  if (fstVal) {
    Value* sndVal = snd->codegen();
    if (sndVal) return sndVal;
    return LogErrorV("Can not generate code for the second part");
  }
  return LogErrorV("Can not generate code for the first part");
}

Value* WhileExprAST::codegen() {
  BasicBlock* EntryBlock = Builder.GetInsertBlock();
  Function* TheFunction = EntryBlock->getParent();

  BasicBlock* BodyBlock = BasicBlock::Create(Context, "body", TheFunction);
  BasicBlock* ContBlock = BasicBlock::Create(Context, "cont", TheFunction);

  Value* CndValue = cnd->codegen();
  Builder.CreateCondBr(CndValue, BodyBlock, ContBlock);
  
  Builder.SetInsertPoint(BodyBlock);
  Value* BodyValue = body->codegen();
  CndValue = cnd->codegen();
  Builder.CreateCondBr(CndValue, BodyBlock, ContBlock);
  BodyBlock = Builder.GetInsertBlock();
  
  Builder.SetInsertPoint(ContBlock);
  PHINode* PH = Builder.CreatePHI(Type::getInt64Ty(Context), 2, "tmp");
  PH->addIncoming(ConstantInt::get(Context, APInt(64, 0, true)), EntryBlock);
  PH->addIncoming(BodyValue, BodyBlock);
  return PH;
}

Value* SetExprAST::codegen() {
  Value* value = val->codegen();
  MutableVarExprAST* mvar = dynamic_cast<MutableVarExprAST*>(var.get());
  AllocaInst* alloca = MutableValues[mvar->getName()];
  if (value && alloca) {
    Builder.CreateStore(value, alloca);
    return value;
  }
  return LogErrorV("Unknown mutable variable");
}

//////////////////////////////

static int compile() {
  M->setTargetTriple(llvm::sys::getProcessTriple());
  std::vector<Type *> SixInts(6, Type::getInt64Ty(Context));
  FunctionType *FT = FunctionType::get(Type::getInt64Ty(Context), SixInts, false);
  Function *F = Function::Create(FT, Function::ExternalLinkage, "f", &*M);
  BasicBlock *EntryBlock = BasicBlock::Create(Context, "entry", F);
  Builder.SetInsertPoint(EntryBlock);
    
  // setup argument symbol table
  int argIdx = 0;
  for (auto& Arg : F->args()) {
    ArgumentValues[argIdx++] = &Arg;
  }

  // setup mutable symbol table
  std::string m("m");
  for (int i = 0; i <= 9; i++) {
    std::string var = m+(char)('0'+i);
    AllocaInst* alloca = Builder.CreateAlloca(Type::getInt64Ty(Context), 0, var.c_str());
    Builder.CreateStore(ConstantInt::get(Context, APInt(64, 0, true)), alloca);
    MutableValues[var] = alloca;
  }

  std::unique_ptr<ExprAST> e = Parse();

  if (e) {
    std::cerr << "; ";
    e->write(std::cerr);
    std::cerr << std::endl;

    Value* RetVal = e->codegen();
    Builder.CreateRet(RetVal);
    //assert(!verifyModule(*M, &outs()));
    M->dump();
    return 0;
  }
  return 1;
}

int main(void) { return compile(); }
