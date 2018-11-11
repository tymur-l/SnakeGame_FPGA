module LFSR (
	input clk,
	input [5:0] seed, // don't pass 0
	output reg [5:0] rnd
);
	wire feedback = rnd[5] ^ rnd[4];

	initial
		rnd <= seed;

	always @(posedge clk)
		rnd <= (rnd == 6'h0) ? seed : {rnd[4:0], feedback};

endmodule
