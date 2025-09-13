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
  let read_int64 () = Scanf.bscanf sc " %Ld" (fun x -> x)
  let read_string () = Scanf.bscanf sc " %s" (fun s -> s)
  let read_float () = Scanf.bscanf sc " %f" (fun x -> x)

  let read_pair_int () =
    let a = read_int () in
    let b = read_int () in
    (a, b)

  let read_n_ints n = Array.init n (fun _ -> read_int ())
end

(* Your solution logic here. Adapt as needed. *)
let solve_one_case () =
  (* Example scaffold — replace with actual parsing and logic. *)
  (* let n = FastIO.read_int () in *)
  (* let arr = FastIO.read_n_ints n in *)
  (* Printf.printf "%d\n" n; *)
  ()

let () =
  (* Choose ONE of the styles below. *)

  (* 1) Single test case: *)
  (* solve_one_case (); *)

  (* 2) Multiple test cases: *)
  (*
	let t = FastIO.read_int () in
	for _ = 1 to t do
		solve_one_case ()
	done;
	*)

  (* Remove this noop once you pick a style above. *)
  ()
