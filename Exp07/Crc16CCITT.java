// https://introcs.cs.princeton.edu/java/61data/CRC16CCITT.java
public class Crc16CCITT { 

    public static void main(String[] args) { 
        //int crc = 0xFFFF;          // initial value
        int crc = 0x00;          // initial value
        //int polynomial = 0x1021;   // 1 0001 0000 0010 0001  (16, 12, 5, 0) 
        int polynomial = 0x01;   // 1001 

        byte[] bytes = args[0].getBytes();

        for (byte b : bytes) {
	    System.out.println("input byte : " + b); 
            for (int i = 0; i < 8; i++) {
                boolean bit = ((b   >> (7-i) & 1) == 1);
                boolean c15 = ((crc >> 15    & 1) == 1);
                crc <<= 1;
                if (c15 ^ bit) crc ^= polynomial;
        	crc &= 0x07;
        	System.out.println("curr CRC = " + Integer.toHexString(crc));
            }
        }

        // crc &= 0xffff;
        crc &= 0x07;
        System.out.println("CRC16-CCITT = " + Integer.toHexString(crc));
    }

}
