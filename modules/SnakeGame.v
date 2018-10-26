module SnakeGame (
	input wire clk
	// input from joystick
	// output to VGA
);
	wire [1:0] direction;
	
	// TODO: instantiate global clock
	memory game_state();

	// process input from joystick
	// send processed input from joystick to game logic module
		// save game state to shared memory
	// let VGA controller take the data from memory and produce output

endmodule
