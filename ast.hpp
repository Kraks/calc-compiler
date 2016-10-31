#include "llvm/ADT/APInt.h"
#include "llvm/IR/ConstantRange.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/NoFolder.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"

#include <iostream>
#include <memory>

#ifndef AST
#define AST

using namespace llvm;

enum OpType {
  add=1, sub, mult, division, mod,
  gt, ge, lt, le, eq, neq, unknown
};

class ExprAST {
public:
  virtual ~ExprAST() {}
  virtual Value* codegen() = 0;
  virtual void write(std::ostream& os) = 0;
};

class ArgExprAST : public ExprAST {
  int n;
public:
  ArgExprAST(int n) : n(n) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class MutableVarExprAST : public ExprAST {
  std::string name;
public:
  MutableVarExprAST(std::string name) : name(name) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class IntExprAST : public ExprAST {
  int64_t val;
public:
  IntExprAST(int64_t val) : val(val) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class BinaryOpExprAST : public ExprAST {
  OpType op;
  std::unique_ptr<ExprAST> lhs, rhs;
public:
  BinaryOpExprAST(OpType op, std::unique_ptr<ExprAST> lhs, std::unique_ptr<ExprAST> rhs) 
    : op(op), lhs(std::move(lhs)), rhs(std::move(rhs)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class BoolExprAST : public ExprAST {
  bool val;
public:
  BoolExprAST(bool val) : val(val) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class IfExprAST : public ExprAST {
  std::unique_ptr<ExprAST> cnd, thn, els;
public:
  IfExprAST(std::unique_ptr<ExprAST> cnd, std::unique_ptr<ExprAST> thn, std::unique_ptr<ExprAST> els)
    : cnd(std::move(cnd)), thn(std::move(thn)), els(std::move(els)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class SeqExprAST : public ExprAST {
  std::unique_ptr<ExprAST> fst, snd;
public:
  SeqExprAST(std::unique_ptr<ExprAST> fst, std::unique_ptr<ExprAST> snd)
    : fst(std::move(fst)), snd(std::move(snd)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class WhileExprAST : public ExprAST {
  std::unique_ptr<ExprAST> cnd, body;
public:
  WhileExprAST(std::unique_ptr<ExprAST> cnd, std::unique_ptr<ExprAST> body)
    : cnd(std::move(cnd)), body(std::move(body)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class SetExprAST : public ExprAST {
  std::unique_ptr<ExprAST> val;
  std::string var;
public:
  SetExprAST(std::unique_ptr<ExprAST> val, std::string var)
    : val(std::move(val)), var(var) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

#endif
