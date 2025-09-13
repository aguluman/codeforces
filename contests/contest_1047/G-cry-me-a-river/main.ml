(*
  Codeforces 1047 G - Cry Me a River
  Optimized monotone game DP on DAG with incremental red updates.
*)

module Scanner = struct
  let buf_size = 1 lsl 16
  let buf = Bytes.create buf_size
  let len = ref 0
  let pos = ref 0

  let refill () =
    len := input stdin buf 0 buf_size;
    pos := 0

  let ensure () = if !pos >= !len then refill ()

  let read_int () =
    let rec skip () =
      ensure ();
      if !len = 0 then raise End_of_file;
      let c = Bytes.get buf !pos in
      if c <= ' ' then (
        incr pos;
        skip ())
      else c
    in
    let c = skip () in
    let neg =
      if c = '-' then (
        incr pos;
        true)
      else false
    in
    ensure ();
    (* first digit (or following minus) *)
    incr pos;
    let acc = ref (Char.code (Bytes.get buf (!pos - 1)) - 48) in
    let rec loop () =
      ensure ();
      if !len = 0 then ()
      else
        let c = Bytes.get buf !pos in
        if c >= '0' && c <= '9' then (
          incr pos;
          acc := (!acc * 10) + (Char.code c - 48);
          loop ())
    in
    loop ();
    if neg then - !acc else !acc
end

let () =
  let open Scanner in
  let t = read_int () in
  let out_buf = Buffer.create 4096 in
  for _case = 1 to t do
    let n = read_int () in
    let m = read_int () in
    let q = read_int () in

    (* Read edges first into temporary arrays *)
    let from_u = Array.make m 0 in
    let to_v = Array.make m 0 in
    let out_deg = Array.make (n + 1) 0 in
    let in_deg = Array.make (n + 1) 0 in
    for i = 0 to m - 1 do
      let u = read_int () in
      let v = read_int () in
      from_u.(i) <- u;
      to_v.(i) <- v;
      out_deg.(u) <- out_deg.(u) + 1;
      in_deg.(v) <- in_deg.(v) + 1
    done;

    (* Build CSR for forward *)
    let start_out = Array.make (n + 2) 0 in
    for i = 2 to n do
      start_out.(i) <- start_out.(i - 1) + out_deg.(i - 1)
    done;
    let fw = Array.make m 0 in
    let cur = Array.copy start_out in
    for i = 0 to m - 1 do
      let u = from_u.(i) in
      let idx = cur.(u) in
      fw.(idx) <- to_v.(i);
      cur.(u) <- idx + 1
    done;

    (* Build CSR for reverse *)
    let start_rev = Array.make (n + 2) 0 in
    for i = 2 to n do
      start_rev.(i) <- start_rev.(i - 1) + in_deg.(i - 1)
    done;
    let rv = Array.make m 0 in
    let cur_r = Array.copy start_rev in
    for i = 0 to m - 1 do
      let v = to_v.(i) in
      let idx = cur_r.(v) in
      rv.(idx) <- from_u.(i);
      cur_r.(v) <- idx + 1
    done;

    (* Node properties *)
    let is_sink = Array.init (n + 1) (fun i -> i <> 0 && out_deg.(i) = 0) in
    let is_red = Array.make (n + 1) false in

    (* Counters per node *)
    let sink_children = Array.make (n + 1) 0 in
    let red_children = Array.make (n + 1) 0 in
    let r_good_children = Array.make (n + 1) 0 in
    let c_lose_children = Array.make (n + 1) 0 in

    (* Initialize counts: all nodes blue, all non-sink have dp_r true, dp_c true *)
    for u = 1 to n do
      let s = start_out.(u) in
      let e = s + out_deg.(u) - 1 in
      for idx = s to e do
        let v = fw.(idx) in
        if is_sink.(v) then sink_children.(u) <- sink_children.(u) + 1
        else r_good_children.(u) <- r_good_children.(u) + 1
      done
    done;

    let dp_c = Array.make (n + 1) true in
    let dp_r_true = Array.make (n + 1) true in
    (* For sinks we do not use dp arrays; mark dp_r_true false to skip logic *)
    for u = 1 to n do
      if is_sink.(u) then dp_r_true.(u) <- false
    done;

    (* Event stacks *)
    let stack_c = Array.make (n + 5) 0 in
    let top_c = ref 0 in
    let push_c v =
      stack_c.(!top_c) <- v;
      incr top_c
    in
    let stack_r = Array.make (n + 5) 0 in
    let top_r = ref 0 in
    let push_r v =
      stack_r.(!top_r) <- v;
      incr top_r
    in

    (* Propagation loops *)
    let process_events () =
      while !top_c > 0 || !top_r > 0 do
        if !top_c > 0 then (
          (* dp_c became false event *)
          decr top_c;
          let v = stack_c.(!top_c) in
          if (not is_red.(v)) && not is_sink.(v) then
            let s = start_rev.(v) in
            let e = s + in_deg.(v) - 1 in
            for idx = s to e do
              let p = rv.(idx) in
              if (not is_red.(p)) && not is_sink.(p) then (
                c_lose_children.(p) <- c_lose_children.(p) + 1;
                if dp_r_true.(p) && c_lose_children.(p) = 1 then (
                  dp_r_true.(p) <- false;
                  push_r p))
            done)
        else (
          (* dp_r became false event *)
          decr top_r;
          let v = stack_r.(!top_r) in
          if (not is_red.(v)) && not is_sink.(v) then
            let s = start_rev.(v) in
            let e = s + in_deg.(v) - 1 in
            for idx = s to e do
              let p = rv.(idx) in
              if (not is_red.(p)) && not is_sink.(p) then (
                (* remove one r_good child *)
                r_good_children.(p) <- r_good_children.(p) - 1;
                if dp_c.(p) && sink_children.(p) = 0 && r_good_children.(p) = 0
                then (
                  dp_c.(p) <- false;
                  push_c p))
            done)
      done
    in

    for _ = 1 to q do
      let typ = read_int () in
      let u = read_int () in
      if typ = 1 then (
        if not is_red.(u) then (
          is_red.(u) <- true;
          (if is_sink.(u) then
             (* Sink -> parents lose a sink child, gain red child *)
             let s = start_rev.(u) in
             let e = s + in_deg.(u) - 1 in
             for idx = s to e do
               let p = rv.(idx) in
               if (not is_red.(p)) && not is_sink.(p) then (
                 sink_children.(p) <- sink_children.(p) - 1;
                 red_children.(p) <- red_children.(p) + 1;
                 if dp_r_true.(p) && red_children.(p) = 1 then (
                   dp_r_true.(p) <- false;
                   push_r p);
                 if dp_c.(p) && sink_children.(p) = 0 && r_good_children.(p) = 0
                 then (
                   dp_c.(p) <- false;
                   push_c p))
             done
           else
             (* Non-sink node: remove old contributions *)
             let was_dp_r = dp_r_true.(u) in
             let was_dp_c_false = not dp_c.(u) in
             (* If dp_c false, it contributed to c_lose of parents *)
             (* If dp_r true, it contributed to r_good_children of parents *)
             let s = start_rev.(u) in
             let e = s + in_deg.(u) - 1 in
             for idx = s to e do
               let p = rv.(idx) in
               if (not is_red.(p)) && not is_sink.(p) then (
                 if was_dp_c_false then
                   c_lose_children.(p) <- c_lose_children.(p) - 1;
                 if was_dp_r then r_good_children.(p) <- r_good_children.(p) - 1)
             done;
             (* Mark node as red: future logic ignores it. If it was dp_c true, flip now and propagate. *)
             if dp_c.(u) then (
               dp_c.(u) <- false;
               push_c u);
             if dp_r_true.(u) then (
               dp_r_true.(u) <- false;
               push_r u);
             (* Add red child contribution *)
             for idx = s to e do
               let p = rv.(idx) in
               if (not is_red.(p)) && not is_sink.(p) then (
                 red_children.(p) <- red_children.(p) + 1;
                 if dp_r_true.(p) && red_children.(p) = 1 then (
                   dp_r_true.(p) <- false;
                   push_r p);
                 if dp_c.(p) && sink_children.(p) = 0 && r_good_children.(p) = 0
                 then (
                   dp_c.(p) <- false;
                   push_c p))
             done);
          process_events ()))
      else
        (* Query type 2 *)
        let ans =
          if is_red.(u) then "NO"
          else if is_sink.(u) then "YES"
          else if dp_c.(u) then "YES"
          else "NO"
        in
        Buffer.add_string out_buf ans;
        Buffer.add_char out_buf '\n'
    done
  done;
  output_string stdout (Buffer.contents out_buf)
