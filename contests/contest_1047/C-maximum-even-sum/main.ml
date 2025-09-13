(*
	 Codeforces 1047 — Problem C: Maximum Even Sum

	 How to use this template:
	 - Implement your solution in the `solve_one_case` function or directly in main.
	 - Choose either single test case or multiple test cases (comment/uncomment below).
	 - Keep I/O fast using the FastIO helpers.
*)

module FastIO = struct
  let sc = Scanf.Scanning.from_channel stdin
  let read_int () = Scanf.bscanf sc " %d" (fun x -> x)
  let read_int64 () = Scanf.bscanf sc " %Ld" (fun x -> x)
end

open Int64

let solve_one_case () =
  let a, b = (FastIO.read_int64 (), FastIO.read_int64 ()) in
  let two = 2L in
  let a_even = rem a two = 0L in
  let b_even = rem b two = 0L in

  if not b_even then
    if a_even then
      (* b is odd, a is even: impossible *)
      Printf.printf "%d\n" (-1)
    else
      (* both odd: answer = a*b + 1 *)
      let prod = mul a b in
      let ans = add prod 1L in
      Printf.printf "%Ld\n" ans
  else
    (* b is even *)
    let b_mod_4_is_0 = rem b 4L = 0L in
    if (not a_even) && not b_mod_4_is_0 then
      (* a odd, b ≡ 2 (mod 4) → impossible *)
      Printf.printf "%d\n" (-1)
    else
      (* maximal even sum at k = b/2: a*(b/2) + 2 *)
      let half_b = div b two in
      let ans = add (mul a half_b) 2L in
      Printf.printf "%Ld\n" ans

let () =
  let t = FastIO.read_int () in
  for _ = 1 to t do
    solve_one_case ()
  done
