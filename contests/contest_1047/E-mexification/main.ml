(*
	 Codeforces 1047 — Problem E: Mexification

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

open Int64

let solve_one_case () =
  let n = FastIO.read_int () in
  let k = FastIO.read_int () in
  let a = FastIO.read_n_ints n in

  (* First pass: build freq[0..n+1] and find mex0 *)
  let freq = Array.make (n + 2) 0 in
  Array.iter (fun x -> freq.(x) <- freq.(x) + 1) a;
  let mex0 = ref 0 in
  while freq.(!mex0) > 0 do
    incr mex0
  done;

  (* Build b1 and sum1 *)
  let b1 = Array.make n 0 in
  let sum1 = ref 0L in
  for i = 0 to n - 1 do
    let x = a.(i) in
    let y = if freq.(x) = 1 && x < !mex0 then x else !mex0 in
    b1.(i) <- y;
    sum1 := add !sum1 (of_int y)
  done;

  (* If k is odd, result = sum1 *)
  if k land 1 = 1 then Printf.printf "%Ld\n" !sum1
  else
    (* Second pass: build freq1 over b1 and find mex1 *)
    let freq1 = Array.make (n + 2) 0 in
    Array.iter (fun x -> freq1.(x) <- freq1.(x) + 1) b1;
    let mex1 = ref 0 in
    while freq1.(!mex1) > 0 do
      incr mex1
    done;

    (* Build b2 and sum2 *)
    let sum2 = ref 0L in
    for i = 0 to n - 1 do
      let x = b1.(i) in
      let y = if freq1.(x) = 1 && x < !mex1 then x else !mex1 in
      sum2 := add !sum2 (of_int y)
    done;
    Printf.printf "%Ld\n" !sum2

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
