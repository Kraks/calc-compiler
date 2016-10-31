#include <iostream>
#include "ast.hpp"

static std::string OpToString(OpType op) {
  switch (op) {
    case add: return std::string("+");
    case sub: return std::string("-");
    case mult: return std::string("*");
    case division: return std::string("/");
    case mod: return std::string("%");
    case gt: return std::string(">");
    case ge: return std::string(">=");
    case lt: return std::string("<");
    case le: return std::string("<=");
    case eq: return std::string("==");
    case neq: return std::string("!=");
    case unknown: return std::string("?");
  }
  return std::string("?");
}

void ArgExprAST::write(std::ostream& os) {
  os << "a" << n;
}
void MutableVarExprAST::write(std::ostream& os) {
  os << name;
}
void IntExprAST::write(std::ostream& os) {
  os << val;
}
void BinaryOpExprAST::write(std::ostream& os) {
  os << "(" << OpToString(op) << " ";
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
void SeqExprAST::write(std::ostream& os) {
  os << "(seq ";
  fst->write(os);
  os << " ";
  snd->write(os);
  os << ")";
}
void WhileExprAST::write(std::ostream& os) {
  os << "(while ";
  cnd->write(os);
  os << " ";
  body->write(os);
  os << ")";
}
