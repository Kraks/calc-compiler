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


std::unique_ptr<ExprAST> Parse();
void TestParser();
std::unique_ptr<ExprAST> LogError(const char* msg);

#endif
