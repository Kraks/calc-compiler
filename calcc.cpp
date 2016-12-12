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

static bool check_of = false;

static LLVMContext Context;
static IRBuilder<NoFolder> Builder(Context);
static std::unique_ptr<Module> M = llvm::make_unique<Module>("calc", Context);
static std::map<int, Value*> ArgumentValues;
static std::map<std::string, AllocaInst*> MutableValues;

static FunctionType *OVFT = FunctionType::get(Type::getVoidTy(Context), Type::getInt32Ty(Context), false);
static Function* OVHandler = Function::Create(OVFT, Function::ExternalLinkage, "overflow_fail", &*M);

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

static Value* GenerateOpOverflow(Function* OpFun, std::vector<Value*> args, int pos) {
  BasicBlock* EntryBlock = Builder.GetInsertBlock();
  Function* TheFunction = EntryBlock->getParent();

  BasicBlock* OFBlock = BasicBlock::Create(Context, "of", TheFunction);
  BasicBlock* NormalBlock = BasicBlock::Create(Context, "normal", TheFunction);

  Value* result = Builder.CreateCall(OpFun, args, "result");
  Value* fst = Builder.CreateExtractValue(result, {0}, "fst");
  Value* snd = Builder.CreateExtractValue(result, {1}, "snd");
  Builder.CreateCondBr(snd, OFBlock, NormalBlock);

  Builder.SetInsertPoint(OFBlock);
  std::vector<Value*> posArg = {ConstantInt::get(Context, APInt(32, pos, true))};
  Builder.CreateCall(OVHandler, posArg);
  Builder.CreateBr(NormalBlock);
  OFBlock = Builder.GetInsertBlock();
  
  
  Builder.SetInsertPoint(NormalBlock);
  return fst;
}

static Value* BinaryOpWithOverflow(OpType op, std::vector<Value*> args, int pos) {
  const std::vector<Type*> Int64V = {Type::getInt64Ty(Context)};
  Function* OpFun;

  switch (op) {
    case add:
      if (check_of) {
        OpFun = Intrinsic::getDeclaration(&*M, Intrinsic::sadd_with_overflow, Int64V);
        return GenerateOpOverflow(OpFun, args, pos);
      }
      return Builder.CreateAdd(args.at(0), args.at(1), "add");
    case sub:
      if (check_of) {
        OpFun = Intrinsic::getDeclaration(&*M, Intrinsic::ssub_with_overflow, Int64V);
        return GenerateOpOverflow(OpFun, args, pos);
      }
      return Builder.CreateSub(args.at(0), args.at(1), "sub");
    case mult:
      if (check_of) {
        OpFun = Intrinsic::getDeclaration(&*M, Intrinsic::smul_with_overflow, Int64V);
        return GenerateOpOverflow(OpFun, args, pos);
      }
      return Builder.CreateMul(args.at(0), args.at(1), "mul");
    default:
      return LogErrorV("not applicable to overflow check");
  }
}

Value* BinaryOpExprAST::codegen() {
  Value* L = lhs->codegen();
  Value* R = rhs->codegen();
  if (!L || !R) return nullptr;

  switch (op) {
    case add: case sub: case mult: 
      return BinaryOpWithOverflow(op, {L, R}, getPos());
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
  if (!CndValue) return LogErrorV("Can not generate code for cond part");
  Builder.CreateCondBr(CndValue, BodyBlock, ContBlock);
  EntryBlock = Builder.GetInsertBlock();
  
  Builder.SetInsertPoint(BodyBlock);
  Value* BodyValue = body->codegen();
  if (!BodyValue) return LogErrorV("Can not generate code for body part");
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
  MutableVarExprAST* mvar = static_cast<MutableVarExprAST*>(var.get());
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
    assert(!verifyModule(*M, &outs()));
    M->dump();
    return 0;
  }
  return 1;
}

int main(int argc, char** argv) { 
  if (argc == 2) {
    if (strncmp("-check", argv[1], 6) == 0) {
      check_of = true;
    }
    else {
      fprintf(stderr, "unknown option %s\n", argv[1]);
      return 1;
    }
  }
  return compile(); 
}
