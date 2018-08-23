# Exp09: TCP Socket programs
This exercise contains both TCP Client and TCP Server programs.
This exercise is about client requesting few files from server 
and server sending the same. 
A client will connect to server and send filenames one at a time. 
Server checks if the file exists and if so sends the file. If the
file does not exists, server sends "-1" in the response.
The Server program should be able to converse with many clients 
concurrently.


## TCP Client
This program should be invoked with Server's IP address as first
argument and server's port number as 2nd argument, and each
subsequent argument shoudl correspond to a file name1. 
After starting,
The program will read the response data from server and save the
content locally with the same filename as specified on command line.
message and send the same to server. If the message contains "Exit",
The client program will exit after the files have been received. 

## TCP Server
This program should be invoked with server port number as the first
argument, and listen queue size (backlog) as the second argument. 
It will create a server ocket and wait for a TCP Connection from any
client. It first checks if the requested file exists. If not it
responds with error code "-1". If the file exists, ten it reads the
file line by line, and sends the data to the client.

## Programs
The exercise contains 4 programs. Learners are requested to first
work with *TCPClientTemplate.java* and *TCPServerTemplate.java*
programs. These programs provide a basic template for both client
and server. The learner should fill in the code wherever there are
??.
A complete working program for both client and server is also given
in *TCPClient.java* and *TCPServer.java*.

## Testing the programs
Each of the client and server program can be tested independently by
making use **nc** command line tool. Use the option **-u** to run
**nc** with TCP Sockets. To use this tool as server, use the option
**-l <port>** and to use it as client, just provide server's IP
address and port number e.g. **nc <serverIP> <ServerPort>**. On the
client terminal window, just enter the filename to be fetched.
