
`ifndef INTERFACE_HEADER_
`define INTERFACE_HEADER_


interface axi4s #(type WORD=logic [15:0]);

localparam type word = WORD;
word data;
logic valid;
logic ready;

modport master(output data,output valid,input ready,
    import function automatic logic master_send(ref word send_data),
    import task automatic master_reset);
modport slave(input data,input valid,output ready,
    import function automatic logic slave_receive(ref word receive_data),
    import task automatic slave_reset);

function automatic logic master_send;
    ref word send_data;
begin
    if (valid && ready) begin
        valid = 0;
        master_send = 1;
    end else begin
        valid = 1;
        master_send = 0;
        data = send_data;
    end
end
endfunction

function automatic logic slave_receive;
    ref word receive_data;
begin
    if (ready && valid) begin
        ready = 0;
        slave_receive = 1;
        receive_data = data;
    end else begin
        ready = 1;
        slave_receive = 0;
    end
end
endfunction

task automatic master_reset;
    data = 0;
    valid = 0;
endtask

task automatic slave_reset;
    ready = 0;
endtask

endinterface

`endif
