# simple program explaining use of procedures.
# computes powers of base.
proc pow {base exp} {
  set result 1
  while {$exp > 0} {
    set result [expr $result * $base]
    set exp [expr $exp - 1]
  }
  return $result 
}

# invocation of procedure
puts "Number of square in chessboard = [pow 2 6]"

# integer powers
set max_byte [pow 2 8]
set max_short [pow 2 16]
set max_int [pow 2 32]
puts "max value of byte, short and int are $max_byte, $max_short, $max_int"

