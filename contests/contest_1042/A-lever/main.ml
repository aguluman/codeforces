(*
	 Codeforces 1042 — Problem A: lever

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

(* Lever algorithm: simulate the process until step 1 is ignored *)
let solve_one_case () =
  let n = FastIO.read_int () in
  let a = FastIO.read_n_ints n in
  let b = FastIO.read_n_ints n in

  let iterations = ref 0 in
  let continue = ref true in

  while !continue do
    incr iterations;

    (* Step 1: Find index where a[i] > b[i] and decrease a[i] by 1 *)
    let step1_done = ref false in
    for i = 0 to n - 1 do
      if (not !step1_done) && a.(i) > b.(i) then (
        a.(i) <- a.(i) - 1;
        step1_done := true)
    done;

    (* If step 1 was ignored (no a[i] > b[i] found), end iterations *)
    if not !step1_done then continue := false
    else
      (* Step 2: Find index where a[i] < b[i] and increase a[i] by 1 *)
      let step2_done = ref false in
      for i = 0 to n - 1 do
        if (not !step2_done) && a.(i) < b.(i) then (
          a.(i) <- a.(i) + 1;
          step2_done := true)
      done
  done;

  Printf.printf "%d\n" !iterations

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
