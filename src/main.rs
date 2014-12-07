#![feature(phase)]

#[phase(plugin)]
extern crate peg_syntax_ext;

use cinroll::{expression,statement};

#[deriving(Show)]
enum Statement{
	Definition(String,String,Expression),
	Import(String),
}

#[deriving(Show)]
enum Expression{
	NumberLiteral(int),
	IdentifierLookup(String),
	IdentifierCall(String,Box<Expression>),
	ExpressionCall(Box<Expression>,Box<Expression>),
	OperatorCall(String,Box<Expression>,Box<Expression>),
}

peg! cinroll(r#"
SPACE = [ \n\r\t]+

#[pub]
statement -> super::Statement
	= "import" SPACE module:identifier { super::Statement::Import(module) }
	/ def_type:identifier (SPACE? "[" SPACE? expression SPACE? "]")? SPACE name:identifier (SPACE? "[" SPACE? expression SPACE? "]")? (SPACE? "(" SPACE? expression SPACE? ")")? SPACE? "=" SPACE? expr:expression { super::Statement::Definition(def_type,name,expr) }

#[pub]
expression -> super::Expression
	= SPACE? e:(
		  number
		/ identifier_call
		/ expression_call
		/ "(" SPACE? expr:parenthesized_expression SPACE? ")" { expr }
	) SPACE? { e }

parenthesized_expression -> super::Expression
	= operator_call
	/ expression

identifier -> String
	= [A-Za-z] [A-Za-z0-9]* { match_str.to_string() }

identifier_call -> super::Expression
	= name:identifier SPACE? expr:expression { super::Expression::IdentifierCall(name,box expr) }
	/ name:identifier { super::Expression::IdentifierLookup(name) }

expression_call -> super::Expression
	= "(" SPACE? expr_caller:parenthesized_expression SPACE? ")" SPACE? expr:expression { super::Expression::ExpressionCall(box expr_caller,box expr) }

operator -> String
	= [+\-*/,=%&$@!\^;:~#]+ { match_str.to_string() }

operator_call -> super::Expression
	= a:expression SPACE? op:operator SPACE? b:expression { super::Expression::OperatorCall(op,box a,box b) }

number -> super::Expression
	= [0-9]+ { super::Expression::NumberLiteral(from_str::<int>(match_str).unwrap()) }
"#)

fn main(){
	println!("{}",expression("0"));
	println!("{}",expression("0123"));
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
	println!("{}",expression("(a,b)"));
	println!("");
	
	println!("{}",statement("fn[int] f[0](i) = 1"));
	println!("{}",statement("var x = 2"));
	println!("");
}
