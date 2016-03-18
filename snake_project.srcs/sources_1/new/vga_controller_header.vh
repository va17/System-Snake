`ifndef VGA_CONTROLLER_HEADER_
`define VGA_CONTROLLER_HEADER_

// This VGA interface is highly based on the VHDL version from
// the following source.
// https://eewiki.net/pages/viewpage.action?pageId=15925278

class vga;

typedef enum {
    _640x480,_800x600,_1280x1024
} resolution;

typedef struct {
    integer width;
    integer front_porch;
    integer synch;
    integer back_porch;
    logic polarity;
} dimension_type;

typedef struct {
    integer pixel_clock;
    integer refresh_rate;
    dimension_type horizontal;
    dimension_type vertical;
} config_type;

typedef struct {
    integer col;
    integer row;
} counters_type;

typedef logic [7:0] color_type;
typedef struct {
    color_type red;
    color_type green;
    color_type blue;
} pixel_type;

// This array contains the possible configurations
// for the vga driver interface. Each entry corresponds
// to the enumerator resolution.
localparam config_type possible_configs[3] = '{
    '{ // _640x480
        60,
        25175000,
        '{640,16,96,48,0},
        '{480,10,2,33,0}
    }, '{ // _800x600
        60,
        40000000,
        '{800,40,128,88,1},
        '{600,1,4,23,1}
    }, '{ // _1280x1024
        60,
        108000000,
        '{1280,48,112,248,1},
        '{1024,1,3,38,1}
    }
};

endclass

interface vga_driver_interface(
    input logic pixel_clock,
    input logic low_reset);

logic displaying_flag;
vga::counters_type counters;

modport master(input displaying_flag,input counters,
    import function automatic logic get_coordinates(ref vga::counters_type out_counters));
modport slave(output displaying_flag,output counters);

function automatic logic get_coordinates;
    ref vga::counters_type out_counters;
begin
    out_counters.col = counters.col;
    out_counters.row = counters.row;
    get_coordinates = displaying_flag;
end
endfunction

endinterface

`endif