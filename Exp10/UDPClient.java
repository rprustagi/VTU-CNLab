// Exp 10 - UDP Client (Sender)
import java.io.*;
import java.net.*;
public class UDPClient {
  public static void main(String[] args) throws IOException {
    InetAddress saddr = InetAddress.getByName(args[0]);
    int sport = Integer.parseInt(args[1]);
    DatagramSocket sock = new DatagramSocket();
    BufferedReader userIn =
    new BufferedReader(new InputStreamReader(System.in));
    byte[] sendbuf = new byte[1024];
    byte[] recvbuf = new byte[1024];

    while (true) {
      System.out.println("Enter chat data: ");
      String sentence = userIn.readLine();
      if (sentence.equals("Exit")) {
        break;
      }
      sendbuf = sentence.getBytes();
      DatagramPacket sendpkt =
        new DatagramPacket(sendbuf, sendbuf.length, saddr, sport);
      DatagramPacket recvpkt = 
        new DatagramPacket(recvbuf, recvbuf.length);
      sock.send(sendpkt);
      sock.receive(recvpkt);
      String recvdata = new String(recvpkt.getData());
      System.out.println("Recd from Server: " + recvdata);
      for (int i=0; i< sendbuf.length; i++) {
      	sendbuf[i] = 0;
      }
      for (int i=0; i< recvbuf.length; i++) {
      	recvbuf[i] = 0;
      }
    }
    System.out.println("Closing the chat. Exiting");
    sock.close();
  }
}
