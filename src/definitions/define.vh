`ifndef define_vh
`define define_vh

// game logic constants
`define LEFT_DIR 2'b00
`define TOP_DIR 2'b01
`define RIGHT_DIR 2'b10
`define DOWN_DIR 2'b11

// memory
`define MAX_MEM_ADDR 127
`define MIN_MEM_ADDR 0
`define MSB_NUM_TAILS 6
`define WORD_MSB 11
`define WORD_SIZE (`WORD_MSB + 1)

// constants for output and game grid
`define VGA_WIDTH 640
`define VGA_HEIGHT 480

`define H_SQUARE 16
`define V_SQUARE 16

`define GRID_WIDTH (`VGA_WIDTH/`H_SQUARE)
`define GRID_HEIGHT (`VGA_HEIGHT/`V_SQUARE)

`define GRID_MID_WIDTH (`GRID_WIDTH / 2)
`define GRID_MID_HEIGHT (`GRID_HEIGHT / 2)
`define MID_ADDR ((`GRID_MID_WIDTH - 1) * (`GRID_MID_HEIGHT - 1));

`define LAST_HOR_CELL_ADDR (`GRID_WIDTH  - 1)
`define LAST_VER_CELL_ADDR (`GRID_HEIGHT  - 1)
`define LAST_ROW_FIRST_CELL_ADDRESS ((`GRID_WIDTH * `LAST_VER_CELL_ADDR) + 1)


`endif // define_vh
