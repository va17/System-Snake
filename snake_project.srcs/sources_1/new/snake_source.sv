`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Andrew Powell
// 
// Create Date: 02/29/2016 07:58:37 PM
// Design Name: system snake
// Module Name: snake_source
// Project Name: system snake
// Target Devices: Digilent Nexys 4 DDR (Artix-7)
// Tool Versions: Vivado 2015.3
// Description: See top_module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "snake_header.vh"

module snake_controller_module(
    input logic game_clock,
    input logic low_reset,
    input logic up_key_is_pressed,
    input logic down_key_is_pressed,
    input logic left_key_is_pressed,
    input logic right_key_is_pressed,
    axi4s.slave request_interface,
    output snake::board_type game_board,
    output snake::score_type score,
    input wire [31:0]keycode,
    input logic has_walls,
    input logic is_inverted );

enum {CGS_INITIALIZE,CGS_WAIT_FOR_START,CGS_GENERATE_SNACK,CGS_DRAW,CSG_MOVE_SNAKE,CSG_COLLISION_CHECK,CGS_GAME_END} current_game_state;

snake::board_type game_board_buff;
snake::loc_type snake_body[snake::SNAKE_BODY_TOTAL];
snake::loc_type snake_tail;
snake::loc_type snack;
snake::direction_type current_direction;
snake::direction_type new_direction;
integer curr_body_total;
integer pc;
integer body_pointer;
integer move_pointer;
integer move_counter;
logic any_key_is_pressed;
logic wall_collision;

assign any_key_is_pressed = up_key_is_pressed|down_key_is_pressed|left_key_is_pressed|right_key_is_pressed;
   
always @(posedge game_clock or negedge low_reset)
    if (!low_reset) begin
        request_interface.slave_reset();
        current_game_state = CGS_INITIALIZE;
        current_direction = snake::DT_UP;
        new_direction = snake::DT_UP;
        score = 0;
        curr_body_total = 0;
        snack = '{0,0};
        pc = 0;
        body_pointer = 0;
        move_pointer = 0;
        move_counter = 0;
        wall_collision = 0;
        foreach (snake_body[each_body]) snake_body[each_body] = '{0,0};
        foreach (game_board[each_col,each_row]) game_board[each_col][each_row] = snake::BT_EMPTY;
        foreach (game_board_buff[each_col,each_row]) game_board_buff[each_col][each_row] = snake::BT_EMPTY;
    end else
        case (current_game_state)
        CGS_INITIALIZE:
            begin
                // initialize the snake board
                foreach (game_board[each_col,each_row]) begin
                    if (each_col==snake::SNAKE_START_COL && each_row==snake::SNAKE_START_ROW) begin
                        game_board[each_col][each_row] = snake::BT_SNAKE_BODY;
                    end else begin
                        game_board[each_col][each_row] = snake::BT_EMPTY;
                    end
                end 
                foreach (game_board_buff[each_col,each_row]) 
                    game_board_buff[each_col][each_row] = snake::BT_EMPTY;
                
                // initialize the snake itself
                snake_body[0].col = snake::SNAKE_START_COL;
                snake_body[0].row = snake::SNAKE_START_ROW;
                
                // initialize other variables
                pc = 0;
                curr_body_total = 1;
                move_counter = 0;
                body_pointer = 0;
                move_pointer = 0;
                wall_collision = 0;
                score = 0;
                current_direction = snake::DT_UP;
                new_direction = snake::DT_UP;
                
                current_game_state = CGS_WAIT_FOR_START;
            end
        CGS_WAIT_FOR_START:
            begin
                // wait until a pushbutton is pressed until starting
                if (keycode[15:8] == 8'h29) begin
                    current_game_state = CGS_GENERATE_SNACK;
                end else if (any_key_is_pressed) begin
                    current_game_state = CGS_GENERATE_SNACK;
                end
            end
        CGS_GENERATE_SNACK:
            begin
                // generate snack for the snake to eat
                case (pc)
                0:
                    begin
                        if (request_interface.slave_receive(snack)) begin
                            pc++;
                        end
                    end
                1:
                    begin
                        if (snake_body[body_pointer]==snack) begin
                            body_pointer = 0;
                            pc = 0;
                        end else if (body_pointer==(curr_body_total-1)) begin
                            body_pointer = 0;
                            pc = 0;
                            current_game_state = CGS_DRAW;
                        end else begin
                            body_pointer++;
                        end
                    end
                endcase
            end
        CGS_DRAW:
            begin
                case (pc)
                0:
                    begin
                        // initialize buffer
                        foreach (game_board_buff[each_col,each_row]) 
                            game_board_buff[each_col][each_row] = snake::BT_EMPTY;
                        pc++;
                    end
                1:
                    begin
                        // set snake bodies
                        integer col = snake_body[body_pointer].col;
                        integer row = snake_body[body_pointer].row;
                        game_board_buff[col][row] = snake::BT_SNAKE_BODY;
                        if (body_pointer==(curr_body_total-1)) begin
                            body_pointer = 0;
                            pc++;
                        end else begin
                            body_pointer++;
                        end
                    end
                2:
                    begin
                        // set snack
                        integer col = snack.col;
                        integer row = snack.row;
                        game_board_buff[col][row] = snake::BT_SNACK;
                        pc++;
                    end
                3:
                    begin
                        // update game board
                        game_board = game_board_buff;
                        pc = 0;
                        current_game_state = CSG_MOVE_SNAKE;
                    end
                endcase
            end
        CSG_MOVE_SNAKE:
            begin
                case (pc)
                0:
                    begin
                        // wait for movement
                        if (move_counter==(snake::MOVE_PERIODS[move_pointer]-1)) begin
                            if ((current_direction==snake::DT_UP && new_direction!=snake::DT_DOWN)||
                                (current_direction==snake::DT_DOWN && new_direction!=snake::DT_UP)||
                                (current_direction==snake::DT_LEFT && new_direction!=snake::DT_RIGHT)||
                                (current_direction==snake::DT_RIGHT && new_direction!=snake::DT_LEFT)) begin
                                current_direction = new_direction;
                            end
                            move_counter = 0;
                            body_pointer = curr_body_total-1;
                            snake_tail = snake_body[curr_body_total-1];
                            pc++;
                        end else begin
                            if (up_key_is_pressed) begin
                                new_direction = snake::DT_UP;
                            end else if (keycode[15:8] == 8'h1D) begin//w
                                if (is_inverted == 1) begin
                                    new_direction = snake::DT_DOWN;
                                end else if (is_inverted == 0) begin
                                    new_direction = snake::DT_UP;
                                end
                            end else if (down_key_is_pressed) begin
                                new_direction = snake::DT_DOWN;
                            end else if (keycode[15:8] == 8'h1B) begin//s
                                if (is_inverted == 1) begin
                                    new_direction = snake::DT_UP;
                                end else if (is_inverted == 0) begin
                                    new_direction = snake::DT_DOWN;
                                end
                            end else if (left_key_is_pressed) begin
                                new_direction = snake::DT_LEFT;
                            end else if (keycode[15:8] == 8'h1C) begin//a
                                if (is_inverted == 1) begin
                                    new_direction = snake::DT_RIGHT;
                                end else if (is_inverted == 0) begin
                                    new_direction = snake::DT_LEFT;
                                end
                            end else if (right_key_is_pressed) begin
                                new_direction = snake::DT_RIGHT;
                            end else if (keycode[15:8] == 8'h23) begin//d
                                if (is_inverted == 1) begin
                                    new_direction = snake::DT_LEFT;
                                end else if (is_inverted == 0) begin
                                    new_direction = snake::DT_RIGHT;
                                end
                            end
                            move_counter++;
                        end
                    end
                1:
                    begin
                        // perform movement
                        if (body_pointer==0) begin
                            case (current_direction)
                            snake::DT_UP:      
                                begin
                                    if (snake_body[body_pointer].row==0) begin
                                        wall_collision = 1;
                                        snake_body[body_pointer].row = snake_body[body_pointer].row + snake::BOARD_HEIGHT;
                                    end
                                    snake_body[body_pointer].row--;
                                end
                            snake::DT_DOWN:
                                begin
                                    if (snake_body[body_pointer].row==(snake::BOARD_HEIGHT-1))  begin    
                                        wall_collision = 1; 
                                        snake_body[body_pointer].row = snake_body[body_pointer].row - snake::BOARD_HEIGHT;
                                    end
                                    snake_body[body_pointer].row++;
                                end
                            snake::DT_LEFT:
                                begin
                                    if (snake_body[body_pointer].col==0) begin
                                        wall_collision = 1;
                                        snake_body[body_pointer].col = snake_body[body_pointer].col + snake::BOARD_WIDTH;
                                    end 
                                    snake_body[body_pointer].col--;
                                end
                            snake::DT_RIGHT:
                                begin
                                   if (snake_body[body_pointer].col==(snake::BOARD_WIDTH-1)) begin
                                        wall_collision = 1;
                                        snake_body[body_pointer].col = snake_body[body_pointer].col - snake::BOARD_WIDTH;
                                   end
                                    snake_body[body_pointer].col++;
                                end
                            endcase
                            pc = 0;
                            current_game_state = CSG_COLLISION_CHECK;
                        end else begin
                            snake_body[body_pointer] = snake_body[body_pointer-1];
                            body_pointer--;
                        end
                    end
                endcase
            end
        CSG_COLLISION_CHECK:
            begin
                snake::loc_type head = snake_body[0];
                case (pc)
                0:
                    begin
                        // check for body collision
                        if ((head==snake_body[body_pointer]) && (body_pointer!=0)) begin
                            pc = 0;
                            body_pointer = 0;
                            current_game_state = CGS_GAME_END;
                        end else begin
                            if (body_pointer==(curr_body_total-1)) begin
                                body_pointer = 0;
                                pc++;
                            end else begin
                                body_pointer++;
                            end
                        end
                    end
                1:
                    begin
                        // check for wall collisions
                        if (wall_collision && has_walls == 1) begin
                            pc = 0;
                            current_game_state = CGS_GAME_END;
                        end else if (wall_collision && has_walls == 0) begin
                            pc++;
                            wall_collision = 0;
                        end else begin
                            pc++;
                        end
                    end
                2:
                    begin
                        // check for snack collision
                        if (head==snack) begin
                            if (curr_body_total!=(snake::SNAKE_BODY_TOTAL-1)) begin
                                snake_body[curr_body_total] = snake_tail;
                                curr_body_total++;
                            end
                            if (score==(snake::SCORE_MAX)) begin
                                score = 0;
                            end else begin
                                score++;
                            end
                            foreach (snake::MOVE_PERIODS[each_period]) begin
                                if (snake::SCORE_BREAK_POINTS[each_period]==score) begin
                                    move_pointer = each_period;
                                end
                            end
                            pc = 0;
                            current_game_state = CGS_GENERATE_SNACK;
                        end else begin
                            pc = 0;
                            current_game_state = CGS_DRAW;
                        end
                    end
                endcase
            end
        CGS_GAME_END:
            begin
                foreach (game_board[each_col,each_row]) begin
                    game_board[each_col][each_row] = snake::BT_END;
                end 
                //Letter G
                game_board[5][2] = snake::BT_SNACK;
                game_board[6][2] = snake::BT_SNACK;
                game_board[7][2] = snake::BT_SNACK;
                game_board[8][2] = snake::BT_SNACK;
                game_board[5][3] = snake::BT_SNACK;
                game_board[5][4] = snake::BT_SNACK;
                game_board[5][5] = snake::BT_SNACK;
                game_board[5][6] = snake::BT_SNACK;
                game_board[5][7] = snake::BT_SNACK;
                game_board[5][8] = snake::BT_SNACK;
                game_board[7][8] = snake::BT_SNACK;
                game_board[8][8] = snake::BT_SNACK;
                game_board[5][9] = snake::BT_SNACK;
                game_board[8][9] = snake::BT_SNACK;
                game_board[5][10] = snake::BT_SNACK;
                game_board[8][10] = snake::BT_SNACK;
                game_board[5][11] = snake::BT_SNACK;
                game_board[8][11] = snake::BT_SNACK;
                game_board[5][12] = snake::BT_SNACK;
                game_board[6][12] = snake::BT_SNACK;
                game_board[7][12] = snake::BT_SNACK;
                game_board[8][12] = snake::BT_SNACK;
                
                //Letter O
                game_board[10][2] = snake::BT_SNACK;
                game_board[11][2] = snake::BT_SNACK;
                game_board[12][2] = snake::BT_SNACK;
                game_board[13][2] = snake::BT_SNACK;
                game_board[14][2] = snake::BT_SNACK;
                game_board[10][3] = snake::BT_SNACK;
                game_board[10][4] = snake::BT_SNACK;
                game_board[10][5] = snake::BT_SNACK;
                game_board[10][6] = snake::BT_SNACK;
                game_board[10][7] = snake::BT_SNACK;
                game_board[10][8] = snake::BT_SNACK;
                game_board[10][9] = snake::BT_SNACK;
                game_board[10][10] = snake::BT_SNACK;
                game_board[10][11] = snake::BT_SNACK;
                game_board[10][12] = snake::BT_SNACK;
                game_board[11][12] = snake::BT_SNACK;
                game_board[12][12] = snake::BT_SNACK;
                game_board[13][12] = snake::BT_SNACK;
                game_board[14][12] = snake::BT_SNACK;
                game_board[10][2] = snake::BT_SNACK;
                game_board[14][3] = snake::BT_SNACK;
                game_board[14][4] = snake::BT_SNACK;
                game_board[14][5] = snake::BT_SNACK;
                game_board[14][6] = snake::BT_SNACK;
                game_board[14][7] = snake::BT_SNACK;
                game_board[14][8] = snake::BT_SNACK;
                game_board[14][9] = snake::BT_SNACK;
                game_board[14][10] = snake::BT_SNACK;
                game_board[14][11] = snake::BT_SNACK;
                game_board[14][12] = snake::BT_SNACK;
                
                if (keycode[15:8] == 8'h34) begin
                    current_game_state = CGS_INITIALIZE;
                end else if (any_key_is_pressed) begin
                    current_game_state = CGS_INITIALIZE;
                end
            end
        endcase 

endmodule


module score_module(
    input logic raw_clock,
    input logic low_reset,
    input snake::score_type score,
    output snake::ssegment_type ssegment,
    output snake::anodes_type anode);

snake::digits_type digits;
logic ssegement_clock;

axi4s #(.WORD(snake::score_type)) dividend_intf();
axi4s #(.WORD(snake::quotient_type)) quotient_intf();

step_down_clock_module #(.DESIRED_FREQ(100*8),.RAW_CLOCK_FREQ(snake::RAW_CLOCK_FREQ))
step_down_clock_inst (
    .raw_clock(raw_clock),
    .low_reset(low_reset),
    .down_clock(ssegement_clock));

bcd_to_ssegment_module bcd_to_ssegment_inst(
    .raw_clock(ssegement_clock),
    .low_reset(low_reset),
    .digits(digits),
    .ssegment(ssegment),
    .anode(anode));

convert_score_module convert_score_inst (
    .raw_clock(raw_clock),
    .low_reset(low_reset),
    .score(score),
    .digits(digits),
    .dividend_intf(dividend_intf),
    .quotient_intf(quotient_intf));

divide_by_constant #(.DIVISOR(10),.DIVIDER_TYPE(snake::score_type))
divide_by_ten_inst (
    .clock(raw_clock),
    .low_reset(low_reset),
    .dividend_intf(dividend_intf),
    .quotient_intf(quotient_intf));

endmodule

module bcd_to_ssegment_module(
    input logic raw_clock,
    input logic low_reset,
    input snake::digits_type digits,
    output snake::ssegment_type ssegment,
    output snake::anodes_type anode);

localparam integer SSEGMENT_WIDTH = $bits(snake::anodes_type);

snake::digit_type ss_digit[SSEGMENT_WIDTH];
integer digit_pointer;

generate
    for (genvar each_digit=0;each_digit<snake::SCORE_DIGITS_TOTAL;each_digit++)
        assign ss_digit[each_digit] = digits[each_digit];
endgenerate
    
always @(posedge raw_clock or negedge low_reset)
    if (!low_reset) begin
        digit_pointer = 0;
        ssegment = 0;
        anode = 0;
    end else begin
        ssegment = ~snake::bcd_to_ssegment[ss_digit[digit_pointer]];
        anode = ~(1 << digit_pointer);
        if (digit_pointer==(SSEGMENT_WIDTH-1)) begin
            digit_pointer = 0;
        end else begin
            digit_pointer++;
        end
    end

endmodule

module convert_score_module(
    input logic raw_clock,
    input logic low_reset,
    input snake::score_type score,
    output snake::digits_type digits,
    axi4s.master dividend_intf,
    axi4s.slave quotient_intf);
    
enum {CS_SAMPLE_SCORE,CS_CONVERT,CS_UPDATE_DIGITS} current_state;
snake::score_type score_buff;
snake::quotient_type quotient_buff;
snake::digits_type digits_buff;
logic toggle;
integer digits_pointer;
    
always @(posedge raw_clock) 
    if (!low_reset) begin
        current_state = CS_SAMPLE_SCORE;
        score_buff = 0;
        digits = 0;
        toggle = 0;
        digits_pointer = 0;
        quotient_buff = 0;
        digits_buff = 0;
        dividend_intf.master_reset();
        quotient_intf.slave_reset();
    end else
        case (current_state)
        CS_SAMPLE_SCORE:
            begin
                score_buff = score;
                digits_buff = 0;
                digits_pointer = 0;
                current_state = CS_CONVERT;
            end
        CS_CONVERT:
            begin
                if (toggle) begin
                    if (quotient_intf.slave_receive(quotient_buff)) begin
                        toggle = 0;
                        digits_buff[digits_pointer] = quotient_buff.remainder;
                        if (quotient_buff.quotient==0) begin
                            current_state = CS_UPDATE_DIGITS;
                        end else begin
                            score_buff = quotient_buff.quotient;
                            digits_pointer++;
                        end
                        
                    end
                end else begin
                    if (dividend_intf.master_send(score_buff)) begin
                        toggle = 1;
                    end
                end
            end
        CS_UPDATE_DIGITS:
            begin
                digits = digits_buff;
                current_state = CS_SAMPLE_SCORE;
            end
        endcase

endmodule

module sample_pushbutton_module #(integer WIDTH=3,integer SAMPLE_RATE=10000)(
    input logic raw_clock,
    input logic game_clock,
    input logic low_reset,
    input logic [WIDTH-1:0] input_,
    output logic [WIDTH-1:0] output_);
    
integer counter;
logic [WIDTH-1:0] buff_0;
logic [WIDTH-1:0] buff_1;
    
// sample pushbuttons at a much lower rate
always @(posedge raw_clock or negedge low_reset)
    if (!low_reset) begin
        counter = 0;
        buff_0  = 0;
    end else begin
        if (counter==(SAMPLE_RATE-1)) begin
            counter = 0;
            buff_0 = input_;
        end else begin
            counter++;
        end
    end
    
// pushbutton events are triggerred by pressing and then releasing a pushbutton
always @(posedge game_clock or negedge low_reset)
    if (!low_reset) begin
        buff_1 = 0;
        output_ = 0;
    end else begin
        foreach (buff_1[each_bit]) 
            output_[each_bit] = (!buff_0[each_bit]&&buff_1[each_bit])?1:0;
        buff_1 = buff_0;
    end

endmodule

module step_down_clock_module #(integer DESIRED_FREQ=100000,integer  RAW_CLOCK_FREQ=100000000)(
    input logic raw_clock,
    input logic low_reset,
    output logic down_clock=1);
localparam integer COUNTER_VALUE = RAW_CLOCK_FREQ/DESIRED_FREQ;
integer counter;
always @(posedge raw_clock or negedge low_reset)
    if (!low_reset) begin
        counter = 0;
        down_clock = 1;
    end else begin
        if (counter==((COUNTER_VALUE/2)-1)) begin
            down_clock = ~down_clock;
            counter = 0;
        end else begin
            counter++;
        end
    end
endmodule

module test_snake_controller(
    input logic game_clock,
    input logic low_reset,
    output logic [1:0] board_out [snake::BOARD_WIDTH][snake::BOARD_HEIGHT],
    input logic up_key_is_pressed,
    input logic down_key_is_pressed,
    input logic left_key_is_pressed,
    input logic right_key_is_pressed);

snake::board_type game_board;

 
generate;
    for (genvar each_col=0;each_col<snake::BOARD_WIDTH;each_col++)
        for (genvar each_row=0;each_row<snake::BOARD_HEIGHT;each_row++)
            assign board_out[each_col][each_row] = game_board[each_col][each_row];
endgenerate

axi4s #(.WORD(snake::loc_type)) request_interface();
axi4s #(.WORD(lfsr16::WORD)) random_interface();

acquire_random_position acquire_random_position_inst (
    .game_clock(game_clock),
    .low_reset(low_reset),
    .request(request_interface),
    .random(random_interface));
lfsr16_module lfsr16_inst (
    .clock(game_clock),
    .low_reset(low_reset),
    .data_out(random_interface));
    
snake_controller_module snake_controller_inst(
    .game_clock(game_clock),
    .low_reset(low_reset),
    .up_key_is_pressed(up_key_is_pressed),
    .down_key_is_pressed(down_key_is_pressed),
    .left_key_is_pressed(left_key_is_pressed),
    .right_key_is_pressed(right_key_is_pressed),
    .request_interface(request_interface),
    .game_board(game_board));


endmodule

//module test_acquire_random(
//    input logic game_clock,
//    input logic low_reset,
//    output snake::loc_type data_out,
//    input logic ready,
//    output logic valid);

//axi4s #(.WORD(snake::loc_type)) request_interface();
//axi4s #(.WORD(lfsr16::WORD)) random_interface();

//assign data_out = request_interface.data;
//assign request_interface.ready = ready;
//assign valid = request_interface.valid;

//acquire_random_position acquire_random_position_inst (
//    .game_clock(game_clock),
//    .low_reset(low_reset),
//    .request(request_interface),
//    .random(random_interface));
//lfsr16_module lfsr16_inst (
//    .clock(game_clock),
//    .low_reset(low_reset),
//    .data_out(random_interface));

//endmodule



module acquire_random_position(
    input logic game_clock,
    input logic low_reset,
    axi4s.master request,
    axi4s.slave random);

localparam type request_word = snake::loc_type;
localparam type random_word = lfsr16::WORD;
typedef struct { integer mask; integer amount; } dimension_type;

dimension_type dimension_data[2] = '{
    '{2**snake::LOC_COL_WIDTH-1,snake::BOARD_WIDTH},
    '{2**snake::LOC_ROW_WIDTH-1,snake::BOARD_HEIGHT}};
enum {CS_ACQUIRE_RANDOM_VALUE,CS_WAIT_FOR_REQUEST} current_state;
enum {VTG_COL,VTG_ROW} value_to_get;

snake::loc_type position;
    
always @(posedge game_clock or negedge low_reset)
    if (!low_reset) begin
        request.data = '{0,0};
        request.valid = 0;
        random.slave_reset();
        position = '{0,0};
        current_state = CS_ACQUIRE_RANDOM_VALUE;
        value_to_get = VTG_COL;
    end else
        case (current_state)
        CS_ACQUIRE_RANDOM_VALUE:
            begin
                random_word data;
                if (random.slave_receive(data)) begin
                    integer amount =  dimension_data[value_to_get].amount;
                    integer extracted_data = dimension_data[value_to_get].mask&data;
                    integer corrected_data = (extracted_data>=amount)?extracted_data-amount:extracted_data;
                    if (value_to_get==VTG_ROW) begin
                        position.row = corrected_data;
                        value_to_get = VTG_COL;
                        current_state = CS_WAIT_FOR_REQUEST;
                    end else begin
                        position.col = corrected_data;
                        value_to_get = VTG_ROW;
                    end
                end
            end
        CS_WAIT_FOR_REQUEST:
            begin
                if (request.master_send(position)) begin
                    current_state = CS_ACQUIRE_RANDOM_VALUE;
                end
            end
        endcase
    
endmodule

module snake_painter_module(
    input snake::board_type board,
    output vga::pixel_type vga_pixel,
    vga_driver_interface.master vga_inter);
    
vga::counters_type check_counters;
vga::counters_type block_counters;
    
// write pixels to vga display
always @(posedge vga_inter.pixel_clock or negedge vga_inter.low_reset)
    if (!vga_inter.low_reset) begin
        check_counters = '{0,0};
        block_counters = '{0,0};
        vga_pixel = snake::block_to_color[snake::BT_EMPTY];
    end else begin
        vga::counters_type vga_counters;
        if (vga_inter.get_coordinates(vga_counters)) begin
            vga_pixel = snake::block_to_color[board[block_counters.col][block_counters.row]];
            if (check_counters.col ==(snake::PIXELS_PER_BLOCK_WIDTH-1)) begin
                check_counters.col = 0; 
                if (block_counters.col==(snake::BOARD_WIDTH-1)) begin
                    block_counters.col = 0;
                    if (check_counters.row ==(snake::PIXELS_PER_BLOCK_HEIGHT-1)) begin
                        check_counters.row = 0;
                        if (block_counters.row==(snake::BOARD_HEIGHT-1)) begin
                            block_counters.row = 0;
                        end else begin
                            block_counters.row++;
                        end
                    end else begin
                        check_counters.row++;
                    end
                end else begin
                    block_counters.col++;
                end
            end else begin
                check_counters.col++;
            end
        end else begin
            vga_pixel = snake::block_to_color[snake::BT_EMPTY];
        end
    end
        
endmodule
