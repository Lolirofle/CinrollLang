use std::ffi::CString;

#[derive(Debug)]
pub enum Statement{
	Definition(CString,CString,Expression),
	Import(CString),
}

#[derive(Debug)]
pub enum Expression{
	Unit,
	NumberLiteral(isize),
	StringLiteral(String),
	FunctionLiteral(Box<Expression>),
	IdentifierLookup(CString),
	IdentifierCall(CString,Box<Expression>),
	ExpressionCall(Box<Expression>,Box<Expression>),
	OperatorCall(CString,Box<Expression>,Box<Expression>),
	LazyExpression(Box<Expression>),
}
