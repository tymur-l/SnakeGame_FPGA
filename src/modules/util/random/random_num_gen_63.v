module random_num_gen_63 (
	input clk,
	input [5:0] seed,
	output reg [5:0] rnd
);

	wire [5:0] rnd_seq, rnd_bit;
	reg [2:0] cur_bit;

	initial
	begin
		rnd <= 40;
		cur_bit <= 0;
	end

	LFSR lsfr (
		.clk(clk),
		.seed(seed),
		.rnd(rnd_seq)
	);

	assign rnd_bit = rnd_seq[0];

	always @(posedge clk)
	begin
		rnd[cur_bit] = rnd_bit;

		cur_bit = (cur_bit == 5) ? 0 : cur_bit + 1;
	end

endmodule
