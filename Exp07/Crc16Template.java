
public class Crc16 {

  public static void main(String[] args) {
      // Initial value of CRC and polynomical various CRC-CCITT implementation
      // CRC-16/CCITT: Initial: 0xFFFF, poly = 0x1021
      // CRC-16/XModem: Initial: 0x0000, Poly = 0x1021
      // CRC-16/``````: Initial: 0xFFFF, Poly = 0x8005
      int remainder = ??; // Initial value of CRC.

      int polynomial = ?? // ideally it is 0x11021
      int bitvalue; // one bit of data from MSB at a time
      int remMsb; // MSB bit of remainer i.e. current crc calue

    if ((args.length ==  ??) || (args.length > ??)) {
        System.out.println("Usage: Crc16: <input in hex> [<CRC Polynomial in hex>]");
    }
    byte[] inpdata = ??.getBytes(); // convert intput data into bytes.
    if (args.length > 1) { //CRC polynomial is specified
        polynomial = Integer.decode(args[1]);
    }
    for (byte inpbyte: ??) {
      for (int count = 0; count < 8; count++) {// for each bit from MSB to LSB
        bitvalue = ((inpbyte >>> (??)) & 1); // one bit at a time from MSB side
        remMsb = ((remainder & 0x8000) >>> ??) & 1;
        remainder = remainder << 1; // be ready for next round of division
        // check if XOR of both data bit and remainder bit is true
        if ((??) == 1) {
          // if yes, do XOR of CRC with Polynomial
          remainder = ??
        }
      } // end for byte
      remainder = remainder & ??; // truncate to 16 bits only
    } // end for input data

    System.out.println("CRC16 value of input data " + args[0] + " is " + 
        Integer.toHexString(??));
  }

}
