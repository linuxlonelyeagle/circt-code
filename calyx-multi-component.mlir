module attributes {calyx.entrypoint = "main"} { 
calyx.component @identity(%in: i32, %go: i1 {go}, %clk: i1 {clk}, %reset: i1 {reset}) -> (%out: i32, %done: i1 {done}) {
  %r.in, %r.write_en, %r.clk, %r.reset, %r.out, %r.done = calyx.register @r : i32, i1, i1, i1, i32, i1
  %c1_1 = hw.constant 1 : i1
  %true = hw.constant true
  calyx.wires {
    calyx.group @save {
      calyx.assign %r.in = %in : i32 
      calyx.assign %r.write_en = %c1_1 : i1 
      calyx.group_done %r.done : i1
   } 
    calyx.assign %out = %r.out :i32
  }

  calyx.control {
    calyx.seq {
      calyx.enable @save
    }
 }
}

calyx.component @main(%go: i1 {go}, %clk: i1 {clk}, %reset: i1 {reset}) -> (%done: i1 {done}) {
  %id.in, %id.go, %id.clk, %id.reset, %id.out, %id.done = calyx.instance @id of @identity : i32, i1, i1, i1, i32, i1
  %r.in, %r.write_en, %r.clk, %r.reset, %r.out, %r.done = calyx.register @r : i32, i1, i1, i1, i32, i1 
  %c1_1 = hw.constant 1 : i1
  %c1_10 = hw.constant 10 : i32

  calyx.wires {
    calyx.group @run_id {
      calyx.assign %id.in = %c1_10 : i32
      calyx.assign %id.go = %c1_1 : i1
      calyx.group_done %id.done : i1
    }

    calyx.group @use_id {
      calyx.assign %r.in = %id.out : i32
      calyx.assign %r.write_en = %c1_1: i1
      calyx.group_done %r.done: i1
    }
  }

  calyx.control {
    calyx.seq {
      calyx.invoke @id(%id.in = %c1_10) -> (i32)
      calyx.invoke @id(%id.in = %c1_10, %id.go = %c1_1) -> (i32, i1) 
      calyx.enable @run_id
      calyx.enable @use_id
    }
  }
}
}
