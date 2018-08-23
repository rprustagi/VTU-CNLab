# Exp10: UDP Socket programs
This exercise contains both UDP Client and UDP Server programs.
This exercise is about writing a client server chat. A client will
connect to server and send some message. Server will respond back
with some message. The Server program should be able to converse
with many clients concurrently.


## UDP Client
This program should be invoked with Server's IP address as first
argument and server's port number as 2nd argument. After starting,
it should ask use to type in the message. The program will read the
message and send the same to server. If the message contains "Exit",
then the client program will exit. After sending the message to
server, it will wait for the response from the server and display
the same and then again for user to type the message to be sent to
server. This process will go on for ever till user exits (i.e. types
"Exit")/

## UDP Server
This program should be invoked with server port number as the first
argument. It will create a socket and wait for a message from any
client. It will ask the user on console to enter the response and
this response will be sent back to the client. Since Client's IP
address and port number are not available, same are extracted from
the UDP message from the client i.e. UDP Socket.

## Programs
The exercise contains 4 programs. Learners are requested to first
work with *UDPClientTemplate.java* and *UDPServerTemplate.java*
programs. These programs provide a basic template for both client
and server. The learner should fill in the code wherever there are
??.
A complete working program for both client and server is also given
in *UDPClient.java* and *UDPServer.java*.

## Testing the programs
Each of the client and server program can be tested independently by
making use **nc** command line tool. Use the option **-u** to run
**nc** with UDP Sockets. To use this tool as server, use the option
**-l <port>** and to use it as client, just provide server's IP
address and port number e.g. **nc -u <serverIP> <ServerPort>**.
