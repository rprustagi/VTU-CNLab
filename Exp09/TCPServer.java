// Exp 09 - TCP Server (File reader and responder)
import java.io.*;
import java.nio.*;
import java.net.*;
public class TCPServer {
  public static void main(String[] args) throws IOException {
    int serverport = 0;
    int backlog = 5;

    ServerSocket ssock = null; // server socket to accept connections
    Socket csock = null; // socket identifying client connection
    String clientIP = null;
    int     clientPort = 0;
    File tmpfile = null;

    InputStream istream = null; // to read content from client connection
    OutputStream ostream = null; // to write content onto client connection
    BufferedReader sockReader = null; // to read filename sent by client
    BufferedReader fileReader = null; // to read file from disk on server
    String filename = null; /* name of file sent by client */

    // Validation check of command line arguments
    if (args.length != 2) {
        System.out.println("Usage: TCPServer.java <portnumber> <listenQ>");
        System.exit(1);
    }
 /* get the port from command line and create server socket to accept connection */
    serverport = Integer.parseInt(args[0]);
    backlog = Integer.parseInt(args[1]);
    ssock = new ServerSocket(serverport, backlog);

    while (true) {
      System.out.println("Waiting for Client input: ");
      csock = ssock.accept(); // get the new socket for client

      clientIP = csock.getInetAddress().getHostAddress();
      clientPort = csock.getPort();
      System.out.println("Request from client: " + clientIP + ", " + clientPort);
      // Get the file name from client connection whose content needs to be sent
      istream = csock.getInputStream( );
      sockReader =
        new BufferedReader(new InputStreamReader(istream));
      // keeping output stream ready to send the contents
      ostream = csock.getOutputStream( );
      PrintWriter pwrite = new PrintWriter(ostream, true);

      filename = sockReader.readLine( );
      // Check if file exists. If not send the error -1
      tmpfile = new File(filename);
      if (! tmpfile.exists() ) {
        System.out.println("File " + filename + " does not exist");
        pwrite.println(-1);
        csock.close();
        continue;
      }
      // read the content of file and send the same.
      fileReader =
        new BufferedReader(new FileReader(filename) );
      String str;
      while((str = fileReader.readLine()) !=  null) {
        // reading line-by-line from file and sending to client
	    pwrite.println(str);
      }
      pwrite.close();
      fileReader.close();
      csock.close();
    }
  }
}

