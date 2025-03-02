/// Checks levels in a single pass (O(n)) without risk of stack overflow if the list is hypothetically long.
import day2/p1.{is_level_safe as is_level_safe_old, try_next}
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn need_to_skip(levels: List(Int), fail_level: Int, passed: List(Int)) {
  //    passed | fail_level | levels
  // ..., a, b | c          | d, ...
  //             ^
  //             fails here, skipping c, b, or a if yet to skip
  case levels {
    [] -> True
    [d, ..levels_rest] -> {
      let try_skip = {
        // skip c
        let skip_c = try_next(passed, d)
        use <- result.lazy_or(skip_c)
        // skip b
        let skip_b =
          list.rest(passed)
          |> result.try(try_next(_, fail_level))
          |> result.try(try_next(_, d))
        use <- result.lazy_or(skip_b)
        // skip a if a is at the start
        case passed {
          [b, _] ->
            try_next([b], fail_level)
            |> result.try(try_next(_, d))
          _ -> Error(Nil)
        }
      }
      case try_skip {
        Ok(next_passed) -> is_level_safe_helper(levels_rest, next_passed, True)
        Error(Nil) -> False
      }
    }
  }
}

fn is_level_safe_helper(levels: List(Int), passed: List(Int), skipped: Bool) {
  case levels {
    [first, ..rest] -> {
      case try_next(passed, first) {
        Ok(next_passed) -> is_level_safe_helper(rest, next_passed, skipped)
        Error(_) if skipped -> False
        Error(_) -> need_to_skip(rest, first, passed)
      }
    }
    _ -> True
  }
}

fn is_level_safe(levels levels: List(Int)) -> Bool {
  is_level_safe_helper(levels, [], False)
}

fn is_level_safe_slow(levels levels: List(Int)) {
  list.combinations(levels, list.length(levels) - 1)
  |> list.any(is_level_safe_old)
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
  list.each(reports, fn(levels) {
    let slow = is_level_safe_slow(levels)
    let fast = is_level_safe(levels)
    use <- bool.guard(slow == fast, Nil)
    io.debug(levels)
    io.debug(
      "slow " <> bool.to_string(slow) <> "\nfast " <> bool.to_string(fast),
    )
    Nil
  })
  list.count(reports, is_level_safe)
}
