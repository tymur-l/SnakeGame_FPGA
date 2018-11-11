`ifndef define_vh
`define define_vh

// game logic constants
// directions
`define LEFT_DIR 2'b00
`define TOP_DIR 2'b01
`define RIGHT_DIR 2'b11
`define DOWN_DIR 2'b10

// entities
`define ENT_NOTHING 2'b11
`define ENT_SNAKE_HEAD 2'b01
`define ENT_SNAKE_TAIL 2'b10
`define ENT_APPLE 2'b00

// constants for output and game grid
`define VGA_WIDTH 640
`define VGA_HEIGHT 480

`define H_SQUARE 16
`define V_SQUARE 16
`define H_SQUARE_LAST_ADDR (`H_SQUARE - 1)
`define V_SQUARE_LAST_ADDR (`V_SQUARE - 1)

`define DRAWING_CYCLES_TO_WAIT 3'd3

`define SPRITE_CNT 3
`define SPRITE_MSB `SPRITE_CNT - 1

`define GRID_WIDTH (`VGA_WIDTH/`H_SQUARE)
`define GRID_HEIGHT (`VGA_HEIGHT/`V_SQUARE)

`define GRID_MID_WIDTH (`GRID_WIDTH / 2)
`define GRID_MID_HEIGHT (`GRID_HEIGHT / 2)
//`define MID_ADDR ((`GRID_MID_WIDTH - 1) * (`GRID_MID_HEIGHT - 1));

`define LAST_HOR_ADDR (`GRID_WIDTH  - 1)
`define LAST_VER_ADDR (`GRID_HEIGHT - 1)

// memory
`define MEM_VERT_ADDR_MSB $clog2(`GRID_WIDTH)
`define MEM_HOR_ADDR_MSB $clog2(`GRID_HEIGHT)

`define X_SIZE [`MEM_VERT_ADDR_MSB:0]
`define Y_SIZE [`MEM_HOR_ADDR_MSB:0]
`define COORD_SIZE [`MEM_VERT_ADDR_MSB + `MEM_HOR_ADDR_MSB:0]

`define MAX_TAILS 128
`define LAST_TAIL_ADDR (`MAX_TAILS - 1)
`define TAIL_COUNT_MSB $clog2(`MAX_TAILS)
`define TAIL_SIZE [`TAIL_COUNT_MSB:0]

`endif // define_vh
