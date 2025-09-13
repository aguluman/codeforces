(*
	 Codeforces 1047 — Problem A: Collatz Conjecture

	 How to use this template:
	 - Implement your solution in the `solve_one_case` function or directly in main.
	 - Choose either single test case or multiple test cases (comment/uncomment below).
	 - Keep I/O fast using the FastIO helpers.
*)

module FastIO = struct
  let sc = Scanf.Scanning.from_channel stdin
  let read_int () = Scanf.bscanf sc " %d" (fun x -> x)
end

(* Solution: find any initial value that reaches x after k steps *)
let solve_one_case () =
  let k, x = FastIO.read_pair_int () in
  (* Shifting x left by k bits is equivalent to x * 2^k *)
  let ans = x lsl k in
  Printf.printf "%d\n" ans

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
