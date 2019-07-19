if {$argc != 1} {
  puts "Please specify output file prefix as first argument"
  exit
} else {
  set prefix [lindex $argv 0]
}

set stoptime 100;  # Stop time.

# Topology
source ./$prefix.params

# Active Queue Mgmt (AQM parameters)
set minthresh 30
set maxthresh 0
set adaptive 1;  # 1 for Adaptive RED, 0 for plain RED

set delayLen ""
set delayInt ""

# Traffic generation.
set window 30;   # window for long-lived traffic

# Plotting statistics.
set opt(wrap) $stoptime;   # wrap plots?
set opt(srcTrace) isp;   # where to plot traffic
set opt(dstTrace) bs;   # where to plot traffic

# queue size
set ql($type) 10

set ns [new Simulator]
set tf [open $prefix.tr w]
$ns trace-all $tf
set nf [open $prefix.nam w]
$ns namtrace-all $nf

set nodes(isp) [$ns node]
$nodes(isp) label "isp"
set nodes(ms) [$ns node]
$nodes(ms) label "ms"
set nodes(bs) [$ns node]
$nodes(bs) label "bs"
set nodes(lp) [$ns node]
$nodes(lp) label "lp"

puts "$prefix Cell Topology"


# RED and TCP parameters
Queue/RED set summarystats_ true
Queue/RED set adaptive_ $adaptive
Queue/RED set q_weight_ 0.0 
Queue/RED set thresh_ $minthresh
Queue/RED set maxthresh_ $maxthresh

# Set up TCP connection characteristics
set tcpTick 0.01
set pktSize 1460
Agent/TCP set window_ $window
Agent/TCP set packetSize_ $pktSize


#Create topology
#topology cellular "access link"
#                           is
#                           /
#   3Mb,10ms    xMb,yms    / 3Mb,50ms
# lp--------ms --------- bs
#                          \ 3Mb,50ms
#                           \
#                           x
#

$ns duplex-link $nodes(lp) $nodes(ms) 3Mbps 10ms DropTail
$ns duplex-link $nodes(ms) $nodes(bs) 1 1 RED
$ns duplex-link $nodes(bs) $nodes(isp) 3Mbps 50ms DropTail

#set_link_params 
$ns bandwidth $nodes(bs) $nodes(ms) $bwDL($type) simplex
$ns bandwidth $nodes(ms) $nodes(bs) $bwUL($type) simplex
$ns delay $nodes(bs) $nodes(ms) $propDL($type) simplex
$ns delay $nodes(ms) $nodes(bs) $propUL($type) simplex
$ns queue-limit $nodes(bs) $nodes(ms) $ql($type)
set delayerDL [new Delayer]
set delayerUL [new Delayer]
$ns insert-delayer $nodes(bs) $nodes(ms) $delayerDL
$ns insert-delayer $nodes(ms) $nodes(bs) $delayerUL

if {$allocDelayDLAvg != "" && $allocHoldDLAvg != ""} {
  set al_dl [new RandomVariable/Exponential]
  $al_dl set avg_ $allocDelayDLAvg
  set ah_dl [new RandomVariable/Exponential]
  $ah_dl set avg_ $allocHoldDLAvg
  $delayerDL alloc $ah_dl $al_dl
}
#
if {$allocDelayULAvg != "" && $allocHoldULAvg != ""} {
  set al_ul [new RandomVariable/Exponential]
  $al_ul set avg_ $allocDelayULAvg
  set ah_ul [new RandomVariable/Exponential]
  $ah_ul set avg_ $allocHoldULAvg
  $delayerUL alloc $ah_ul $al_ul
}

proc insertDelay {} {
  global dist_len dist_int delayerDL delayerUL ns

  $delayerDL block
  $delayerUL block

  set len [$dist_len value]
  $ns after $len "$delayerUL unblock"
  $ns after $len "$delayerDL unblock"
  set next [expr $len + [$dist_int value]]
  $ns after $next "insertDelay"
}

set dist_len [new RandomVariable/Exponential]
set dist_int [new RandomVariable/Exponential]
if {$delayLen != "" && $delayInt != ""} {
  $dist_len set avg_ $delayLen
  $dist_int set avg_ $delayInt
  $ns after [$dist_int value] "insertDelay"
}

set tcp1 [$ns create-connection TCP/Sack1 $nodes(isp) TCPSink/Sack1 $nodes(lp) 0]
set ftp1 [[set tcp1] attach-app FTP]
$ns at 1.0 "[set ftp1] start"

proc stop {} {
    global nodes opt tf prefix
    set wrap $opt(wrap)
    set sid [$nodes($opt(srcTrace)) id]
    set did [$nodes($opt(dstTrace)) id]

    set GETRC "~/bin/getrc"
    set RAW2XG "~/bin/raw2xg"

    # need to run here to use sid and did variables
    exec $GETRC -s $sid -d $did -f 0 $prefix.tr | \
    $RAW2XG -s 0.01  -q > [set prefix]plot.xgr
    exec $GETRC -s $did -d $sid -f 0 $prefix.tr | \
    $RAW2XG -a -s 0.01 -q >> [set prefix]plot.xgr
    #exec xgraph -t $prefix -x time -y packets [set prefix]plot.xgr &

    exit 0
}
$ns at $stoptime "stop"
$ns run

