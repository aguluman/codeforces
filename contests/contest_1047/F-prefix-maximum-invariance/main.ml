(*
  Codeforces 1047 — Problem: F - Prefix Maximum Invariance
*)

module FastIO = struct
  let chunk = 1 lsl 16
  let buf = Bytes.create chunk
  let bi = ref 0
  let bn = ref 0

  let refill () =
    bn := input stdin buf 0 chunk;
    bi := 0

  let read_char () =
    if !bi >= !bn then (
      refill ();
      if !bn = 0 then raise End_of_file);
    let c = Bytes.get buf !bi in
    incr bi;
    c

  let rec skip_blanks () =
    let c = read_char () in
    if c <= ' ' then skip_blanks () else c

  let read_int () =
    let c = skip_blanks () in
    let neg = ref false in
    let d = ref c in
    if !d = '-' then (
      neg := true;
      d := read_char ());
    let v = ref 0 in
    while !d >= '0' && !d <= '9' do
      v := (!v * 10) + Char.code !d - 48;
      try d := read_char () with End_of_file -> d := '\000'
    done;
    if !neg then - !v else !v
end

(* Fenwick tree for range-max query over suffix [val .. max_val]
   Map value v -> idx = max_val - v + 1 so suffix becomes prefix. *)
module FenwickMax = struct
  type t = {
    bit : int array;
    size : int;
  }

  let create n = { bit = Array.make (n + 2) 0; size = n }

  let update f idx value =
    let n = f.size in
    let bit = f.bit in
    let rec loop i =
      if i <= n then (
        if bit.(i) < value then bit.(i) <- value;
        loop (i + (i land -i)))
    in
    loop idx

  let query f idx =
    let bit = f.bit in
    let rec loop i acc =
      if i = 0 then acc
      else
        let acc' = if acc < bit.(i) then bit.(i) else acc in
        loop (i - (i land -i)) acc'
    in
    loop idx 0
end

let compute_prev_ge a n =
  let prev = Array.make (n + 1) 0 in
  let stack = Array.make (n + 5) 0 in
  let top = ref 0 in
  for i = 1 to n do
    while !top > 0 && a.(stack.(!top)) < a.(i) do
      decr top
    done;
    prev.(i) <- (if !top = 0 then 0 else stack.(!top));
    incr top;
    stack.(!top) <- i
  done;
  prev

let solve_one_case () =
  let n = FastIO.read_int () in
  let a = Array.make (n + 1) 0 in
  let b = Array.make (n + 1) 0 in
  for i = 1 to n do
    a.(i) <- FastIO.read_int ()
  done;
  for i = 1 to n do
    b.(i) <- FastIO.read_int ()
  done;

  let prev_ge = compute_prev_ge a n in
  let max_val = 2 * n in
  let bit = FenwickMax.create (max_val + 2) in
  let idx_of v = max_val - v + 1 in

  let ans = ref Int64.zero in
  for i = 1 to n do
    (* Case 1: a_i is a new maximum if l in (prev_ge(i), i]. *)
    (if b.(i) = a.(i) then
       let cnt_l = i - prev_ge.(i) in
       if cnt_l > 0 then
         let mult_r = n - i + 1 in
         ans :=
           Int64.add !ans (Int64.mul (Int64.of_int cnt_l) (Int64.of_int mult_r)));

    (* Case 2: old maximum segment (l ≤ prev_ge(i)): need some earlier a_j ≥ b_i *)
    (if prev_ge.(i) > 0 then
       let need = b.(i) in
       if need <= max_val then
         let rightmost = FenwickMax.query bit (idx_of need) in
         if rightmost > 0 then
           let g = if rightmost < prev_ge.(i) then rightmost else prev_ge.(i) in
           if g > 0 then
             let mult_r = n - i + 1 in
             ans :=
               Int64.add !ans (Int64.mul (Int64.of_int g) (Int64.of_int mult_r)));

    (* Insert current a_i for later queries *)
    FenwickMax.update bit (idx_of a.(i)) i
  done;

  print_endline (Int64.to_string !ans)

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
