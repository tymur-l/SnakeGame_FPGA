`include "../../definitions/initialization.vh"

module game_logic (
	input clk,
	input [0:1] direction,
	input wire [9:0] x, y,
	output wire [0:1] entity
);
	`GRID_WORD game_grid [0:`LAST_HOR_ADDR][0:`LAST_VER_ADDR];
	wire `X_SIZE rand_x;
	wire `Y_SIZE rand_y;
	wire `X_SIZE cur_x;
	wire `Y_SIZE cur_y;
	
	assign cur_x = (x / `H_SQUARE);
	assign cur_y = (y / `V_SQUARE);

	rand_generator #(`MEM_VERT_ADDR_MSB, `LAST_HOR_ADDR, 13)
		rnd_gen_hor (
			clk,
			rand_x
		)
	;

	rand_generator #(`MEM_HOR_ADDR_MSB, `LAST_VER_ADDR, 5)
		rnd_gen_ver (
			clk,
			rand_y
		)
	;
	
	assign entity = game_grid[cur_x][cur_y][0:1];

	initial
	begin
		`GRID_INIT
	end
	
//reg [4:0] counter_y, counter_x;
//	always @(posedge clk)
//	begin
//		if (counter_x == 4'd12)
//		begin
//			counter_x = 4'd0;
//			
//			if (cur_x == `LAST_HOR_ADDR)
//			begin
//				cur_x = 0;
//				counter_y = counter_y + 1;
//			end
//			else
//			begin
//				cur_x = cur_x + 1;
//			end
//		end
//		else
//		begin
//			counter_x = counter_x + 1;
//		end
//		
//		if (counter_y == 4'd15)
//		begin
//			counter_y = 0;
//			
//			if (cur_y == `LAST_VER_ADDR)
//			begin
//				cur_y = 0;
//			end
//			else
//			begin
//				cur_y = cur_y + 1;
//			end
//		end
//		
//		//entity = game_grid[cur_x][cur_y][0:1];
//	end
	
endmodule
