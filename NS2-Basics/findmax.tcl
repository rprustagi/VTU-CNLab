# find max of 3 numbers
proc findmax {a b c} { 
  if {$a < $b} {
    if {$b < $c} {
      set max $c
    } else {
      set max $b
    }
  } else {
    if {$a < $c} {
      set max $c
    } else {
      set max $a
    }
  }
  return $max
}

set v1 5
set v2 9
set v3 6

puts "Max of $v1, $v2, $v3 is [findmax $v1 $v2 $v3]"
