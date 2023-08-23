`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2023 18:14:13
// Design Name: 
// Module Name: buffer_draw
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


module buffer_draw #(
    GRID=16
    )
    (
    input wire [7:0] ascii,
    output reg [3:0] frame[GRID - 1:0][GRID - 1:0]
    );
    
    reg [GRID / 2 :0] i, j; 
        
    always_comb begin
    
      case (ascii)
            8'h41: // ASCII value for 'A'
                for (i = 0; i < GRID; i = i + 1)
                    for (j = 0; j < GRID; j = j + 1)
                        frame[i][j] = (i < GRID/2) && (j == GRID/2) ? 4'hF : 0;
            
            8'h42: // ASCII value for 'B'
                for (i = 0; i < GRID; i = i + 1)
                    for (j = 0; j < GRID; j = j + 1)
                        frame[i][j] = ((i == 0 || i == GRID-1 || i == GRID/2) || 
                                      (j == 0 || j == GRID-1)) ? 4'hF : 0;
                                      
            8'h43: // ASCII value for 'C'
                for (i = 0; i < GRID; i = i + 1)
                  for (j = 0; j < GRID; j = j + 1)
                      frame[i][j] = ((i == 0 || i == GRID-1) && (j > 0 && j < GRID-1)) ? 4'hF : 4'h0;
                      
            8'h44: // ASCII value for 'D'
                for (i = 0; i < GRID; i = i + 1)
                  for (j = 0; j < GRID; j = j + 1)
                      frame[i][j] = ((i == 0 || i == GRID-1) || 
                                    (j == 0 || j == GRID-1) && (i > 0 && i < GRID-1)) ? 4'hF : 4'h0;

            // Add cases for other letters as needed
            default:
                for (i = 0; i < GRID; i = i + 1)
                    for (j = 0; j < GRID; j = j + 1)
                        frame[i][j] = 4'h3; // Blank pattern
        endcase 
    end
    
 endmodule 