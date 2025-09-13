(*
	 Codeforces 1042 — Problem B: alternating-series

	 How to use this template:
	 - Implement your solution in the `solve_one_case` function or directly in main.
	 - Choose either single test case or multiple test cases (comment/uncomment below).
	 - Keep I/O fast using the FastIO helpers.
*)

module FastIO = struct
  let sc = Scanf.Scanning.from_channel stdin
  let read_int () = Scanf.bscanf sc " %d" (fun x -> x)
end

(* Your solution logic here. Adapt as needed. *)
let solve_one_case () =
  let n = FastIO.read_int () in
  let buf = Buffer.create (3 * n) in
  if n mod 2 = 1 then
    for
      (* odd n: pattern (-1 3)* ... -1 *)
      i = 1 to n
    do
      if i land 1 = 1 then Buffer.add_string buf "-1"
      else Buffer.add_string buf "3";
      if i <> n then Buffer.add_char buf ' '
    done
  else
    for
      (* even n: positions 1..n-2 like (-1 3)... then -1 2 *)
      i = 1 to n
    do
      if i land 1 = 1 then Buffer.add_string buf "-1"
      else if i = n then Buffer.add_string buf "2"
      else Buffer.add_string buf "3";
      if i <> n then Buffer.add_char buf ' '
    done;
  Buffer.add_char buf '\n';
  Buffer.output_buffer stdout buf

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
