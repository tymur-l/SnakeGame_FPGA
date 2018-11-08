`include "../../definitions/define.vh"

module game_logic (
	input clk, reset,
	input [0:1] direction,
	input wire [9:0] x_in, y_in, // new values are given at each clock cycle
	output reg [0:1] entity,
	output reg game_over, game_won
);
	wire `X_SIZE cur_x;
	wire `Y_SIZE cur_y;
	reg `X_SIZE snake_head_x, apple_x;
	reg `Y_SIZE snake_head_y, apple_y;
	reg [2:0] drawing_cycles_passed;
	reg can_update, was_updated, is_cur_coord_tail;
	reg `COORD_SIZE tails [0:`LAST_TAIL_ADDR];
	reg `TAIL_SIZE tail_count;
	wire [5:0] rand_num_x_orig, rand_num_y_orig,
		rand_num_x_fit, rand_num_y_fit;

	/*
	linear_feedback_shift_register #(.NUM_BITS(6)) lfsr_x (
		.i_Clk(clk),
		.i_Enable(1),

		// Optional Seed Value
		.i_Seed_DV (0),
		.i_Seed_Data (0),

		.o_LFSR_Data(rand_num_x_orig),
		//.o_LFSR_Done()
	);

	linear_feedback_shift_register #(.NUM_BITS(6)) lfsr_y (
		.i_Clk(clk),
		.i_Enable(1),

		// Optional Seed Value
		.i_Seed_DV (0),
		.i_Seed_Data (0),

		.o_LFSR_Data(rand_num_y_orig),
		//.o_LFSR_Done()
	);
	*/

	assign rand_num_x_fit = rand_num_x_orig % `LAST_HOR_ADDR;
	assign rand_num_y_fit = rand_num_y_orig % `LAST_VER_ADDR;

	task init();
	begin
		apple_x <= 34;
		apple_y <= 9;
	end
	endtask

	initial
	begin
		init();
		drawing_cycles_passed <= 0;
		snake_head_x <= `GRID_MID_WIDTH;
		snake_head_y <= `GRID_MID_HEIGHT;
		tail_count <= 0;
		game_won <= 0;
	end

	assign cur_x = (x_in / `H_SQUARE);
	assign cur_y = (y_in / `V_SQUARE);

	// return entity code of the current x & y
	always @(posedge clk)
	begin
		if (
			cur_x == snake_head_x &&
			cur_y == snake_head_y
		)
		begin
			entity <= `ENT_SNAKE_HEAD;
		end
		else if (
			cur_x == apple_x &&
			cur_y == apple_y
		)
		begin
			entity <= `ENT_APPLE;
		end
		else if (is_cur_coord_tail)
		begin
			entity <= `ENT_SNAKE_TAIL;
		end
		else
		begin
			entity <= `ENT_NOTHING;
		end
	end

	// traverse the array of tails and see if
	// the current coordinate is a tail
	always @(posedge clk or posedge reset)
	begin
		integer i;

		if (reset)
		begin
			game_over <= 0;
		end
		else
		begin
			is_cur_coord_tail = 1'b0;

			for (i = 0; i < `MAX_TAILS; i = i + 1)
			begin
				if (i < tail_count)
				begin
					if (tails[i] == {cur_x, cur_y})
					begin
						is_cur_coord_tail = 1'b1;
					end

					if (tails[i] == {snake_head_x, snake_head_y})
					begin
						game_over = 1'b1;
					end
				end
			end
		end
	end

	// move snake head
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
					snake_head_x =
						(snake_head_x == 0) ?
							`LAST_HOR_ADDR:
							(snake_head_x - 12'd1);
				end
				`TOP_DIR:
				begin
					snake_head_y =
						(snake_head_y == 0) ?
							`LAST_VER_ADDR:
							(snake_head_y - 12'd1);
				end
				`RIGHT_DIR:
				begin
					snake_head_x =
						(snake_head_x == `LAST_HOR_ADDR) ?
							0:
							(snake_head_x + 12'd1);
				end
				`DOWN_DIR:
				begin
					snake_head_y =
						(snake_head_y == `LAST_VER_ADDR) ?
							0:
							(snake_head_y + 12'd1);
				end
			endcase
		end
	end

	// update tails
	always @(posedge can_update or posedge reset)
	begin
		integer i;

		if (reset)
		begin
			init();
			tail_count <= 0;
		end
		else
		begin
			// in case of apple hit
			if (snake_head_x == apple_x &&
					snake_head_y == apple_y)
			begin
				// add tail to the previous position of the head
				if (tail_count < `MAX_TAILS) // that is, game is not won
				begin
					tails[tail_count] <= {snake_head_x, snake_head_y};
					tail_count <= tail_count + 1;
				end

				// TODO: generate random coordinate for an apple and spawn it there
				apple_x <= 0; //rand_num_x_fit;
				apple_y <= 0; //rand_num_y_fit;
			end
			else
			begin
				// swap coordinates of adjacent tails
				for (i = 0; i < `MAX_TAILS; i = i + 1)
				begin
					if (i == (tail_count - 1))
					begin
						tails[i] <= {snake_head_x, snake_head_y};
					end
					else
					begin
						if (i != `LAST_TAIL_ADDR) // won't compile without this,
							// however, in reality this condition will always be true
						begin
							tails[i] <= tails[i + 1];
						end
					end
				end
			end
		end
	end

	always @(posedge can_update or posedge reset)
	begin
		if (reset)
		begin
			game_won <= 0;
		end
		else if (tail_count == `MAX_TAILS)
		begin
			game_won <= 1;
		end
	end

	// calculate whether the screen has been updated
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

	// calculate whether game state can be updated at this clock cycle
	always @(posedge clk)
	begin
		can_update <=
			(
				~game_over &&
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
