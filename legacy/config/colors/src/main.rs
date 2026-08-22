use clap::{Arg, Command};

fn main() {
  let mut height = 3;
  let matches = Command::new("rsPanes")
        .version("0.1.0")
        .author("motan and arctesian")
        .about("copy of a clone that i stole")
        .arg(Arg::new("height")
                 .short('h')
                 .long("height")
                 .takes_value(true)
                 .help("height of the panes"))
        .get_matches();
  let height_str = matches.value_of("height");
  match height_str {
    None => {
      println!("no height provided, using default");
    }
    Some(s) => {
      match s.parse::<i32>() {
        Ok(n) => {
          if n<3 {
            println!("supplied height of {n} must be larger than 2, using default");
          } else {
            height = n-2;
          }
        },
        Err(_) => {
          println!("height must be a number, using default");
          height = 3;
        }
      }
    }
  }
  
  use colored::Colorize;
  //define color blocks
  let black1 = "███".bright_black(); let black2 = "█".black(); let black3 = " ███".black();
  let red1 = "███".bright_red(); let red2 = "█".red(); let red3 = " ███".red();
  let green1 = "███".bright_green(); let green2 = "█".green(); let green3 = " ███".green();
  let yellow1 = "███".bright_yellow(); let yellow2 = "█".yellow(); let yellow3 = " ███".yellow();
  let blue1 = "███".bright_blue(); let blue2 = "█".blue(); let blue3 = " ███".blue();
  let magenta1 = "███".bright_magenta(); let magenta2 = "█".magenta(); let magenta3 = " ███".magenta();
  let cyan1 = "███".bright_cyan(); let cyan2 = "█".cyan(); let cyan3 = " ███".cyan();
  let white1 = "███".bright_white(); let white2 = "█".white(); let white3 = " ███".white();
  println!("{black1}   {red1}   {green1}   {yellow1}   {blue1}   {magenta1}   {cyan1}   {white1}");
  loop {
    if height > 0 {
      println!("{black1}{black2}  {red1}{red2}  {green1}{green2}  {yellow1}{yellow2}  {blue1}{blue2}  {magenta1}{magenta2}  {cyan1}{cyan2}  {white1}{white2}");
      height -= 1;
    } else {
      println!("{black3}  {red3}  {green3}  {yellow3}  {blue3}  {magenta3}  {cyan3}  {white3}");
      break;
    }
  }
}
