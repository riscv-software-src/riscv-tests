#!/usr/bin/env scala

import scala.util.Sorting

if(args.size < 2) {
  println("Usage: sort_gendata <# elements> <# trials>")
  System.exit(1)
}

val size = args(0).toInt
val trials = args(1).toInt

def rand_array(size: Int) = {
  var r = new scala.util.Random
  Array.fill(size) { r.nextFloat() }
}

def print_array(name: String, size: Int, arr: Array[Float]) {
  println("float "+name+"["+size+"] = {")
  for(i <- 0 to size-2)
    println("  "+arr(i)+",")
  println("  "+arr(size-1)+"\n};\n")
}

println("#define DATA_SIZE_SORT " + size)
println("#define TRIALS_SORT " + trials)

val a = rand_array(size * trials)

print_array("input_data_sort", size * trials, a)
