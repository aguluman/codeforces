(*
	 Codeforces 1047 — Problem B: Fun Permutation

	 How to use this template:
	 - Implement your solution in the `solve_one_case` function or directly in main.
	 - Choose either single test case or multiple test cases (comment/uncomment below).
	 - Keep I/O fast using the FastIO helpers.
*)

module FastIO = struct
  let sc = Scanf.Scanning.from_channel stdin
  let read_int () = Scanf.bscanf sc " %d" (fun x -> x)
  let read_n_ints n = Array.init n (fun _ -> read_int ())
end

let solve_one_case () =
  let n = FastIO.read_int () in
  let p = FastIO.read_n_ints n in
  for i = 0 to n - 1 do
    if i > 0 then print_char ' ';
    print_int (n + 1 - p.(i))
  done;
  print_newline ()

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
