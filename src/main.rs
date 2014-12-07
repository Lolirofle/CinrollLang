#![feature(phase)]

extern crate core;
extern crate libc;
#[phase(plugin)]
extern crate peg_syntax_ext;
extern crate rustc;

use rustc::lib::llvm;

use compiler::IRBuilder;
use rules::{expression,statement};

mod ast;
mod compiler;
peg! rules(r#"
use super::ast;

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
		/ "{" SPACE? "}" { ast::Expression::LazyExpression(box ast::Expression::Unit) }
		/ "{" SPACE? expr:parenthesized_expression SPACE? "}" { ast::Expression::LazyExpression(box expr) }
	) SPACE? { e }

parenthesized_expression -> ast::Expression
	= operator_call
	/ expression

identifier -> String
	= [A-Za-z] [A-Za-z0-9]* { match_str.to_string() }

identifier_call -> ast::Expression
	= name:identifier SPACE? expr:expression { ast::Expression::IdentifierCall(name,box expr) }
	/ name:identifier { ast::Expression::IdentifierLookup(name) }

expression_call -> ast::Expression
	= "(" SPACE? expr_caller:parenthesized_expression SPACE? ")" SPACE? expr:expression { ast::Expression::ExpressionCall(box expr_caller,box expr) }

operator -> String
	= [!@#$%&?,;:+\-*/\^~<=>|]+ { match_str.to_string() }

operator_call -> ast::Expression
	= a:expression SPACE? op:operator SPACE? b:expression { ast::Expression::OperatorCall(op,box a,box b) }

number_literal -> ast::Expression
	= [0-9]+ { ast::Expression::NumberLiteral(from_str::<int>(match_str).unwrap()) }

string_literal -> ast::Expression
	= "\"" str:(("\\\"" / [^\"])*) "\"" { ast::Expression::StringLiteral(String::from_str(match_str)) }

"#)

fn main(){
	println!("{}",expression("0"));
	println!("{}",expression("0123"));
	println!("{}",expression("\"\""));
	println!("{}",expression("\"abcd\""));
	println!("{}",expression("\"It's \\\"okay\\\"\""));
	println!("");

	println!("{}",expression("a"));
	println!("{}",expression("abcd"));
	println!("");

	println!("{}",expression("f x"));
	println!("{}",expression("f(x)"));
	println!("");

	println!("{}",expression("f g x"));
	println!("{}",expression("f(g x)"));
	println!("{}",expression("f(g(x))"));
	println!("");

	println!("{}",expression("(f g) x"));
	println!("");
	
	println!("{}",expression("(a)"));
	println!("{}",expression("(a,b)"));
	println!("{}",expression("(a,b,c)"));
	println!("{}",expression("((a,b),c)"));
	println!("{}",expression("(a,(b,c))"));
	println!("");
	
	println!("{}",statement("fn[int] f[0] = 1"));
	println!("{}",statement("fn f = ()->{}"));
	println!("{}",statement("var x = 2"));
	println!("");

	unsafe{
		llvm::LLVMDumpValue(statement("fn f = ()->{}").unwrap().codegen(&mut compiler::Context::new("main")).unwrap());
	}
}
