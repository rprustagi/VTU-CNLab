// Exp 09 - TCP Server (File reader and responder)
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
    if (args.length < ??) {
        System.out.println("Usage: TCPClient.java <serverIP> <Serverport> <dir1/file1> <dir2/file2> ...");
        System.exit(1);
    }
    // get the port from command line and create connection to server
    serverIPAddress = ??
    serverPort = ??

    // for each filename on the command line
    fileCount = 0;
    while (fileCount < args.length - 2) {
      filename = ??; // first two arguments are IP and Port
      fileCount++;
      System.out.println("Requesting file " + filename + " from Server ");

      // connect to server and get Input/Output streams
      sock = new Socket(??t);
      istream = sock.??;
      sockReader =
        new BufferedReader(new InputStreamReader(istream));

      // keeping output stream ready to send the contents
      ostream = sock.??
      printwriter = new PrintWriter(ostream, true);

      // send filename to server
      printwriter.println(??);
      // read the content of file and send the same.
      sockReader =
        new BufferedReader(new InputStreamReader(istream));
      // check if the response from server is -1. If so file does not exist
      // continue to retrieve next file
      linecontent = sockReader.??;
      if (linecontent.equals(??)) {
        System.out.println("Err: File " + filename + " is not accessible on server");
        ??;
      }
      tmpfile = new File(filename);
      tmpdir = tmpfile.getParentFile();
      // create the directory if it does not exist
      if (! tmpdir.??) {
        tmpdir.mkdirs();
      }
      // write all the content received from server
      filewriter = new PrintWriter(tmpfile);
      do {
        filewriter.println(??);
      }while((linecontent = ??)) !=  null);
      // close all the open the file handles
      ??.close();
      ??.close();
      ??.close();
      ??.close();
    } // end while fileCount
  } // end Main
} // end TCPClient

