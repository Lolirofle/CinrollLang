use core::ptr;
use libc::types::os::arch::c95::c_uint;
use rustc::lib::llvm;
use std::collections::HashMap;

use ast;

//TODO: Use https://github.com/jauhien/iron-kaleidoscope as reference

pub trait IRBuilder{
	fn codegen(&self, context: &mut Context) -> Result<llvm::ValueRef, String>;
}

pub trait IRBuilderExpr{
	fn codegen(&self,  type_hint: Option<String>, context: &mut Context) -> Result<llvm::ValueRef, String>;
}

pub struct Context{
	context: llvm::ContextRef,
	module : llvm::ModuleRef,
	builder: llvm::BuilderRef,
	scope  : HashMap<String, llvm::ValueRef>
}

impl Context{
	pub fn new(module_name : &str) -> Context{unsafe{
		let context = llvm::LLVMContextCreate();

		Context{
			context: context,
			module : llvm::LLVMModuleCreateWithNameInContext(module_name.as_ptr() as *const i8, context),
			builder: llvm::LLVMCreateBuilderInContext(context),
			scope  : HashMap::new()
		}}
	}

	pub fn dump(&self){unsafe{
		llvm::LLVMDumpModule(self.module);
	}}
}

impl Drop for Context{
	fn drop(&mut self){unsafe{
		llvm::LLVMDisposeBuilder(self.builder);
		llvm::LLVMDisposeModule(self.module);
		llvm::LLVMContextDispose(self.context);
	}}
}

impl IRBuilder for ast::Statement{
	fn codegen(&self, context: &mut Context) -> Result<llvm::ValueRef, String>{unsafe{
		match self{
			&ast::Statement::Definition(ref ty,ref name,ast::Expression::OperatorCall(ref op,ref param,ref body)) if ty.as_bytes()=="fn".as_bytes() && op.as_bytes()=="->".as_bytes() => {
				Ok(llvm::LLVMAddFunction(
					//Module scope
					context.module,

					//Function name
					name.as_ptr() as *const i8,

					//Function type
					llvm::LLVMFunctionType(
						//Return type
						llvm::LLVMDoubleTypeInContext(context.context),

						//Parameter type
						ptr::null(),

						//Parameters count
						0 as c_uint,

						//Whether parameter is of variable length
						false as c_uint
					)
				))
			},
			_ => Err("Not implemented codegen".to_string())
		}
	}}
}

impl IRBuilderExpr for ast::Expression{
	fn codegen(&self, type_hint: Option<String>, context: &mut Context) -> Result<llvm::ValueRef, String>{unsafe{
		match self{
			&ast::Expression::NumberLiteral(n) => {
				Ok(llvm::LLVMConstInt(
					//Type
					llvm::LLVMIntTypeInContext(
						//Context
						context.context,

						//Bits
						32
					),

					//Value
					n as u64,

					//Sign?
					true as c_uint
				))
			},
			&ast::Expression::StringLiteral(ref str) => {
				Ok(llvm::LLVMConstStringInContext(
					context.context,

					//Data
					str.as_bytes().as_ptr() as *const i8,

					//Data length
					str.len() as u32,

					//Whether it should not null terminate
					true as c_uint
				))
			},
			&ast::Expression::IdentifierCall(ref name,ref args) => {
				let function = llvm::LLVMGetNamedFunction(context.module,name.as_bytes().as_ptr() as *const i8);

				if function.is_null(){
					return Err("Function is not defined".to_string());
				}
				
				let args_values = match args{
					&box ast::Expression::Unit => Vec::new(),
					//Tuple => args.iter().map(|arg| arg.codegen(None,context));
					expr => vec!(try!(expr.codegen(None,context)))
				};

				Ok(llvm::LLVMBuildCall(
					context.builder,

					//Function?
					function,

					//Arguments
					args_values.as_ptr(),

					//Argument count
					args_values.len() as u32,

					//Function name
					name.as_bytes().as_ptr() as *const i8
				))
			},
			_ => Err("Not implemented codegen".to_string())
		}
	}}
}
