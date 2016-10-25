#include <iostream>
#include <memory>

class ExprAST {
public:
  virtual ~ExprAST() {}
  virtual void write(std::ostream& os) = 0;
};

class ArgExprAST : public ExprAST{
  int n;
public:
  ArgExprAST(int n) : n(n) {}
  void write(std::ostream& os) {
    os << "a" << n;
  }
};

class IntExprAST : public ExprAST {
  int64_t val;
public:
  IntExprAST(int64_t val) : val(val) {}
  void write(std::ostream& os) {
    os << val;
  }
};

class BinaryOpExprAST : public ExprAST {
  std::string op;
  std::unique_ptr<ExprAST> lhs, rhs;
public:
  BinaryOpExprAST(std::string op, std::unique_ptr<ExprAST> lhs, std::unique_ptr<ExprAST> rhs) 
    : op(op), lhs(std::move(lhs)), rhs(std::move(rhs)) {}
  void write(std::ostream& os) {
    os << "(" << op << " ";
    lhs->write(os);
    os << " ";
    rhs->write(os);
    os << ")";
  }
};

class BoolExprAST : public ExprAST {
  bool val;
public:
  BoolExprAST(bool val) : val(val) {}
  void write(std::ostream& os) {
    os << val;
  }
};

class IfExprAST : public ExprAST {
  std::unique_ptr<ExprAST> cnd, thn, els;
public:
  IfExprAST(std::unique_ptr<ExprAST> cnd, std::unique_ptr<ExprAST> thn, std::unique_ptr<ExprAST> els)
    : cnd(std::move(cnd)), thn(std::move(thn)), els(std::move(els)) {}
  void write(std::ostream& os) {
    os << "(if ";
    cnd->write(os);
    os << " ";
    thn->write(os);
    os << " ";
    els->write(os);
    os << ")";
  }
};
