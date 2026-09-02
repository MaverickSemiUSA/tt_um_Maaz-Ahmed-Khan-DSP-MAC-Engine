`default_nettype none
 
module tt_um_mac_engine (
    input  wire [7:0] ui_in,    // dedicated inputs: operand data bus
    output wire [7:0] uo_out,   // dedicated outputs: accumulator byte readout
    input  wire [7:0] uio_in,   // IOs: control strobes (all used as inputs)
    output wire [7:0] uio_out,  // IOs: output path (unused, tied 0)
    output wire [7:0] uio_oe,   // IOs: direction (0 = input for every uio pin)
    input  wire        ena,     // high when the design is powered/enabled
    input  wire        clk,
    input  wire        rst_n
);
 
    wire load_a  = uio_in[0];
    wire load_b  = uio_in[1];
    wire mac_en  = uio_in[2];
    wire clr_acc = uio_in[3];
    wire rd_next = uio_in[4];
 
    reg  [7:0]  op_a, op_b;
    reg  [23:0] acc;
    reg  [1:0]  byte_ptr;
 
    wire signed [7:0]  sa = op_a;
    wire signed [7:0]  sb = op_b;
    wire signed [15:0] product = sa * sb;
 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            op_a     <= 8'd0;
            op_b     <= 8'd0;
            acc      <= 24'd0;
            byte_ptr <= 2'd0;
        end else if (ena) begin
            if (load_a) op_a <= ui_in;
            if (load_b) op_b <= ui_in;
 
            if (clr_acc)
                acc <= 24'd0;
            else if (mac_en)
                acc <= acc + {{8{product[15]}}, product};
 
            if (rd_next)
                byte_ptr <= byte_ptr + 2'd1;
        end
    end
 
    reg [7:0] acc_byte;
    always @(*) begin
        case (byte_ptr)
            2'd0:    acc_byte = acc[7:0];
            2'd1:    acc_byte = acc[15:8];
            default: acc_byte = acc[23:16];
        endcase
    end
 
    assign uo_out  = acc_byte;
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;
 
    wire _unused = &{uio_in[7:5], 1'b0};
 
endmodule
