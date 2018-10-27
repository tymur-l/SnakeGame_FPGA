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
	wire [`WORD_MSB:0] rn_num;
	reg [`WORD_MSB:0] prev_snake_head_pos;

	rand_generator #(`WORD_MSB, `MAX_ADDR, 391) (
		.clk (clk),
		.rnd_num (rn_num)
	);

	// initialize snake head and apple position
	initial
	begin: start_game
		snake_head_pos = `MID_ADDR;
		prev_snake_head_pos = snake_head_pos;
		num_tails = 7'd0;
		apple_pos = rn_num;
		
		value_addr = 7'd0;
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
	
	function [`WORD_MSB:0] next_left;
	input [`WORD_MSB:0] head_pos;
	begin
		next_left = head_pos +
			(head_pos % `GRID_WIDTH == 0) ?
			`LAST_HOR_CELL_ADDR:
			-12'd1
			;
	end
	endfunction
	
	function [`WORD_MSB:0] next_top;
	input [`WORD_MSB:0] head_pos;
	begin
		next_top = head_pos +
			(snake_head_pos < `GRID_WIDTH) ?
			`LAST_ROW_FIRST_CELL_ADDRESS:
			-`GRID_WIDTH
			;
	end
	endfunction
	
	function [`WORD_MSB:0] next_right;
	input [`WORD_MSB:0] head_pos;
	begin
		next_right = head_pos +
			(snake_head_pos % `LAST_HOR_CELL_ADDR  == 0) ?
			-`LAST_HOR_CELL_ADDR:
			12'd1
			;
	end
	endfunction
	
	function [`WORD_MSB:0] next_down;
	input [`WORD_MSB:0] head_pos;
	begin
		next_down = head_pos +
		(snake_head_pos >= `LAST_ROW_FIRST_CELL_ADDRESS) ?
		-`LAST_ROW_FIRST_CELL_ADDRESS:
		`GRID_WIDTH
		;
	end
	endfunction
	
	task move_left ();
	begin
		snake_head_pos = next_left (snake_head_pos);
		
		move_tail;
	end
	endtask

	task move_top ();
	begin
		snake_head_pos = next_top (snake_head_pos);
		
		move_tail;
	end
	endtask
	
	task move_right ();
	begin
		snake_head_pos = next_right (snake_head_pos);
		
		move_tail;
	end
	endtask
	
	task move_down ();
	begin
		snake_head_pos = next_down (snake_head_pos);
		
		move_tail;
	end
	endtask
	
	task move_tail ();
	begin
		integer i;
		reg tail_same;
		reg [`WORD_MSB:0] prev_tail;
		// TODO: check collision
		// if collision not happend - continue execute code,
		// otherwise - restart game
		extend_tail (tail_same);
		
		// move tail
		if (tail_same)
		begin
			if (num_tails > 0)
			begin
				value_addr = 0;
				prev_tail = tail_value;
				new_tail_value = prev_snake_head_pos;
				
				read_write_mem = 0; // write new tail element into memory
				read_write_mem = 1; // stop writing to memory once the new value was written
				
			end
			
			for (i = 1; i < num_tails; i = i + 1)
			begin
				value_addr = i;
				new_tail_value = prev_tail;
				prev_tail = tail_value;
				
				read_write_mem = 0; // write new tail element into memory
				read_write_mem = 1; // stop writing to memory once the new value was written
			end
			
			prev_snake_head_pos = snake_head_pos;
		end
	end
	endtask
	
	task extend_tail (output tail_same);
	// if apple is encountered - extend snake's tail, if it's possible
	// and generate new apple
	begin
		tail_same = 1;
		
		if (snake_head_pos == apple_pos)
		begin
			if (num_tails != `MEM_SIZE)
			begin
				tail_same = 0;
				num_tails = num_tails + 1; // add 1 more tail
				value_addr = num_tails; // new tail element will be inserted as a last element
				new_tail_value = snake_head_pos; // coordinates of a new element
					// of a tail is current snake head's coordinates
				
				read_write_mem = 0; // write new tail element into memory
				read_write_mem = 1; // stop writing to memory once the new value was written
				
				// move snake forward for 1 position in an appropriate direction
				case (direction)
					`LEFT_DIR: snake_head_pos = next_left (snake_head_pos);
					`TOP_DIR: snake_head_pos = next_top (snake_head_pos);
					`RIGHT_DIR: snake_head_pos = next_right (snake_head_pos);
					`DOWN_DIR: snake_head_pos = next_down (snake_head_pos);
				endcase
			end
			
			apple_pos = rn_num;
		end
	end
	endtask
	
endmodule
