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

static LLVMContext C;
static IRBuilder<NoFolder> Builder(C);
static std::unique_ptr<Module> M = llvm::make_unique<Module>("calc", C);
static std::map<int, Value*> NamedValues;

Value* LogErrorV(const char* msg) {
  LogError(msg);
  return nullptr;
}

Value* ArgExprAST::codegen() {
  Value* V = NamedValues[n];
  if (!V) {
    LogError("Unknown variable name");
  }
  return V;
}

Value* IntExprAST::codegen() {
  return ConstantInt::get(C, APInt(64, val, /*isSigned=*/true));
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
    return ConstantInt::getTrue(C);
  }
  return ConstantInt::getFalse(C);
}

Value* IfExprAST::codegen() {
  //TODO
  return ConstantInt::get(C, APInt(64, 0));
}

static int compile() {
  M->setTargetTriple(llvm::sys::getProcessTriple());
  std::vector<Type *> SixInts(6, Type::getInt64Ty(C));
  FunctionType *FT = FunctionType::get(Type::getInt64Ty(C), SixInts, false);
  Function *F = Function::Create(FT, Function::ExternalLinkage, "f", &*M);
  BasicBlock *BB = BasicBlock::Create(C, "entry", F);
  Builder.SetInsertPoint(BB);
  
  int idx = 0;
  for (auto& Arg : F->args()) {
    NamedValues[idx++] = &Arg;
  }

  std::unique_ptr<ExprAST> e = std::move(Parse());

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

int main(void) { return compile(); }
