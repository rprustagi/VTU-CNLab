# example of loop control structure
#---------------------------------
set N 10

# Using While loop
set ii 1
while {$ii <= $N} {
  puts $ii
  set ii [expr $ii +1]
}
# Using for loop
for {set i 1} {$i <= $N} {incr i} {
  puts "$i"
}
