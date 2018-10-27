// memory module for snake game, that stores
// - location of snake's head
// - location of an apple
// - 128 locations of all snake's tails
// each position is a 12 bit number
`include "../../definitions/define.vh"

module snake_memory (		
	input wire
		read_write_sig, // 1 - read, 0 - write
		
	input wire [`MSB_NUM_TAILS:0]
		value_addr,
		
	input wire [`WORD_MSB:0]
		new_value,
		
	inout wire [`WORD_MSB:0]
		snake_head_pos,
		apple_pos,
		
	inout wire [`MSB_NUM_TAILS:0]
		num_tails,
		
	output reg [`WORD_MSB:0]
		value
);
	reg [`WORD_MSB:0]
		snake_tail [`MIN_MEM_ADDR:`MAX_MEM_ADDR];

	initial
	begin: initialize
		integer i;

		for (i = `MIN_MEM_ADDR; i <= `MAX_MEM_ADDR; i = i + 1)
		begin
			snake_tail[i] = 12'b0;
		end
	end

	always @(posedge read_write_sig)
	begin
		value = snake_tail[value_addr];
	end

	always @(negedge read_write_sig)
	begin
		snake_tail[value_addr] = new_value;
	end

endmodule
