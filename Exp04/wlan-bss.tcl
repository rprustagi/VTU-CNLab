# -----------------------------------------------------------------------
# original source : wired-and-wireless.tcl as part of ns2.35 distribution
# -----------------------------------------------------------------------
### This simulation is an example of combination of wired and wireless topologies

global opt
set opt(chan)       Channel/WirelessChannel
set opt(prop)       Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/802_11
set opt(ifq)        Queue/DropTail/PriQueue
set opt(ll)         LL
set opt(ant)        Antenna/OmniAntenna
set opt(x)          500   
set opt(y)          500   
set opt(ifqlen)     50   
set opt(adhocRouting)   DSDV                      
set opt(stop)           100                           

#set opt(nn)        2                       

#  trace and animation files
set tracefd          wlan-bss.tr
set namtracefd       wlan-bss.nam

set ns   [new Simulator]
# set up for hierarchical routing
$ns node-config -addressType hierarchical
AddrParams set domain_num_ 2
lappend cluster_num 2 1
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 1 1 4
AddrParams set nodes_num_ $eilastlevel 

set tracefd  [open $tracefd w]
$ns trace-all $tracefd
set namtracefd [open $namtracefd w]
$ns namtrace-all-wireless $namtracefd $opt(x) $opt(y)


set topo   [new Topography]
$topo load_flatgrid $opt(x) $opt(y)
create-god 2

#create wired nodes
set W0 [$ns node [lindex 0.0.0]]
$W0 set X_ 0.0
$W0 set Y_ 300.0
$W0 label "LAN0"
$W0 color "blue"

  $ns node-config -adhocRouting $opt(adhocRouting) \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propInstance [new $opt(prop)] \
                 -phyType $opt(netif) \
                 -channel [new $opt(chan)] \
                 -topoInstance $topo \
                 -wiredRouting ON \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace OFF

set BS0 [$ns node [lindex 1.0.0]]
$BS0 label "BS0"
$BS0 color "red"

$BS0 random-motion 0 

$BS0 set X_ 50.0
$BS0 set Y_ 200.0
  
#configure for mobilenodes
#$ns node-config -wiredRouting OFF

set n0 [ $ns node [lindex 1.0.1]]
$n0 color "green"
$n0 label "N0"
$n0 set X_ 10.0
$n0 set Y_ 10.0

$ns at 10.0 "$n0 setdest 450.0 100.0 4.0"

$n0 base-station [AddrParams addr2id [$BS0 node-addr]]
$ns duplex-link $W0 $BS0 10Mb 2ms DropTail

# setup TCP connections
set tcp1 [new Agent/TCP]
$tcp1 set fid_ 1
$ns color 1 "green"
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp1
$ns attach-agent $W0 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 15 "$ftp1 start"


$ns at $opt(stop).0000010 "$n0 reset";
$ns at $opt(stop).0000010 "$BS0 reset";

$ns at $opt(stop).1 "puts \"NS EXITING...\" ; $ns halt"

puts "Starting Simulation..."
$ns run
