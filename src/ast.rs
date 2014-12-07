#[deriving(Show)]
pub enum Statement{
	Definition(String,String,Expression),
	Import(String),
}

#[deriving(Show)]
pub enum Expression{
	Unit,
	NumberLiteral(int),
	StringLiteral(String),
	IdentifierLookup(String),
	IdentifierCall(String,Box<Expression>),
	ExpressionCall(Box<Expression>,Box<Expression>),
	OperatorCall(String,Box<Expression>,Box<Expression>),
	LazyExpression(Box<Expression>),
}
