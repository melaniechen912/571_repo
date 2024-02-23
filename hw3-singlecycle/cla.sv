`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

   assign cout[0] = gin[0] | (pin[0] & cin);
   assign cout[1] = gin[1] | ((pin[1] & gin[0]) | (pin[1] & pin[0] & cin));
   assign cout[2] = gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]));

   assign pout = (& pin);
   assign gout = gin[3] | (pin[3] & gin[2]) | ((& pin[3:2]) & gin[1]) | ((& pin[3:1]) & gin[0]);

endmodule



/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   assign cout[0] = gin[0] | (pin[0] & cin);
   assign cout[1] = gin[1] | ((pin[1] & gin[0]) | (pin[1] & pin[0] & cin));
   assign cout[2] = gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]));
   assign cout[3] = ((gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]))) & pin[3]) | gin[3]; 
   assign cout[4] = gin[4] | ((((gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]))) & pin[3]) | gin[3]) & pin[4]);
   assign cout[5] = gin[5] | ((gin[4] | ((((gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]))) & pin[3]) | gin[3]) & pin[4])) & pin[5]);
   assign cout[6] = gin[6] | ((gin[5] | ((gin[4] | ((((gin[2] | ((pin[2] & gin[1]) | (pin[2] & pin[1] & pin[0] & cin) | (pin[2] & pin[1] & gin[0]))) & pin[3]) | gin[3]) & pin[4])) & pin[5])) & pin[6]); 

   assign pout = (& pin);
   assign gout = gin[7] | (pin[7] & gin[6]) | ((& pin[7:6]) & gin[5]) | ((& pin[7:5]) & gin[4]) | ((& pin[7:4]) & gin[3]) | ((& pin[7:3]) & gin[2]) | ((& pin[7:2]) & gin[1]) | ((& pin[7:1]) & gin[0]);

endmodule


module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   genvar i;
   wire [31:0] gin_4, pin_4;
   wire [7:0] gout_4, pout_4;
   wire gout_8, pout_8;
   
   for (i = 0; i < 32; i++) begin
      gp1 gp1_instance(.a(a[i]), .b(b[i]), .g(gin_4[i]), .p(pin_4[i]));
   end

   wire [31:0] cout;
   assign cout[0] = cin;

   for (i = 0; i < 8; i++) begin
      gp4 gp4_instance(.gin(gin_4[4*i+3 : 4*i]), .pin(pin_4[4*i+3: 4*i]), .cin(cout[i*4]), .gout(gout_4[i]), .pout(pout_4[i]), .cout(cout[i*4+3:i*4+1]));
   end

   gp8 gp8_instance(.gin(gout_4), .pin(pout_4), .cin(cin), .gout(gout_8), .pout(pout_8), .cout({cout[28], cout[24], cout[20], cout[16], cout[12], cout[8], cout[4]}));
   
   assign sum = a ^ b ^ cout;

endmodule
