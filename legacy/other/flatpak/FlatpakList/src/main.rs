use std::process::Command;
use std::env;
use std::str::Split;
fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

fn main() {
    env::set_var("RUST_BACKTRACE", "1");
    let mut flat = Command::new("flatpak")
        .arg("list")
        .output()
        .expect("failed to execute process");
    let l = flat.split("\n");
    //let hello = flat.output().expect("failed to execute process");
    // println!("{:#?}", flat);
    print_type_of(&flat);
}
