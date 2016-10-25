#include <iostream>
#include <string>
#include <vector>
#include <cstdio>
#include <cctype>
#include <cassert>

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
  UNKNOWN_OP,
  END
};

static int64_t NumVal; 
static int CurTok;
static bool BoolVal;
static std::string Token;
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
  static int LastChar = ' ';
  while (isspace(LastChar))
    LastChar = getchar();

  if (LastChar == '('){
    Token = LastChar;
    LastChar = getchar();
    return LPAREN;
  } 

  if (LastChar == ')') {
    Token = LastChar;
    LastChar = getchar();
    return RPAREN;
  }

  if (isalpha(LastChar)) {
    Token = LastChar;
    while (isalnum(LastChar = getchar()))
      Token += LastChar;

    if (Token == "if") return IF;

    if (Token == "true" || Token == "false") {
      BoolVal = Token == "true";
      return BOOL;
    }

    return ID;
  }

  // Integer
  if (isdigit(LastChar)) {
    Token.clear();
    do {
      Token += LastChar;
      LastChar = getchar();
    } while (isdigit(LastChar));

    //NumVal = strtod(Token.c_str(), 0);
    NumVal = strtoll(Token.c_str(), NULL, 0);
    return INT;
  }

  // Maybe negative number or minus operator
  if (LastChar == '-') {
    Token = LastChar;
    LastChar = getchar();
    if (isdigit(LastChar)) {
      do {
        Token += LastChar;
        LastChar = getchar();
      } while (isdigit(LastChar));
      //NumVal = strtod(Token.c_str(), 0);
      NumVal = strtoll(Token.c_str(), NULL, 0);
      return INT;
    }
    Op = GetOpType(Token);
    return OP;
  }
  
  // Comment
  if (isComment(LastChar)) {
    do LastChar = getchar();
    while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');
    if (LastChar != EOF)
      return gettok();
  }
  
  // Other operators
  if (isgraph(LastChar)) {
    Token = LastChar;
    while (isgraph(LastChar = getchar()))
      Token += LastChar;
    
    if ((Op = GetOpType(Token)) != unknown) {
      return OP;
    }
    return UNKNOWN_OP;
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
  if (Token.at(0) == 'a') {
    assert(Token.size() == 2);
    int n = Token.at(1) - '0';
    assert(n >= 0 && n <= 5);
    getNextToken();
    return std::make_unique<ArgExprAST>(n);
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
    if (cnd && thn && els) {
      return std::make_unique<IfExprAST>(std::move(cnd), std::move(thn), std::move(els));
    }
  }

  if (CurTok == OP) {
    getNextToken(); //eat op
    auto lhs = ParseExpression();
    auto rhs = ParseExpression();
    if (lhs && rhs) {
      return std::make_unique<BinaryOpExprAST>(Op, std::move(lhs), std::move(rhs));
    }
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

