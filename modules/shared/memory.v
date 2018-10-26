// memory module for snake game, that stores
// - location of snake's head
// - location of an apple
// - 128 locations of all snake's tails
// each position is a 12 bit number

module memory();
	localparam max_addr = 127, min_addr = 0,
		msb_num_tails = 7,
		word_msb = 11,
		// wdh = 39, hgt = 29,
		mid_pos = 19 * 14;

	reg [msb_num_tails:0] num_tails;

	reg [word_msb:0]
		snake_head_pos,
		apple_pos;
	
	reg [word_msb:0]
		snake_tail [min_addr:max_addr];

	initial
	begin: initialize
		integer i;
		num_tails = 8'b0;
		snake_head_pos = mid_pos;
		apple_pos = 12'b0; // TODO: generate random number
		
		for (i = min_addr; i <= max_addr; i = i + 1)
		begin
			snake_tail[i] = 12'b0;
		end
	end
		
endmodule
