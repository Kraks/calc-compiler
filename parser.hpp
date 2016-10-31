#include <memory>
#include "ast.hpp"

#ifndef PARSER
#define PARSER

enum TokenType {
  LPAREN = 1,
  RPAREN,
  BOOL,
  INT,
  ID,
  IF,
  OP,
  SEQ,
  SET,
  WHILE,
  UNKNOWN,
  END
};

static std::unique_ptr<ExprAST> ParseBoolExpr();
static std::unique_ptr<ExprAST> ParseIntExpr();
static std::unique_ptr<ExprAST> ParseIdentifierExpr();
static std::unique_ptr<ExprAST> ParseSExpr();
static std::unique_ptr<ExprAST> ParseExpression();

std::unique_ptr<ExprAST> Parse();
void TestParser();
std::unique_ptr<ExprAST> LogError(const char* msg);

#endif
