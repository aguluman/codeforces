(*
	 Codeforces 1047 — Problem D: Replace with Occurrences

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
  let arr = Array.init n (fun i -> (FastIO.read_int (), i)) in
  Array.sort compare arr;

  let a = Array.make n 0 in
  let ok = ref true in
  let label = ref 1 in

  let rec process i =
    if i >= n then ()
    else
      let bk, _ = arr.(i) in
      (* find run [i .. j) with the same b = bk *)
      let j = ref (i + 1) in
      while !j < n && fst arr.(!j) = bk do
        incr j
      done;

      let len = !j - i in
      if len mod bk <> 0 then ok := false
      else
        (* assign in blocks of size bk using a while‐loop *)
        let block_start = ref i in
        while !block_start < !j do
          (* assign this group [block_start .. block_start+bk-1] *)
          for k = 0 to bk - 1 do
            let _, idx = arr.(!block_start + k) in
            a.(idx) <- !label
          done;
          incr label;
          block_start := !block_start + bk
        done;
        process !j
  in

  process 0;

  if not !ok then print_endline "-1"
  else
    for i = 0 to n - 1 do
      Printf.printf "%d%s" a.(i) (if i = n - 1 then "\n" else " ")
    done

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
