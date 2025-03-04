import day1/p2
import gleam/io
import simplifile

pub fn main() {
  let assert Ok(file) = simplifile.read("./input/day1/input.txt")
  let solution = p2.solution(file)
  io.debug(solution)
}
