`include "../../definitions/define.vh"

`define inX_grid (inX / `H_SQUARE)
`define inY_grid (inY / `V_SQUARE)

module coord2grid_translator (
	input [`COORD_VGA_MSB_X:0]
		inX,
		inY,

	input wire
		calculation_finished,
		
	input wire [`MSB_NUM_TAILS:0]
		num_tails,

	input wire [`WORD_MSB:0] // WORD: 12 bit 
		snake_head_pos,
		apple_pos,
		cur_tail_pos,
	
	output reg [`MSB_NUM_TAILS:0]
		value_addr,

	output wire [0:1] entity_code,
	output reg translation_finished
);

	/*
		00 - apple
		01 - head
		10 - tail
		11 - nothing
	*/

	reg [0:1] grid [`GRID_WIDTH][`GRID_HEIGHT];
	
	assign entity_code = grid[`inX_grid][`inY_grid];
	
	initial
		translation_finished = 1'b0;
	
	always @(posedge calculation_finished)
	begin		
		integer i, j;
		translation_finished = 1'b0;
		
		for(i = 0; i < `GRID_WIDTH; i = i + 1)
		begin
			for (j = 0; j < `GRID_HEIGHT; j = j + 1)
			begin
				grid[i][j] = 2'b11;
			end
		end
		
		grid[apple_pos % `GRID_WIDTH][apple_pos / `GRID_WIDTH] = 2'b01;
		grid[snake_head_pos % `GRID_WIDTH][snake_head_pos / `GRID_WIDTH] = 2'b10;
		
		value_addr = `MIN_MEM_ADDR;
		repeat (`MAX_MEM_ADDR)
		begin
			if (value_addr < num_tails)
			begin
				grid[cur_tail_pos % `GRID_WIDTH][cur_tail_pos / `GRID_WIDTH] = 2'b10;
			end
		end
		
		translation_finished = 1'b1;
	end


endmodule
