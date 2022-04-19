#![allow(unused)]
fn main() {
use std::process::Command;

let mut echo_hello = Command::new("sh");
echo_hello.arg("-c")
          .arg("echo hello");
let hello_1 = echo_hello.output().expect("failed to execute process");
let hello_2 = echo_hello.output().expect("failed to execute process");
}
