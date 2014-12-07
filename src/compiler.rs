use core::ptr;
use libc::types::os::arch::c95::c_uint;
use rustc::lib::llvm;
use std::collections::HashMap;

use ast;

//TODO: Use https://github.com/jauhien/iron-kaleidoscope as reference

pub trait IRBuilder{
	fn codegen(&self, context: &mut Context) -> Result<llvm::ValueRef, String>;
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
			module : llvm::LLVMModuleCreateWithNameInContext(module_name.to_c_str().as_ptr(), context),
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
			&ast::Statement::Definition(ref ty,ref name,ast::Expression::OperatorCall(ref op,ref param,ref body)) if ty.as_slice()=="fn" && op.as_slice()=="->" => {
				let ty = llvm::LLVMDoubleTypeInContext(context.context);

				Ok(llvm::LLVMAddFunction(
					context.module,
					name.to_c_str().as_ptr(),
					llvm::LLVMFunctionType(
						ty,
						ptr::null(),
						0 as c_uint,
						false as c_uint
					)
				))
			},
			_ => Err("Not implemented codegen".to_string())
		}
	}}
}
