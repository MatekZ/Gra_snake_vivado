`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2022 20:15:21
// Design Name:
// Module Name: vga
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


module vga(
    input wire i_clk,           
    input wire i_pix_stb,      
    output wire hs, //output synchronizacji pozioma
    output wire vs, //output synchronizacji pionowej
    output wire [9:0] x_pix, //pozycja x pixeli
    output wire [8:0] y_pix, //pozycja x pixeli
    output wire animate
    );

    //paramety pozwalajace stworzyc plansze gry 640x480
    localparam HS_START = 16; // Front porch - start synchronizacji poziomej
    localparam HS_END = 16 + 96; // Front porch + Sync pulse - koniec synchronizacji poziomej
    localparam PIX_START = 16 + 96 + 48; // Front porch + Sync pulse + Back porch - start aktywnyhc pixeli
    localparam VS_START = 480 + 10; // Visible area + Front porch - start synchronizacji pionowej
    localparam VS_END = 480 + 10 + 2; // Visible area + Front porch + Sync pulse - koniec synchronizacji pionowej
    localparam LINE_END = 480; // Visible area - koniec aktywnych lini poziomych
    localparam LINE   = 800; // Whole line 
    localparam FRAME = 525; // Whole frame
    
    reg [9:0] h_count;  // pozycja lini
    reg [9:0] v_count;  // pozycja frame
        
    assign hs = ~((h_count >= HS_START) & (h_count < HS_END));
    assign vs = ~((v_count >= VS_START) & (v_count < VS_END));
    
    assign x_pix = (h_count < PIX_START) ? 0 : (h_count - PIX_START);
    assign y_pix = (v_count >= LINE_END) ? (LINE_END - 1) : (v_count); 
    assign animate = ((v_count == LINE_END - 1) & (h_count == LINE));
    
    
    always @ (posedge i_clk)
    begin
        if (i_pix_stb)
            begin
                if (h_count == LINE)
                begin
                    h_count <= 0;
                    v_count <= v_count + 1;
                end
                else 
                    h_count <= h_count + 1;
    
                if (v_count == FRAME)
                    v_count <= 0;
                else;
            end
    end
endmodule

