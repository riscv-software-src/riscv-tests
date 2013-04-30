#!/usr/bin/env scala
!#

val size = args(0).toInt

def print_matrix(name: String, rows: Int, cols: Int, data: Array[Double]) = {
  println("const double " + name + "[DATA_SIZE*DATA_SIZE] = {")
  for (i <- 0 until rows) {
    println(data.slice(cols*i, cols*(i+1)).mkString(", ") + (if (i < rows-1) ", " else ""))
  }
  println("};")
}
def rand_matrix(rows: Int, cols: Int) = {
  var r = new scala.util.Random
  var m = new Array[Double](rows*cols)
  for (i <- 0 until rows*cols)
    m(i) = r.nextInt(1000)
  m
}
def matmul(a: Array[Double], b: Array[Double], m: Int, n: Int, k: Int) = {
  var c = new Array[Double](m*n)
  for (i <- 0 until m)
    for (j <- 0 until n)
      for (l <- 0 until k)
        c(i*n+j) += a(i*n+l)*b(l*k+j)
  c
}

println("#define DATA_SIZE " + size)

val a = rand_matrix(size, size)
val b = rand_matrix(size, size)
val c = matmul(a, b, size, size, size)

print_matrix("input1_data", size, size, a)
print_matrix("input2_data", size, size, b)
print_matrix("verify_data", size, size, c)
