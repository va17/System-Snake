
`ifndef RANDOM_HEADER_
`define RANDOM_HEADER_

`include "interface_header.vh"

class lfsr16;

localparam type WORD = logic [15:0];

endclass

class math;

static function integer compute_log2;
    input integer amount;
 begin
    compute_log2 = 0;
    for (integer mask=1;mask<=amount;mask<<=1)
        compute_log2++;
 end
 endfunction

endclass

class quotient #(type DIVIDE_TYPE=logic [15:0]);

typedef struct packed {
    DIVIDE_TYPE quotient;
    DIVIDE_TYPE remainder;
} quotient_type;

endclass

`endif