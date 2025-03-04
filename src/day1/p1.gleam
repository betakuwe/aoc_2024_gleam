import gleam/int
import gleam/list
import gleam/regexp
import gleam/string

pub fn solution(file) {
  let assert Ok(whitespace_regex) = regexp.from_string("\\s+")
  let assert [left, right] =
    string.trim(file)
    |> string.split("\n")
    |> list.map(fn(row) {
      regexp.split(whitespace_regex, row)
      |> list.map(fn(num_string) {
        let assert Ok(num) = int.parse(num_string)
        num
      })
    })
    |> list.transpose
    |> list.map(list.sort(_, int.compare))
  list.map2(left, right, fn(a, b) {
    case a < b {
      True -> b - a
      False -> a - b
    }
  })
  |> list.fold(0, fn(a, b) { a + b })
}
