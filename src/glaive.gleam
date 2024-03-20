import file.{type OkResult, type Reason}
import gleam/io
import gleam/result

pub type Path =
  String

pub type FileError {
  NoSuchFile
  NoAccess
  PermissionDenied
  AlreadyExists
}

pub fn read(path: Path) -> Result(String, FileError) {
  file.read_file(path)
  |> map_error
}

pub fn write(path: Path, data: String) -> Result(Nil, FileError) {
  file.write_file(path, data)
  |> map_ok_result
  |> map_error
}

pub fn rm(path: Path) -> Result(Nil, FileError) {
  file.delete_file(path)
  |> map_ok_result
  |> map_error
}

pub fn exists(path: Path) -> Bool {
  case file.read_file_info(path) {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn mkdir(path: Path) -> Result(Nil, FileError) {
  file.make_dir(path)
  |> map_ok_result
  |> map_error
}

pub fn rmdir(path: Path) -> Result(Nil, FileError) {
  file.del_dir(path)
  |> map_ok_result
  |> map_error
}

fn map_ok_result(r: OkResult) -> Result(Nil, Reason) {
  case r {
    file.Ok -> Ok(Nil)
    file.Error(reason) -> Error(reason)
  }
}

fn map_error(r: Result(a, Reason)) -> Result(a, FileError) {
  result.map_error(r, fn(reason) {
    case reason {
      file.Enoent -> NoSuchFile
      file.Eacces -> NoAccess
      file.Eperm -> PermissionDenied
      file.Eexist -> AlreadyExists
    }
  })
}
