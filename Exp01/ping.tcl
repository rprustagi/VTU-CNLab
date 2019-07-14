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

set f_namtrace "ping.nam"
set f_pkttrace "ping.tr"

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
$n1 color "blue"
$n2 color "yellow"
$n3 color "green"

set pings [new Agent/Ping] 
set pingr [new Agent/Ping]
$ns attach-agent $n1 $pings
$ns attach-agent $n3 $pingr

$ns duplex-link $n1 $n2 4Mb 5ms DropTail
$ns duplex-link $n2 $n3 1Mb 20ms DropTail

# Generate ping traffic
$pings set packetSize_ 1000
$pings set fid_ 0 
$ns color 0 "red"

$ns queue-limit $n1 $n2 3
$ns queue-limit $n2 $n3 2

#setup path between two ping agents
$ns connect $pings $pingr

#send some ping packets
myping $pings 20 0.005

#define the termination point
$ns at 2.0 "finish"

#start simulator
$ns run

