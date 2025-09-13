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

let mex_from_freq freq =
  let m = ref 0 in
  let len = Array.length freq in
  while !m < len && freq.(!m) > 0 do
    incr m
  done;
  !m

let solve_one_case () =
  let n = FastIO.read_int () in
  let k = FastIO.read_int () in
  let a = FastIO.read_n_ints n in

  (* Step 1 *)
  let freq = Array.make (n + 3) 0 in
  Array.iter (fun x -> freq.(x) <- freq.(x) + 1) a;
  let mex0 = mex_from_freq freq in
  let b1 = Array.make n 0 in
  let sum1 = ref 0L in
  for i = 0 to n - 1 do
    let x = a.(i) in
    let y = if x < mex0 && freq.(x) = 1 then x else mex0 in
    b1.(i) <- y;
    sum1 := add !sum1 (of_int y)
  done;
  if k = 1 then Printf.printf "%Ld\n" !sum1
  else
    (* Step 2 from b1 *)
    let freq1 = Array.make (n + 3) 0 in
    Array.iter (fun x -> freq1.(x) <- freq1.(x) + 1) b1;
    let mex1 = mex_from_freq freq1 in
    let b2 = Array.make n 0 in
    let sum2 = ref 0L in
    for i = 0 to n - 1 do
      let x = b1.(i) in
      let y = if x < mex1 && freq1.(x) = 1 then x else mex1 in
      b2.(i) <- y;
      sum2 := add !sum2 (of_int y)
    done;
    (* Step 3 from b2 *)
    let freq2 = Array.make (n + 4) 0 in
    Array.iter (fun x -> freq2.(x) <- freq2.(x) + 1) b2;
    let mex2 = mex_from_freq freq2 in
    let sum3 = ref 0L in
    let b3 = Array.make n 0 in
    let changed2to3 = ref false in
    for i = 0 to n - 1 do
      let x = b2.(i) in
      let y = if x < mex2 && freq2.(x) = 1 then x else mex2 in
      b3.(i) <- y;
      if y <> x then changed2to3 := true;
      sum3 := add !sum3 (of_int y)
    done;
    if not !changed2to3 then
      (* Stabilized at step2 *)
      Printf.printf "%Ld\n" !sum2
    else
      (* Determine which 2-cycle: compare b3 with b1 *)
      let same_b3_b1 = ref true in
      let i = ref 0 in
      while !same_b3_b1 && !i < n do
        if b3.(!i) <> b1.(!i) then same_b3_b1 := false;
        incr i
      done;
      if !same_b3_b1 then
        if
          (* Cycle: b1 <-> b2 starting at step1 *)
          k land 1 = 1
        then Printf.printf "%Ld\n" !sum1
        else Printf.printf "%Ld\n" !sum2
      else if
        (* Cycle: b2 <-> b3 starting at step2 *)
        k land 1 = 0
      then Printf.printf "%Ld\n" !sum2
      else Printf.printf "%Ld\n" !sum3

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
