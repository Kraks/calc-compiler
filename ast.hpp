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
  long long pos;
public:
  ExprAST(long long pos) : pos(pos) {}
  long long getPos() { return pos; }
  virtual ~ExprAST() {}
  virtual Value* codegen() = 0;
  virtual void write(std::ostream& os) = 0;
};

class ArgExprAST : public ExprAST {
  int n;
public:
  ArgExprAST(long long pos, int n) : ExprAST(pos), n(n) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class MutableVarExprAST : public ExprAST {
  std::string name;
public:
  MutableVarExprAST(long long pos, std::string name) : ExprAST(pos), name(name) {}
  std::string& getName() { return name; }
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class IntExprAST : public ExprAST {
  int64_t val;
public:
  IntExprAST(long long pos, int64_t val) : ExprAST(pos), val(val) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class BinaryOpExprAST : public ExprAST {
  OpType op;
  std::unique_ptr<ExprAST> lhs, rhs;
public:
  BinaryOpExprAST(long long pos, OpType op, std::unique_ptr<ExprAST> lhs, std::unique_ptr<ExprAST> rhs) 
    : ExprAST(pos), op(op), lhs(std::move(lhs)), rhs(std::move(rhs)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class BoolExprAST : public ExprAST {
  bool val;
public:
  BoolExprAST(long long pos, bool val) : ExprAST(pos), val(val) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class IfExprAST : public ExprAST {
  std::unique_ptr<ExprAST> cnd, thn, els;
public:
  IfExprAST(long long pos, std::unique_ptr<ExprAST> cnd, std::unique_ptr<ExprAST> thn, std::unique_ptr<ExprAST> els)
    : ExprAST(pos), cnd(std::move(cnd)), thn(std::move(thn)), els(std::move(els)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class SeqExprAST : public ExprAST {
  std::unique_ptr<ExprAST> fst, snd;
public:
  SeqExprAST(long long pos, std::unique_ptr<ExprAST> fst, std::unique_ptr<ExprAST> snd)
    : ExprAST(pos), fst(std::move(fst)), snd(std::move(snd)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class WhileExprAST : public ExprAST {
  std::unique_ptr<ExprAST> cnd, body;
public:
  WhileExprAST(long long pos, std::unique_ptr<ExprAST> cnd, std::unique_ptr<ExprAST> body)
    : ExprAST(pos), cnd(std::move(cnd)), body(std::move(body)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

class SetExprAST : public ExprAST {
  std::unique_ptr<ExprAST> val, var;
public:
  SetExprAST(long long pos, std::unique_ptr<ExprAST> val, std::unique_ptr<ExprAST> var)
    : ExprAST(pos), val(std::move(val)), var(std::move(var)) {}
  Value* codegen() override;
  void write(std::ostream& os) override;
};

#endif
