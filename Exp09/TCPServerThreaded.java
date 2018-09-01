import java.io.*;
import java.nio.*;
import java.net.*;
public class TCPServerThreaded extends Thread {

  Socket cSocket;
  String clientIP = null;
  int clientPort = 0;

  TCPServerThreaded(Socket cSocket, String clientIP, int clientPort){
    this.cSocket = cSocket; //Store the socket connection for that thread in the object
    this.clientIP = clientIP;
    this.clientPort = clientPort;
    start(); // invoke the start method immediately to run the thread
  }

  public void run(){
    try {
      File tmpfile = null;

      InputStream istream = null; // to read content from client connection
      OutputStream ostream = null; // to write content onto client connection
      BufferedReader sockReader = null; // to read filename sent by client
      BufferedReader fileReader = null; // to read file from disk on server
      String filename = null; /* name of file sent by client */

      // Get the file name from client connection whose content needs to be sent
      istream = this.cSocket.getInputStream();
      sockReader = new BufferedReader(new InputStreamReader(istream));
      // keeping output stream ready to send the contents
      ostream = this.cSocket.getOutputStream();
      PrintWriter sockwriter = new PrintWriter(ostream, true);

      // read the fliename as given by client
      filename = sockReader.readLine();
      // Check if file exists. If not send the error -1
      tmpfile = new File(filename);
      if ( ! tmpfile.exists() ) {
        System.out.println("Client:" + clientIP + ":" + clientPort+ " Received Filename " + filename + " does not exist");
        sockwriter.println(-1);
        this.cSocket.close();
      }else{
        // read the content of file and send the same.
        fileReader = new BufferedReader(new FileReader(tmpfile) );
        String str;
        while((str = fileReader.readLine()) !=  null) {
          // reading line-by-line from file and sending to client
          sockwriter.println(str);
        }

        // close all the I/O points except server socket
        fileReader.close(); // fileReader
        sockwriter.close(); // sockWriter
        sockReader.close(); // sockReader
        this.cSocket.close(); // client socket
      }
    } catch (Exception e) {
      System.out.println(" Exception occurred in thread for client " + clientIP + ":" + clientPort + e.getMessage());
    }
  }

  public static void main(String[] args) throws IOException {
    try {
      int serverport = 0;
      int backlog = 5;

      ServerSocket serversock = null; // server socket to accept connections
      Socket csock = null; // socket identifying client connection
      String clientIP = null;
      int clientPort = 0;

      // Validation check of command line arguments
      if (args.length != 2) {
          System.out.println("Usage: TCPServerThreaded.java <portnumber> <listenQ>");
          System.exit(1); // Exit from the program
      }

      // get the server port from command line and
      // create server socket to accept connection */
      serverport = new Integer(args[0]);
      backlog = new Integer(args[1]);
      serversock = new ServerSocket(serverport, backlog);

      System.out.println("Waiting for New Client Connections");

      while (true) {
        csock = serversock.accept(); // get the new connection from client
        clientIP = csock.getInetAddress().getHostAddress();
        clientPort = csock.getPort();
        System.out.println("Request from client: " + clientIP + ", " + clientPort + " Assigning new Thread");
        Thread newThread = new TCPServerThreaded(csock, clientIP, clientPort); //create a thread and the pass the required socket connection
      }
    } catch (Exception e) {
      System.out.println("Handled error in Main Thread " + e.getMessage());
    }
  }
}

