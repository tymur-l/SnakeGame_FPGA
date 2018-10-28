// Module used to generate pseudo random numbers

module rand_generator #(
	parameter msb_res = 7,
	max_num = 255,
	seed = 391
)
(
	input wire clk,
	output reg [msb_res:0] rnd_num
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
