#![feature(plugin)]
#![feature(box_syntax)]

extern crate core;
extern crate libc;
#[plugin]
extern crate peg_syntax_ext;
extern crate rustc;

use rustc::lib::llvm;

use compiler::{IRBuilder,IRBuilderExpr};
use rules::{expression,statement};

mod ast;
mod compiler;
peg! rules(r#"
use super::ast;

use core::str::FromStr;
use std::ffi::CString;

SPACE = [ \n\r\t]+

#[pub]
statement -> ast::Statement
	= "import" SPACE module:identifier { ast::Statement::Import(module) }
	/ def_type:identifier (SPACE? "[" SPACE? parenthesized_expression SPACE? "]")? SPACE name:identifier (SPACE? "[" SPACE? parenthesized_expression SPACE? "]")? SPACE? "=" SPACE? expr:parenthesized_expression { ast::Statement::Definition(def_type,name,expr) }

#[pub]
expression -> ast::Expression
	= SPACE? e:(
		  number_literal
		/ string_literal
		/ identifier_call
		/ expression_call
		/ "(" SPACE? ")" { ast::Expression::Unit }
		/ "(" SPACE? expr:parenthesized_expression SPACE? ")" { expr }
		/ "{" SPACE? "}" { ast::Expression::LazyExpression(Box::new(ast::Expression::Unit)) }
		/ "{" SPACE? expr:parenthesized_expression SPACE? "}" { ast::Expression::LazyExpression(Box::new(expr)) }
	) SPACE? { e }

parenthesized_expression -> ast::Expression
	= operator_call
	/ expression

identifier -> CString
	= [A-Za-z] [A-Za-z0-9]* { CString::from_slice(match_str.as_bytes()) }

identifier_call -> ast::Expression
	= name:identifier SPACE? expr:expression { ast::Expression::IdentifierCall(name,Box::new(expr)) }
	/ name:identifier { ast::Expression::IdentifierLookup(name) }

expression_call -> ast::Expression
	= "(" SPACE? expr_caller:parenthesized_expression SPACE? ")" SPACE? expr:expression { ast::Expression::ExpressionCall(Box::new(expr_caller),Box::new(expr)) }

operator -> CString
	= [!@#$%&?,;:+\-*/\^~<=>|]+ { CString::from_slice(match_str.as_bytes()) }

operator_call -> ast::Expression
	= a:expression SPACE? op:operator SPACE? b:expression { ast::Expression::OperatorCall(op,Box::new(a),Box::new(b)) }

number_literal -> ast::Expression
	= [0-9]+ { ast::Expression::NumberLiteral(FromStr::from_str(match_str).unwrap()) }

string_literal_inside -> String
	= ("\\\"" / [^\"])* { String::from_str(match_str) }

string_literal -> ast::Expression
	= "\"" str:string_literal_inside "\"" { ast::Expression::StringLiteral(str) }

"#);

fn main(){
	println!("{:?}",expression("0"));
	println!("{:?}",expression("0123"));
	println!("{:?}",expression("\"\""));
	println!("{:?}",expression("\"abcd\""));
	println!("{:?}",expression("\"It's \\\"okay\\\"\""));
	println!("");

	println!("{:?}",expression("a"));
	println!("{:?}",expression("abcd"));
	println!("");

	println!("{:?}",expression("f x"));
	println!("{:?}",expression("f(x)"));
	println!("");

	println!("{:?}",expression("f g x"));
	println!("{:?}",expression("f(g x)"));
	println!("{:?}",expression("f(g(x))"));
	println!("");

	println!("{:?}",expression("(f g) x"));
	println!("");
	
	println!("{:?}",expression("(a)"));
	println!("{:?}",expression("(a,b)"));
	println!("{:?}",expression("(a,b,c)"));
	println!("{:?}",expression("((a,b),c)"));
	println!("{:?}",expression("(a,(b,c))"));
	println!("");
	
	println!("{:?}",statement("fn[int] f[0] = 1"));
	println!("{:?}",statement("fn f = ()->{}"));
	println!("{:?}",statement("var x = 2"));
	println!("");

	let mut context = compiler::Context::new("main");
	let f = statement("fn f = ()->{}");
	println!("{:?}",f);

	unsafe{
		llvm::LLVMDumpValue(f.unwrap().codegen(&mut context).unwrap());
		llvm::LLVMDumpValue(expression("50").unwrap().codegen(None,&mut context).unwrap());
		llvm::LLVMDumpValue(expression("\"Yeah, I think so\"").unwrap().codegen(None,&mut context).unwrap());
		llvm::LLVMDumpValue(expression("f()").unwrap().codegen(None,&mut context).unwrap());
	}
}
