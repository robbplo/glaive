//// Filesystem operations

import gleam/dynamic.{type Dynamic}

/// The result for operations that return 'ok' on success.
/// This is wrapped in a custom result type because Gleam does not support atoms.
pub type OkResult {
  Ok
  Error(Reason)
}

/// The reason why an operation failed
pub type Reason {
  Enoent
  Eacces
  Eexist
  Eperm
}

pub type File =
  String

@external(erlang, "file", "read_file_info")
pub fn read_file_info(file: File) -> Result(Dynamic, String)

@external(erlang, "file", "read_file")
pub fn read_file(file: File) -> Result(String, Reason)

@external(erlang, "file", "write_file")
pub fn write_file(file: File, content: String) -> OkResult

@external(erlang, "file", "delete")
pub fn delete_file(file: File) -> OkResult

@external(erlang, "file", "make_dir")
pub fn make_dir(file: File) -> OkResult

@external(erlang, "file", "del_dir")
pub fn del_dir(file: File) -> OkResult
