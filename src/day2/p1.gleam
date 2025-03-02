import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn try_next(levels levels: List(Int), next next: Int) {
  case levels {
    [] -> [next] |> Ok
    [last] -> {
      let diff = next - last
      case { -3 <= diff && diff <= -1 } || { 1 <= diff && diff <= 3 } {
        True -> [next, ..levels] |> Ok
        False -> Error(Nil)
      }
    }
    [last, last2, ..] -> {
      let diff = next - last
      let diff2 = last - last2
      case
        { -3 <= diff && diff <= -1 && diff2 < 0 }
        || { 1 <= diff && diff <= 3 && diff2 > 0 }
      {
        True -> [next, ..levels] |> Ok
        False -> Error(Nil)
      }
    }
  }
}

fn is_level_safe_helper(levels: List(Int), acc: List(Int)) -> Bool {
  case levels {
    [first, ..rest] ->
      try_next(acc, first) |> result.is_ok
      && is_level_safe_helper(rest, [first, ..acc])
    _ -> True
  }
}

pub fn is_level_safe(levels levels: List(Int)) {
  is_level_safe_helper(levels, [])
}

pub fn solution(file: String) -> Int {
  let reports =
    string.trim(file)
    |> string.split("\n")
    |> list.map(fn(row) {
      string.split(row, " ")
      |> list.map(fn(num_string) {
        let assert Ok(num) = int.parse(num_string)
        num
      })
    })
  list.count(reports, is_level_safe)
}
