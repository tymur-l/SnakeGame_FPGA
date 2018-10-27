// top level module

module SnakeGame (
	input wire clk
	// input from joystick
	// output to VGA
);
	wire gl_clk, read_write_mem_sig;
	wire [1:0] dir = `TOP_DIR; // TODO: process input from joystick
	wire [`WORD_MSB:0]
		snake_head,
		apple,
		tail_pos,
		new_tail_pos;
		
	wire [`MSB_NUM_TAILS:0]
		tails_count,
		tail_addr;
	
	glob_clk global_clock (
		.inclk0 (clk),
		.c0 (gl_clk)
	);
	
	game_logic game_proc (
		.direction (dir),
		
		.clk (gl_clk),
		
		.tail_value (tail_pos),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		.num_tails (tails_count),
		
		.new_tail_value (new_tail_pos),
		
		.value_addr (tail_addr),
		
		.read_write_mem (read_write_mem_sig)
	);
	
	snake_memory game_mem (
		.read_write_sig (read_write_mem_sig),
		
		.value_addr (tail_addr),
		
		.new_value (new_tail_pos),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		
		.num_tails (tails_count),
		
		.value (tail_pos)
	);
	
	// send processed input from joystick to game logic module
		// save game state to shared memory
	// let VGA controller take the data from memory and produce output

endmodule
