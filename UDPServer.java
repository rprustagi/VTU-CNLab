// Exp 10 - UDP Server (Receiver)
import java.io.*;
import java.net.*;
public class UDPServer {
  public static void main(String[] args) throws IOException {
    int sport = 0;
    InetAddress caddr = null;
    int cport = 0;
    DatagramSocket sock = null;
    BufferedReader userIn = null;

    sport = Integer.parseInt(args[0]);
    sock = new DatagramSocket(sport);
    userIn = new BufferedReader(new InputStreamReader(System.in));
    byte[] sendbuf = new byte[1024];
    byte[] recvbuf = new byte[1024];

    while (true) {
      System.out.println("Waiting for Client input: ");
      DatagramPacket recvpkt = 
        new DatagramPacket(recvbuf, recvbuf.length);
      sock.receive(recvpkt);
      String recvdata = new String(recvpkt.getData());
      caddr = recvpkt.getAddress();
      cport = recvpkt.getPort();
      System.out.println("Recd from Client " + caddr.toString() + ":" + cport);
      System.out.println(recvdata);

      System.out.println("Enter the Response: ");
      String sentence = userIn.readLine();
      sendbuf = sentence.getBytes();
      DatagramPacket sendpkt =
        new DatagramPacket(sendbuf, sendbuf.length, caddr, cport);
      sock.send(sendpkt);
      for (int i=0; i< sendbuf.length; i++) {
      	sendbuf[i] = 0;
      }
      for (int i=0; i< recvbuf.length; i++) {
      	recvbuf[i] = 0;
      }
    }
  }
}

