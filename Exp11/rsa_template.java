import  java.util.*;
class rsa11 {
 public static void main(String args[]) {
     int p, q ,n, phi_n;
     int e=1,d =1;
     int j, k;
     int msglen;
     int plaintext[]= new int[100];
     int ciphertext[]= new int[100];
     int retrievetext[]= new int[100];
     String msg;

     // args[0] is first prime number
     // args[1] is second prime number
     // args[2] message data as string

     p = ??
     q = ??
     msg = ??
     msglen = ??

     // computer n and phi_n
     n = ??
     phi_n = ??

     // find e relative prime to n
     e = 1;
     while((phi_n) % e==0)  {
        ??;
     }
     // find d such that mod(de,phi_n) = 1

     d = 1;
     while((d * e) % (phi_n) != 1) {
        ??
     }
     System.out.println("Public Key(e,n)= " + e + "," + n);
     System.out.println("Private Key(d,n)= " + d + "," + n);
     System.out.println("----------------------");

     System.out.print("PlainText = ");
     for(j=0; j<msglen; j++) {
	plaintext[j]=(msg.charAt(j));
	System.out.print(" " + plaintext[j]);
     }
     System.out.println("");

     // convert plain text into cipher text.
     // take one char at a time and convert
     System.out.print("CipherText = ");
     for(j=0; j<msglen; j++) {
        ciphertext[j] = 1;
	for (k=0; k < e; k++) {
	   ciphertext[j] = ??
	}
        System.out.print(" " + ciphertext[j]);
      }
     System.out.println("");

     // retrieve the original plain text from cipher text
     System.out.print("Retrieved Text = ");
      for(j=0;  j < msglen; j++) {
	retrievetext[j] = ?? // may require few lines of code 

	}
        System.out.print(" " + retrievetext[j]);
      }
     System.out.println("");
      System.out.println("\n----------------------");
      System.out.println("Decrypted Message:");
      for(j=0; j<msglen; j++) {
         System.out.print((char)retrievetext[j]);
      }
      System.out.println("");
   }
}

