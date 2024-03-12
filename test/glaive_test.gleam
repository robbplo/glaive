import gleeunit
import gleeunit/should
import glaive

pub fn main() {
  gleeunit.main()
}

pub fn read_test() {
  glaive.read("test/fixtures/file1.txt")
  |> should.equal(Ok("we gleamin\n"))

  glaive.read("test/fixtures/does_not_exist.txt")
  |> should.equal(Error(glaive.NoSuchFile))
}

pub fn write_test() {
  glaive.write("test/fixtures/tmp/file2.txt", "we gleamin\n")
  |> should.be_ok()

  glaive.write("/root/no.txt", "we gleamin\n")
  |> should.equal(Error(glaive.NoAccess))

  glaive.read("test/fixtures/tmp/file2.txt")
  |> should.equal(Ok("we gleamin\n"))
}

pub fn rm_test() {
  glaive.write("test/fixtures/tmp/file2.txt", "we gleamin\n")
  |> should.be_ok()

  glaive.rm("test/fixtures/tmp/file2.txt")
  |> should.be_ok()

  glaive.rm("test/fixtures/tmp/file2.txt")
  |> should.equal(Error(glaive.NoSuchFile))
}

pub fn exists_test() {
  glaive.exists("test/fixtures/file1.txt")
  |> should.be_true()

  glaive.exists("test/fixtures/does_not_exist.txt")
  |> should.be_false()

  glaive.exists("t///\\tnawftrs))!@#--2////")
  |> should.be_false()
}

pub fn mkdir_rmdir_test() {
  let _ = glaive.rmdir("test/fixtures/tmp/new")

  glaive.mkdir("test/fixtures/tmp/new")
  |> should.be_ok()

  glaive.exists("test/fixtures/tmp/new")
  |> should.be_true()

  glaive.mkdir("test/fixtures/tmp/new")
  |> should.equal(Error(glaive.AlreadyExists))

  glaive.rmdir("test/fixtures/tmp/new")
  |> should.be_ok()

  glaive.exists("test/fixtures/tmp/new")
  |> should.be_false()

  glaive.mkdir("/root/new")
  |> should.equal(Error(glaive.NoAccess))

  glaive.rmdir("/root/new")
  |> should.equal(Error(glaive.NoAccess))
}
