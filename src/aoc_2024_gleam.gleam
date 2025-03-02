import day2/p2
import gleam/io
import simplifile

pub fn main() {
  let assert Ok(file) = simplifile.read("./input/day2/input.txt")
  let solution = p2.solution(file)
  io.debug(solution)
}
