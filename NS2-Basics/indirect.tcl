#indirect access of variables

for {set i 1} {$i <= 3} {incr i} {
  set n$i [expr $i * $i]
}

for {set j 1} {$j <= 3} {incr j} {
  puts "Value of n$j is [set n[set j]]"
}
