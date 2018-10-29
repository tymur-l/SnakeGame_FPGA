`include "../../definitions/define.vh"

module buttons (
	//input clk,
	input wire left, right, up, down,
	output reg [0:1] out
);

//wire is_pressed_one;
//xor (is_pressed_one, left, right, up, down);

wire
	inv_left,
	inv_right,
	inv_up,
	inv_down;

assign inv_left = ~left;
assign inv_right = ~right;
assign inv_up = ~up;
assign inv_down = ~down;

//not (left, left);
//not (right, right);
//not (up, up);
//not (down, down);

initial
begin 
	out = `TOP_DIR;
end

always @(*) // TODO: check whether it works without clk //posedge clk
begin
//	if(is_pressed_one) // if only one pressed
//	begin
		if (~(inv_right | inv_up | inv_down) && inv_left && (out != `RIGHT_DIR))
		begin
			out = `LEFT_DIR;
		end
		
		if (~(inv_left | inv_up | inv_down) && inv_right && (out != `LEFT_DIR))
		begin
			out = `RIGHT_DIR;
		end

		if (~(inv_right | inv_left | inv_down) && inv_up && (out != `DOWN_DIR))
		begin
			out = `TOP_DIR;
		end
		
		if (~(inv_right | inv_up | inv_left) && inv_down && (out != `TOP_DIR))
		begin
			out = `DOWN_DIR;
		end
//	end
end

endmodule
