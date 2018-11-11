`include "../../../../definitions/define.vh"

module game_upd_clk (
	input wire in_clk, reset,
	input [9:0] x_in,
	input [9:0] y_in,
	output reg out_clk
);
	reg was_updated;
	reg [2:0] drawing_cycles_passed;

	initial
	begin
		drawing_cycles_passed <= 0;
	end

	// calculate whether the screen has been updated
	always @(posedge in_clk)
	begin
		if (out_clk)
		begin
			was_updated <= 1;
		end
		else
		begin
			was_updated <=
				(drawing_cycles_passed == `DRAWING_CYCLES_TO_WAIT) ?
				1:
				0;
		end
	end

	// calculate whether game state can be updated at this clock cycle
	always @(posedge in_clk)
	begin
		out_clk <=
			(
				~was_updated &&
				(drawing_cycles_passed == `DRAWING_CYCLES_TO_WAIT)
			);
	end

	// calculate number of times screen was fully drawn
	always @(posedge in_clk or posedge reset)
	begin
		if (reset)
		begin
			drawing_cycles_passed <= 0;
		end
		else
		begin
			if (
				(x_in == `LAST_HOR_ADDR) &&
				(y_in == `LAST_VER_ADDR)
			)
			begin
				drawing_cycles_passed <=
					(drawing_cycles_passed == `DRAWING_CYCLES_TO_WAIT) ?
						0:
						drawing_cycles_passed + 1;
			end
		end
	end

endmodule
