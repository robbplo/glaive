import fs.{type OkResult, type Reason}
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
  fs.read_file(path)
  |> map_error
}

pub fn write(path: Path, data: String) -> Result(Nil, FileError) {
  fs.write_file(path, data)
  |> map_ok_result
  |> map_error
}

pub fn rm(path: Path) -> Result(Nil, FileError) {
  fs.delete_file(path)
  |> map_ok_result
  |> map_error
}

pub fn exists(path: Path) -> Bool {
  case fs.read_file_info(path) {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn mkdir(path: Path) -> Result(Nil, FileError) {
  fs.make_dir(path)
  |> map_ok_result
  |> map_error
}

pub fn rmdir(path: Path) -> Result(Nil, FileError) {
  fs.del_dir(path)
  |> map_ok_result
  |> map_error
}

fn map_ok_result(r: OkResult) -> Result(Nil, Reason) {
  case r {
    fs.Ok -> Ok(Nil)
    fs.Error(reason) -> Error(reason)
  }
}

fn map_error(r: Result(a, Reason)) -> Result(a, FileError) {
  result.map_error(r, fn(reason) {
    case reason {
      fs.Enoent -> NoSuchFile
      fs.Eacces -> NoAccess
      fs.Eperm -> PermissionDenied
      fs.Eexist -> AlreadyExists
    }
  })
}
