
`ifndef SNAKE_HEADER_
`define SNAKE_HEADER_

`include "vga_controller_header.vh"
`include "interface_header.vh"
`include "random_header.vh"

class snake;

localparam integer BOARD_WIDTH = 20*2;
localparam integer BOARD_HEIGHT = 15*2;
localparam integer LOC_COL_WIDTH = math::compute_log2(BOARD_WIDTH);
localparam integer LOC_ROW_WIDTH = math::compute_log2(BOARD_HEIGHT);
localparam integer SNAKE_BODY_TOTAL = 64;
localparam integer SNAKE_START_COL = BOARD_WIDTH/2;
localparam integer SNAKE_START_ROW = BOARD_HEIGHT/2;
localparam vga::config_type vga_config = vga::possible_configs[vga::_800x600];
localparam integer PIXELS_PER_BLOCK_WIDTH = vga_config.horizontal.width/BOARD_WIDTH;
localparam integer PIXELS_PER_BLOCK_HEIGHT = vga_config.vertical.width/BOARD_HEIGHT;
localparam integer GAME_CLOCK_FREQ = 1000000;
localparam integer RAW_CLOCK_FREQ = 100000000;
localparam integer MOVE_PERIODS_TOTAL = 7;
localparam integer MOVE_PERIODS[MOVE_PERIODS_TOTAL] = '{
    GAME_CLOCK_FREQ/1000*500,GAME_CLOCK_FREQ/1000*450,
    GAME_CLOCK_FREQ/1000*400,GAME_CLOCK_FREQ/1000*250,
    GAME_CLOCK_FREQ/1000*200,GAME_CLOCK_FREQ/1000*150,
    GAME_CLOCK_FREQ/1000*100}; 
localparam integer SCORE_DIGITS_TOTAL = 8;
localparam integer SCORE_MAX = (10**SCORE_DIGITS_TOTAL)-1;
localparam integer SCORE_WIDTH = math::compute_log2(SCORE_MAX);
localparam integer SCORE_BREAK_POINTS[MOVE_PERIODS_TOTAL] = '{1,2,3,4,8,16,32};

typedef enum logic [1:0] {
    BT_EMPTY,BT_SNAKE_BODY,BT_SNACK, BT_END
} block_type;

typedef enum logic [1:0] {
    DT_UP,DT_DOWN,DT_LEFT,DT_RIGHT
} direction_type;

//typedef struct packed {
//    logic [LOC_COL_WIDTH-1:0] col;
//    logic [LOC_ROW_WIDTH-1:0] row;
//} loc_type;

typedef struct packed {
    logic [7:0] col;
    logic [7:0] row;
} loc_type;

typedef struct packed {
    logic a;
    logic b;
    logic c;
    logic d;
    logic e;
    logic f;
    logic g;
    logic dp;
} ssegment_type;

typedef block_type board_type [BOARD_WIDTH][BOARD_HEIGHT];

typedef logic [3:0] digit_type;
typedef digit_type [SCORE_DIGITS_TOTAL-1:0] digits_type;  
typedef logic [SCORE_WIDTH-1:0] score_type;
typedef logic [7:0] anodes_type;
typedef quotient#(score_type)::quotient_type quotient_type;

localparam vga::pixel_type block_to_color[4] = '{
    '{0,0,0},            // BT_EMPTY
    '{0,255,0},      // BT_SNAKE_BODY
    '{218,74,0},          // BT_SNACK
    '{255,255,255}           // BT_END
};

localparam ssegment_type bcd_to_ssegment[10] = '{
    'b11111100,
    'b01100000,
    'b11011010,
    'b11110010,
    'b01100110,
    'b10110110,
    'b00111110,
    'b11100000,
    'b11111110,
    'b11100110};

endclass

`endif