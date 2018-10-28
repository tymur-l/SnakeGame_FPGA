// Module used to generate pseudo random numbers

module rand_generator #(
	parameter last_bit_addr = 7,
	max_num = 255,
	seed = 391
)
(
	input wire clk,
	output reg [0:last_bit_addr] rnd_num
);

	initial
		rnd_num = seed;

	always @(posedge clk)
	begin
		if (rnd_num == max_num)
		begin
			rnd_num = 0;
		end
		else
		begin
			rnd_num = rnd_num + 1;
		end
	end

endmodule
