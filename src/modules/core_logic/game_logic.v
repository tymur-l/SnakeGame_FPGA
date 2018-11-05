`include "../../definitions/define.vh"

module game_logic (
	input clk, reset,
	input [0:1] direction,
	input wire [9:0] x_in, y_in, // new values are given at each clock cycle
	output reg [0:1] entity,
	output reg is_game_finished
);
	wire `X_SIZE cur_x;
	wire `Y_SIZE cur_y;
	reg `X_SIZE snake_head_x, apple_x;
	reg `Y_SIZE snake_head_y, apple_y;
	reg [2:0] drawing_cycles_passed;
	reg can_update;
	reg was_updated;

	task init ();
	begin
		apple_x <= 34;
		apple_y <= 9;
		is_game_finished <= 0;
	end
	endtask

	initial
	begin
		init ();
		drawing_cycles_passed <= 0;
		snake_head_x <= `GRID_MID_WIDTH;
		snake_head_y <= `GRID_MID_HEIGHT;
	end

	assign cur_x = (x_in / `H_SQUARE);
	assign cur_y = (y_in / `V_SQUARE);

	always @(posedge clk or posedge reset)
	begin
		if (reset)
			init();
		else
		begin
			if (
				cur_x == snake_head_x &&
				cur_y == snake_head_y
			)
			begin
				entity = `ENT_SNAKE_HEAD;
			end
			else if (
				cur_x == apple_x &&
				cur_y == apple_y
			)
			begin
				entity = `ENT_APPLE;
			end
			else
			begin
				entity = `ENT_NOTHING;
			end
		end
	end

	always @(posedge can_update or posedge reset)
	begin
		if (reset)
		begin
			snake_head_x <= `GRID_MID_WIDTH;
			snake_head_y <= `GRID_MID_HEIGHT;
		end
		else
		begin
			case (direction)
				`LEFT_DIR:
				begin
					snake_head_x <=
						(snake_head_x == 0) ?
							`LAST_HOR_ADDR:
							(snake_head_x - 12'd1);
				end
				`TOP_DIR:
				begin
					snake_head_y <=
						(snake_head_y == 0) ?
							`LAST_VER_ADDR:
							(snake_head_y - 12'd1);
				end
				`RIGHT_DIR:
				begin
					snake_head_x <=
						(snake_head_x == `LAST_HOR_ADDR) ?
							0:
							(snake_head_x + 12'd1);
				end
				`DOWN_DIR:
				begin
					snake_head_y <=
						(snake_head_y == `LAST_VER_ADDR) ?
							0:
							(snake_head_y + 12'd1);
				end
			endcase
		end
	end

	always @(posedge clk)
	begin
		if (can_update)
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

	always @(posedge clk)
	begin
		can_update <=
			(
				~is_game_finished &&
				~was_updated &&
				(drawing_cycles_passed == `DRAWING_CYCLES_TO_WAIT)
			);
	end

	// calculate number of times screen was fully drawn
	always @(posedge clk or posedge reset)
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
