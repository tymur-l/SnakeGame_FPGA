/////////////////////////////////////////////////////////////////////////////////

// Module Name:    SSEG_Display_Top
// Target Devices: EP4CE6( EP4CE6 Starter Board )
// Tool versions:  Quartus II 14.1
// Description: This example shows how to display hexadecimal data on a four digit seven segments display.

//////////////////////////////////////////////////////////////////////////////////
module SSEG_Display( clk_50M, reset,sseg_a_to_dp, sseg_an, data );

input  wire clk_50M;					// 50MHz clock input
input  wire reset;			// 8-bit DIP switch
output wire[7:0] sseg_a_to_dp;	// cathode of seven segment display( a,b,c,d,e,f,g,dp )
output wire[3:0] sseg_an;			// anaode of seven segment display( AN3,AN2,AN1,AN0 )


input wire [15:0] data ; // display "1234" on sseg led


SSEG_Driver U1 ( .clk_50M( clk_50M ),
						 .reset( reset ), 
						  .data( data ), 
						  .sseg( sseg_a_to_dp ), 
						    .an( sseg_an ), 
						 .dp_in( 4'b1111 ),	// turn off all decimal points
					 );

endmodule



