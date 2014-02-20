#!/usr/bin/env scala

import scala.util.Sorting

val size = args(0).toInt

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

val a = rand_array(size)
val sorted = a.clone()
Sorting.quickSort(sorted)

print_array("input_data_sort", size, a)
print_array("verify_data_sort", size, sorted)
