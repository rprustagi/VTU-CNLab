#Experiment for sending UDP traffic.
# nodes are connected as n1-->n2

# Procedures used in the code.
proc finish { } {
    global ns nf tf file_namtr
    $ns flush-trace
    close $nf
    close $tf
    exit 0
}

set file_namtr "simpleudp.nam"
set file_pkttr "simpleudp.tr"

# create the ns object and trace files
set ns [ new Simulator ]
set nf [ open $file_namtr w ]
$ns namtrace-all $nf
set tf [ open $file_pkttr w ]
$ns trace-all $tf

# create the nodes and links for traffic
set n1 [$ns node]
set n2 [$ns node]
$n1 color "red"
$n2 color "blue"
$n1 label "sender"
$n2 label "receiver"

$ns duplex-link $n1 $n2 1Mb 100ms DropTail

# define node, and links colors for graph animation
$ns color 1 "green"

# Generate UDP traffic
set udps [new Agent/UDP]
set udpr [new Agent/Null]
$ns attach-agent $n1 $udps
$ns attach-agent $n2 $udpr

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr set packet_size_ 1000
$cbr set interval_ 50ms

$cbr attach-agent $udps
$ns connect $udps $udpr

#Schedule events for the CBR and FTP agents
$ns at 0.0 "$cbr start"
$ns at 1.0 "$cbr stop"

#Print CBR packet size and interval
puts "CBR Packet Size = [$cbr set packet_size_]"
puts "CBR Rate = [$cbr set rate_]"
puts "CBR Interval = [$cbr set interval_]"
puts "CBR Max Pkts = [$cbr set maxpkts_]"
puts "CBR Random Behaviour = [$cbr set random_]"

$ns at 2.0 "finish"
$ns run
#----------------------
