// Game logic highest level module.
`include "../../definitions/define.vh"

module game_logic (
	input wire [1:0]
		direction,
		
	input wire
		clk,
		
	input wire [`WORD_MSB:0]
		tail_value,
		
	output reg [`WORD_MSB:0]
		snake_head_pos,
		apple_pos,
		
		new_tail_value,
		
	output reg [`MSB_NUM_TAILS:0]
		num_tails,
		
		value_addr,
		
	output reg
		read_write_mem // 1 - read, 0 - write
);
	// initialize snake head and apple position
	initial
	begin
		snake_head_pos = `MID_ADDR;
		apple_pos = 12'd0; // TODO: drive by generated random number
		num_tails = 12'd0;
		
		value_addr = 12'd0;
		new_tail_value = 12'd0;
		read_write_mem = 1'b1;
	end

	// change game state depending on input
	// at posedge of each clock cycle
	always @(posedge clk)
	begin
		case (direction)
			`LEFT_DIR: move_left;
			`TOP_DIR: move_top;
			`RIGHT_DIR: move_right;
			`DOWN_DIR: move_down;
		endcase
	end
	
	task move_left ();
	begin
		snake_head_pos = snake_head_pos +
			(snake_head_pos % `GRID_WIDTH == 0) ?
			`LAST_HOR_CELL_ADDR:
			-1
			;
		
		//move_tail;
	end
	endtask

	task move_top ();
	begin
		snake_head_pos = snake_head_pos +
			(snake_head_pos < `GRID_WIDTH) ?
			`LAST_ROW_FIRST_CELL_ADDRESS:
			-`GRID_WIDTH
			;
		
		//move_tail;
	end
	endtask
	
	task move_right ();
	begin
		snake_head_pos = snake_head_pos +
			(snake_head_pos % `LAST_HOR_CELL_ADDR  == 0) ?
			-`LAST_HOR_CELL_ADDR:
			1
			;
		
		//move_tail;
	end
	endtask
	
	task move_down ();
	begin
		snake_head_pos = snake_head_pos +
		(snake_head_pos >= `LAST_ROW_FIRST_CELL_ADDRESS) ?
		-`LAST_ROW_FIRST_CELL_ADDRESS:
		`GRID_WIDTH
		;
		
		//move_tail;
	end
	endtask
	
//	task move_tail ();
//	begin
//		extend_tail;
//		
//		// TODO
//	end
//	endtask
//	
//	task extend_tail ();
//	// if apple is encountered - extend snake's tail
//	begin
//		// TODO
//	end
//	endtask
	
endmodule
