// Exp 09 - TCP Client (File requestor and receiver)
import java.io.*;
import java.nio.*; // for binary files
import java.net.*;
public class TCPClient {
  public static void main(String[] args) throws IOException {
    String serverIPAddress = null;
    int serverPort = 0;
    String filename = null; /* name of file sent by client */
    String linecontent = null;
    int fileCount = 0;
    Socket sock = null; // socket identifying client connection
    File tmpfile = null;
    File tmpdir = null;

    InputStream istream = null; // to read content from client connection
    OutputStream ostream = null; // to write content onto client connection
    BufferedReader sockReader = null; // to read filename sent by client
    PrintWriter filewriter = null; // to write the received content from server
    PrintWriter printwriter = null; // to send filename to server

    // Validation check of command line arguments
    if (args.length < 3) {
        System.out.println("Usage: java TCPClient <serverIP> <Serverport> <file1> <file2> ...");
        System.exit(1);
    }
    // get the port from command line and create connection to server
    serverIPAddress = args[0];
    serverPort = Integer.parseInt(args[1]);

    // for each filename on the command line
    fileCount = 0;
    while (fileCount < args.length - 2) {
      filename = args[fileCount + 2]; // first two arguments are IP and Port
      fileCount++;
      System.out.println("Requesting file " + filename + " from Server ");

      sock = new Socket(serverIPAddress, serverPort);
      istream = sock.getInputStream( );
      sockReader =
        new BufferedReader(new InputStreamReader(istream));

      // keeping output stream ready to send the contents
      ostream = sock.getOutputStream();
      printwriter = new PrintWriter(ostream, true);

      // send filename to server
      printwriter.println(filename);
      // receive the content of file 
      sockReader =
        new BufferedReader(new InputStreamReader(istream));
      linecontent = sockReader.readLine();
      if (linecontent.equals("-1")) {
        System.out.println("Err: File " + filename + " is not accessible on server");
        continue;
      }
      tmpfile = new File(filename);
      tmpdir = tmpfile.getParentFile();
      if ((tmpdir != null) && (! tmpdir.exists())) {
        tmpdir.mkdirs();
      }
      filewriter = new PrintWriter(tmpfile);
      // write all the content received from server
      do {
        filewriter.println(linecontent);
      }while((linecontent = sockReader.readLine()) !=  null);
      System.out.println("File " + filename + " received from server");

      printwriter.close();
      sockReader.close();
      filewriter.close();
      sock.close();
    } // end while fileCount
  } // end Main
} // end TCPClient

