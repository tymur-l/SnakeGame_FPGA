// top level module

module SnakeGame (
	input wire clk
	// input from joystick
	// output to VGA
);
	wire [1:0] dir;
	wire [`WORD_MSB:0]
		snake_head,
		apple;
		
	wire [`MSB_NUM_TAILS:0]
		tails_count;
	
	game_logic game_proc (
		.direction (dir),
		
		.clk (clk),
		
		//.tail_value (),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		.num_tails (tails_count),
		
		//.new_tail_value (),
		
		//.value_addr (),
		
		//.read_write_mem ()
	);
	
	snake_memory game_mem (
		//.read_write_sig (),
		
		//.value_addr (),
		
		//.new_value (),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		
		.num_tails (tails_count),
		
		//.value ()
	);
	// TODO: instantiate global clock
	// TODO: instantiate game_logic module
	// TODO: instantiate game memory module

	// process input from joystick
	// send processed input from joystick to game logic module
		// save game state to shared memory
	// let VGA controller take the data from memory and produce output

endmodule