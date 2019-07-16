# all procedures
# Define a 'finish' procedure
proc finish { } {
  global ns nf tf 
  $ns flush-trace
  close $tf
  close $nf
  exit 0
}

#Make a NS simulator
set ns [new Simulator]
set tfile "tcpcong.tr"
set nfile "tcpcong.nam"

# experiment parmaters
set numconn 3
set conntime 150
#get in seconds for next connection to start.
set conngap 15

# topology parameters
set lanbw 100Mb
set landelay 0.001ms
set wanbw 1Mb
set wandelay 500ms
set qlimit 10

# TCP config params
set tcppktsize 1460
set cwindow 50
set TCPtype "Reno"

puts "Application Runtime parameters are:"
puts "numconn=$numconn, ConnTime=$conntime, conngap=$conngap, InitalCwnd=$cwindow"
puts "LanBW=$lanbw, LanProp=$landelay"
puts "WanBW=$wanbw, WanProp=$wandelay, WanQ=$qlimit"

set tf [open $tfile w]
set nf [open $nfile w]
$ns trace-all $tf
$ns namtrace-all $nf

for {set conn 0} {$conn < $numconn} {incr conn} {
  set cf$conn [open conn_$conn.tr w]
}

# Create the nodes for both the LANs, first for LAN1, and then for LAN2
set lannodes [expr $numconn + 1]
set lan1list ""
set lan2list ""
for {set j 0} {$j < 2} {incr j} {
  for {set i 0} {$i < $lannodes} {incr i} {
    set k [expr $j * $lannodes + $i]
    set n$k [$ns node]
    puts "creating node n$k"
  }
}

# add the nodes to LANs
for {set i 0} {$i < $lannodes} {incr i} {
  set k [expr $lannodes + $i]
  set lan1list "$lan1list [set n[set i]]"
  set lan2list "$lan2list [set n[set k]]"
}
puts "lan1list = $lan1list, lan2list = $lan2list"
set lan1last [expr $lannodes - 1]
set lan2last [expr $lannodes + $lannodes - 1]
puts "lan1last = n$lan1last, lan2last = n$lan2last"

#Creates two lans each of n nodes and connect them via WAN link
$ns make-lan "$lan1list" $lanbw $landelay LL Queue/DropTail Mac/802_3
$ns make-lan "$lan2list" $lanbw $landelay LL Queue/DropTail Mac/802_3
#LanRouter set debug_ 0

# Create the link
puts "link between lan1 last node n$lan1last, and lan2 first node n$lannodes"
$ns duplex-link [set n[set lan1last]] [set n[set lannodes]] $wanbw $wandelay DropTail
$ns queue-limit [set n[set lan1last]] [set n[set lannodes]] $qlimit

# TCP parameters
Agent/TCP set packetSize_ $tcppktsize
Agent/TCP set window_ $cwindow

# Add a TCP sending module to node n0
set endtime $conntime

for {set conn 0} {$conn < $numconn} {incr conn} {
  set tcpsrc$conn [new Agent/TCP/$TCPtype]
  set tcpsnk$conn [new Agent/TCPSink]
  puts "Created tcp connection endpoints tcpsrc$conn, and tcpsnk$conn"

  [set tcpsrc[set conn]] set fid_ $conn
  [set tcpsnk[set conn]] set fid_ $conn

  set j [expr $conn + $lannodes + 1]
  $ns attach-agent [set n[set conn]] [set tcpsrc[set conn]]
  $ns attach-agent [set n[set j]] [set tcpsnk[set conn]]
  puts "Attached tcpsrc$conn to node n$conn, and tcpsnk$conn to node n$j"

  set appftp$conn [new Application/FTP]
  [set appftp[set conn]] attach-agent [set tcpsrc[set conn]]
  puts "Attached appftp$conn to tcpsrc$conn"

  $ns connect [set tcpsrc[set conn]] [set tcpsnk[set conn]]
  puts "Connected tcpsrc$conn to tcpsnk$conn"

  [set tcpsrc[set conn]] attach [set cf[set conn]]
  [set tcpsrc[set conn]] trace cwnd_
  [set tcpsrc[set conn]] trace dupacks_
  [set tcpsrc[set conn]] trace t_seqno_

  set starttime [expr $conn * $conngap]
  $ns at $starttime "[set appftp[set conn]] start"
  puts "Application appftp$conn started at $starttime"

  $ns at $endtime "[set appftp[set conn]] stop"
  puts "Application appftp$conn stopped at $endtime"
}

# Set simulation end time
$ns at [expr $endtime + 5]  "finish"
puts "Simulation stopped at [expr $endtime + 5]"

$ns run
