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

void ArgExprAST::write(std::ostream& os) {
  os << "a" << n;
}
void IntExprAST::write(std::ostream& os) {
  os << val;
}
void BinaryOpExprAST::write(std::ostream& os) {
  os << "(" << op << " ";
  lhs->write(os);
  os << " ";
  rhs->write(os);
  os << ")";
}
void BoolExprAST::write(std::ostream& os) {
  os << val;
}
void IfExprAST::write(std::ostream& os) {
  os << "(if ";
  cnd->write(os);
  os << " ";
  thn->write(os);
  os << " ";
  els->write(os);
  os << ")";
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
  
  return nullptr;
}

Value* BoolExprAST::codegen() {
  if (val) {
    return ConstantInt::getTrue(C);
  }
  return ConstantInt::getFalse(C);
}

Value* IfExprAST::codegen() {
  //TODO
  return nullptr;
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
