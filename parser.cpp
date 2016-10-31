#include <iostream>
#include <string>
#include <vector>
#include <cstdio>
#include <cctype>
#include <cassert>

#include "llvm/ADT/APInt.h"

#include "parser.hpp"
#include "ast.hpp"

enum TokenType {
  LPAREN = 1,
  RPAREN,
  BOOL,
  INT,
  ID,
  IF,
  OP,
  SEQ,
  WHILE,
  UNKNOWN,
  END
};

static int64_t NumVal; 
static int CurTok;
static bool BoolVal;
static std::string Lexeme;
static OpType Op;
static char LastChar = ' ';

static OpType GetOpType(std::string op) {
  if (op == "+") return add;
  if (op == "-") return sub;
  if (op == "*") return mult;
  if (op == "/") return division;
  if (op == "%") return mod;
  if (op == ">") return gt;
  if (op == ">=") return ge;
  if (op == "<") return lt;
  if (op == "<=") return le;
  if (op == "==") return eq;
  if (op == "!=") return neq;
  return unknown;
}

static bool isComment(char c) {
  return c == '#' || c == '.' || c == '$' || c == '^';
}

static int gettok() {
  static int LastChar = getchar();

  if (isComment(LastChar)) {
HandleComment:
    do LastChar = getchar();
    while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');
    if (LastChar != EOF) return gettok();
  }
  
  while (isspace(LastChar)) {
    if (LastChar == '\n' || LastChar == '\r') {
      LastChar = getchar();
      if (isComment(LastChar)) goto HandleComment;
    } else {
      LastChar = getchar();
    }
  }

  if (LastChar == '('){
    Lexeme = LastChar;
    LastChar = getchar();
    return LPAREN;
  } 

  if (LastChar == ')') {
    Lexeme = LastChar;
    LastChar = getchar();
    return RPAREN;
  }

  if (isalpha(LastChar)) {
    Lexeme = LastChar;
    while (isalnum(LastChar = getchar()))
      Lexeme += LastChar;

    if (Lexeme == "if") return IF;
    if (Lexeme == "while") return WHILE;
    if (Lexeme == "seq") return SEQ;
    if (Lexeme == "set") return SET;

    if (Lexeme == "true" || Lexeme == "false") {
      BoolVal = Lexeme == "true";
      return BOOL;
    }
    return ID;
  }

  // Integer
  if (isdigit(LastChar)) {
    Lexeme.clear();
HandleInt:
    do {
      Lexeme += LastChar;
      LastChar = getchar();
    } while (isdigit(LastChar));
    unsigned int bits = APInt::getBitsNeeded(llvm::StringRef(Lexeme), 10);
    if (Lexeme.at(0) == '-') {
      if (Lexeme != "-9223372036854775808" && bits > 64) return UNKNOWN;
    }
    else if (bits > 63)
      return UNKNOWN;
    NumVal = strtoll(Lexeme.c_str(), NULL, 0);
    return INT;
  }

  // Maybe negative number or minus operator
  if (LastChar == '-') {
    Lexeme = LastChar;
    LastChar = getchar();
    if (isdigit(LastChar)) goto HandleInt;
    Op = GetOpType(Lexeme);
    return OP;
  }

  // Other operators
  if (isgraph(LastChar)) {
    Lexeme = LastChar;
    while (isgraph(LastChar = getchar()))
      Lexeme += LastChar;
    if ((Op = GetOpType(Lexeme)) != unknown) 
      return OP;
    return UNKNOWN;
  }

  if (LastChar == EOF)
    return END;

  int ThisChar = LastChar;
  LastChar = getchar();
  return ThisChar;
}

static int getNextToken() {
  return CurTok = gettok();
}

///////////////////////////

std::unique_ptr<ExprAST> LogError(const char* msg) {
  fprintf(stderr, "Error: %s\n", msg);
  return nullptr;
}

static std::vector<char> stack;

static std::unique_ptr<ExprAST> ParseBoolExpr() {
  auto B = std::make_unique<BoolExprAST>(BoolVal);
  getNextToken();
  return std::move(B);
}

static std::unique_ptr<ExprAST> ParseIntExpr() {
  auto I = std::make_unique<IntExprAST>(NumVal);
  getNextToken();
  return std::move(I);
}

static std::unique_ptr<ExprAST> ParseIdentifierExpr() {
  if (Lexeme.at(0) == 'a') {
    assert(Lexeme.size() == 2);
    int n = Lexeme.at(1) - '0';
    assert(n >= 0 && n <= 5);
    getNextToken();
    return std::make_unique<ArgExprAST>(n);
  }
  if (Lexeme.at(0) == 'm') {
    assert(Lexeme.size() == 2);
    assert(n >= 0 && n <= 9);
    getNextToken();
    return std::make_unique<MutableVarExprAST>(Lexeme);
  }
  else {
    return LogError("expected an argument identifier");
  }
}

static std::unique_ptr<ExprAST> ParseSExpr() {
  //printf("ParseSExpr CurTok: %d\n", CurTok);
  if (CurTok == IF) {
    getNextToken(); //eat 'if'
    auto cnd = ParseExpression();
    auto thn = ParseExpression();
    auto els = ParseExpression();
    if (cnd && thn && els)
      return std::make_unique<IfExprAST>(std::move(cnd), std::move(thn), std::move(els));
  }

  if (CurTok == SEQ) {
    getNextToken(); //eat 'seq'
    auto fst = ParseExpression();
    auto snd = ParseExpression();
    if (fst && snd)
      return std::make_unique<SeqExprAST>(std::move(fst), std::move(snd)); 
  }

  if (CurTok == SET) {
    getNextToken();
    auto val = ParseExpression();
    auto var = ParseIdentifierExpr();
    if (val && var)
      return std::make_unique<SetExprAST>(std::move(val), var);
  }

  if (CurTok == WHILE) {
    getNextToken(); //eat 'while'
    auto cnd = ParseExpression();
    auto body = ParseExpression();
    if (cnd && body)
      return std::make_unique<WhileExprAST>(std::move(cnd), std::move(body));
  }

  if (CurTok == OP) {
    OpType thisOp = Op;
    getNextToken(); //eat op
    auto lhs = ParseExpression();
    auto rhs = ParseExpression();
    if (lhs && rhs)
      return std::make_unique<BinaryOpExprAST>(thisOp, std::move(lhs), std::move(rhs));
  }

  return LogError("can not recognize s-exp");
}

static std::unique_ptr<ExprAST> ParseExpression() {
  static std::unique_ptr<ExprAST> LastSExp = nullptr;
  while (CurTok != END) {
    //printf("ParseExpr CurTok: %d\n", CurTok);
    switch (CurTok) {
      case LPAREN:
        stack.push_back('(');
        getNextToken();
        LastSExp = std::move(ParseSExpr());
        if (LastSExp) break;
        return nullptr;
      case RPAREN:
        if (stack.size()>0 && stack.back()=='(') {
          stack.pop_back();
          getNextToken();
          return std::move(LastSExp);
        }
        else {
          return LogError("Parenthesis not match");
        }
      case BOOL:
        return ParseBoolExpr();
      case INT:
        return ParseIntExpr();
      case ID:
        return ParseIdentifierExpr();
      default:
        return LogError("can not parse top-level expression");
    }
  }
  return nullptr;
}

std::unique_ptr<ExprAST> Parse() {
  getNextToken();
  auto E = ParseExpression();
  if (E) {
    while (isspace(LastChar)) LastChar = getchar();
    if (CurTok != END) { return LogError("syntax error"); }
    return E;
  }
  return nullptr;
}

void TestParser() {
  std::unique_ptr<ExprAST> e = std::move(Parse());
  if (e) {
    std::cout << "get: ";
    e->write(std::cout);
  }
}

