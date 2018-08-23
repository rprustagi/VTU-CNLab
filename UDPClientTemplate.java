// Exp 10 - UDP Client (Sender)
import java.io.*;
import java.net.*;
public class UDPClient {
  public static void main(String[] args) throws IOException {
    InetAddress saddr = null;
    int sport = 0;
    DatagramSocket sock = new DatagramSocket();
    BufferedReader userIn =
      new BufferedReader(new InputStreamReader(System.in));
    byte[] sendbuf = new byte[1024];
    byte[] recvbuf = new byte[1024];

    // extract the server IP Address and port number from command line arguments
    saddr = ??
    sport = ??
    while (true) {
      System.out.println("Enter chat data: ");
      // read user input
      String sentence = ??
      // exit the client when user enters "Exit"
      if (??) {
        break;
      }
      // convert the input data to byte sequence
      sendbuf = ??
      // prepare the packet to sent to server.
      DatagramPacket sendpkt = ??
      // send the packet
      ??.send(??);

      // prepare a packet to received the response
      DatagramPacket recvpkt =  ??
      ??.receive(??);
      // convert the received UDP data to string text and display the same.
      String recvdata = ??
      System.out.println("Recd from Server: " + recvdata);
      // initialize the send and receive buffer
      for (int i=0; i< ??.length; i++) {
      	?? = 0;
      }
      for (int i=0; i< ??; i++) {
      	?? = 0;
      }
    }
    System.out.println("Closing the chat. Exiting");
    sock.close();
  }
}
