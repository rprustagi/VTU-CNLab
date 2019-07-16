# simple ping program to understand NS2
# n1<---->n2<---->n3

proc finish { } {
    global ns nf tf f_namtrace
    $ns flush-trace
    close $nf
    close $tf
    exit 0
}

# define procedue for sending packets
proc myping {sender cnt gap} {
  global ns p1
  set num 1
  set now [$ns now]
  set time $now
  while {$cnt > 0} {
    $ns at $time "$sender send"
    #puts "sending from $p1 at $time"
    set time [expr $time + $gap]
    set cnt [expr $cnt - 1]
  }
}
#following procedure is mandatory for ping recv.
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "node [$node_ id] received from $from, with rtt $rtt msec"
}

set f_namtrace "exp02.nam"
set f_pkttrace "exp02.tr"

set ns [ new Simulator ]
set nf [ open $f_namtrace w ]
$ns namtrace-all $nf

set tf [ open $f_pkttrace w ]
$ns trace-all $tf

#create a dummy node since node id starts from 0.
set dummy_node [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$n1 color "blue"
$n2 color "red"
$n3 color "green"
$n4 color "green"
$n5 color "blue"
$n6 color "red"

$ns duplex-link $n1 $n3 1Mb 1ms DropTail
$ns duplex-link $n2 $n3 1Mb 1ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 1ms DropTail
$ns duplex-link $n4 $n5 1Mb 1ms DropTail
$ns duplex-link $n4 $n6 1Mb 1ms DropTail

$ns queue-limit $n3 $n4 3

set ping1s [new Agent/Ping] 
set ping5r [new Agent/Ping]
$ns attach-agent $n1 $ping1s
$ns attach-agent $n5 $ping5r

# Generate ping traffic
$ping1s set packetSize_ 750
$ping1s set fid_ 0 
$ns color 0 "blue"

#setup path between two ping agents and send traffic
$ns connect $ping1s $ping5r
#send some ping packets
myping $ping1s 20 0.007

set udp2s [new Agent/UDP] 
set udp6r [new Agent/Null]
$ns attach-agent $n2 $udp2s
$ns attach-agent $n6 $udp6r
$udp2s set fid_ 1
$ns color 1 "red"

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr set packet_size_ 750
$cbr set interval_ 7ms

#connect udp sender/receiver and generate traffic
$cbr attach-agent $udp2s
$ns connect $udp2s $udp6r
$ns at 0.0 "$cbr start"
$ns at 1.0 "$cbr stop"

#

#define the termination point
$ns at 2.0 "finish"

#start simulator
$ns run

