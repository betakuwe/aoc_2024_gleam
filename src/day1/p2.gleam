import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn solution(filepath) {
  let assert Ok(file) = simplifile.read(filepath)
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
  let right_counts =
    list.fold(right, dict.new(), fn(counts_dict, elem) {
      dict.upsert(counts_dict, elem, fn(count_opt) {
        case count_opt {
          Some(count) -> count + 1
          None -> 1
        }
      })
    })
  list.map(left, fn(elem) {
    dict.get(right_counts, elem)
    |> result.map(fn(count) { count * elem })
    |> result.unwrap(0)
  })
  |> list.fold(0, fn(a, b) { a + b })
}
