`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2023 18:14:13
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire IO_BTN_C,         // reset button
    input wire [15:0] IO_SWITCH,
    output wire VGA_Hsync,       // horizontal sync output
    output wire VGA_Vsync,       // vertical sync output
    output reg [3:0] VGA_Red,    // 4-bit VGA red output
    output reg [3:0] VGA_Green,    // 4-bit VGA green output
    output reg [3:0] VGA_Blue     // 4-bit VGA blue output    
);

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge clk)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    
    localparam SCREENSIZE_X = 640; //Number of X pixels in the screen
    localparam SCREENSIZE_Y = 480; //Number of Y pixels in the screen
        
    integer i, j;
    
    vga640x480 display (
        .i_clk(clk),            // base clock
        .i_pix_stb(pix_stb),    // pixel clock strobe
        .i_rst(IO_BTN_C),            // reset: restarts frame
        .o_hs(VGA_Hsync),       // horizontal sync
        .o_vs(VGA_Vsync),       // vertical sync
        .o_x(x),                // current pixel x position
        .o_y(y),                // current pixel y position
        .o_animate(animate)     // high for one tick at end of active drawing
    );
    
//    always @(posedge animate) done <= 1;

    parameter GRID = 128;

    reg [7:0] ascii;
    reg [3:0] frame[GRID-1:0][GRID-1:0];
    
    reg [9:0] x_offset;
    reg [8:0] y_offset;    
    
    buffer_draw #(.GRID(GRID)) letter_draw(
        .ascii(ascii),
        .frame(frame)
    );
    
    always_comb begin
        ascii <= 8'h41 + IO_SWITCH[3:0];
    end
    
    always_ff @(posedge animate) begin
        x_offset = (x_offset + IO_SWITCH[14]) % SCREENSIZE_X;
        y_offset = (y_offset + IO_SWITCH[15]) % SCREENSIZE_Y;
    end
        
    always @(posedge clk) begin
        if ((y - y_offset < GRID) & (x - x_offset < GRID) & (x - x_offset >= 0) & (y - y_offset >= 0))
        begin
            VGA_Red <= frame[y - y_offset][x -  x_offset];
            VGA_Green <= frame[y - y_offset][x -  x_offset];
            VGA_Blue <= frame[y - y_offset][x -  x_offset];
        end
        else 
        begin
            VGA_Red <= 0;
            VGA_Green <= 0;
            VGA_Blue <= 0;
        end
    end
endmodule