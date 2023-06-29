`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2022 20:24:30
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
    input wire clk,
    input left, right, up, down, //przyciski kontrolujace ruch weza
    output wire Hsync, //output synchronizacji pozioma
    output wire Vsync, //output synchronizacji pionowej
    //outputy VGA
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
    );

     
    reg [15:0] cnt;
    reg pix_stb;
    reg [1:0] direction; //kierunek ruchu weza
    
    always @(posedge clk)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;
    end
        
           
    //pozycje x oraz y pixeli   
    wire [9:0] x;                   
    wire [8:0] y;   
                                    
    wire animate;
        
    
    //wyswietlanie gry przez VGA        
    vga display (
        .i_clk(clk),
        .i_pix_stb(pix_stb),
        .hs(Hsync), 
        .vs(Vsync),
        .x_pix(x), 
        .y_pix(y),
        .animate(animate)
    );
        
    //zmienne odpowiadajace planszy gry oraz ramki    
    reg game_area; 
    reg border1;
    reg border2;
    reg border3;
    reg border4;
    
    //koordynaty potrzebne do wygenerowania ramki   
    reg [9:0] x_border1 = 0;
    reg [8:0] y_border1 = 0;
    reg [9:0] x_border2 = 620;
    reg [8:0] y_border2 = 460; 
         
    //glowa weza   
    reg s_head;
    
    //bloki ciala weza
    reg s_body1;
    reg s_body2; 
    reg s_body3;
    reg s_body4;
    reg s_body5;
    reg s_body6;
    reg s_body7;
    reg s_body8;
    reg s_body9;
    reg s_body10;
    reg s_body11;
    reg s_body12;
    reg s_body13;
    reg s_body14;
    reg s_body15;
    reg s_body16;
    reg s_body17;
    reg s_body18;
    reg s_body19;
    reg s_body20;
    
    //koordynaty odpowiadajace lewemu gornemu rogowi kazdego bloku weza, 
    //poczatkowe wartosci blokow generowanych po zjedzeniu ustawione sa na 0, 0
    reg [9:0] x_head = 150;
    reg [8:0] y_head = 150;
    reg [9:0] x_body1 = 150;
    reg [8:0] y_body1 = 130;
    reg [9:0] x_body2 = 0;
    reg [8:0] y_body2 = 0;
    reg [9:0] x_body3 = 0;
    reg [8:0] y_body3 = 0;
    reg [9:0] x_body4 = 0;
    reg [8:0] y_body4 = 0;
    reg [9:0] x_body5 = 0;
    reg [8:0] y_body5 = 0;
    reg [9:0] x_body6 = 0;
    reg [8:0] y_body6 = 0;
    reg [9:0] x_body7 = 0;
    reg [8:0] y_body7 = 0;
    reg [9:0] x_body8 = 0;
    reg [8:0] y_body8 = 0;
    reg [9:0] x_body9 = 0;
    reg [8:0] y_body9 = 0;
    reg [9:0] x_body10 = 0;
    reg [8:0] y_body10 = 0;
    reg [9:0] x_body11 = 0;
    reg [8:0] y_body11 = 0;
    reg [9:0] x_body12 = 0;
    reg [8:0] y_body12 = 0;
    reg [9:0] x_body13 = 0;
    reg [8:0] y_body13 = 0;
    reg [9:0] x_body14 = 0;
    reg [8:0] y_body14 = 0;
    reg [9:0] x_body15 = 0;
    reg [8:0] y_body15 = 0;
    reg [9:0] x_body16 = 0;
    reg [8:0] y_body16 = 0;
    reg [9:0] x_body17 = 0;
    reg [8:0] y_body17 = 0;
    reg [9:0] x_body18 = 0;
    reg [8:0] y_body18 = 0;
    reg [9:0] x_body19 = 0;
    reg [8:0] y_body19 = 0;
    reg [9:0] x_body20 = 0;
    reg [8:0] y_body20 = 0;
    
    
    //blok jedzenie i koordynaty pierwszego wygenerowanego bloku (na srodku planszy) 
    reg food;
    reg [9:0] x_food = 300;
    reg [8:0] y_food = 200;
          
          
    reg [4:0] speed = 0; //predkosc weza
    integer s_size = 4; //poczatkowy rozmiar weza
    reg game_start = 1; //zmienna okreslajaca poczatek gry
    reg new_food = 0; //zmienna okreslajaca moment wygenerowania nowego bloku jedzenia
    //reg game_over = 0;
    //integer score = 0;
    
           
    
    //modyfikowanie zmiennej direction, zaleznie od inputu
    always @(posedge clk)
    begin
        if(game_start)
            begin 
                direction = 0;
                game_start = 0; 
            end
        if (right && direction != 0) 
            begin
                direction=2'b01; 
            end
        if(down && direction != 2) 
            begin
                direction=2'b11;
            end
        if (left && direction != 1)
            begin
                direction=2'b00;
            end
        if(up && direction != 3)
            begin
                direction=2'b10;
            end
    end
    
    //animowanie weza oraz kontrola predkosci
    always @(posedge animate)
    begin
        speed <= speed + 1;
    end  
       
    //logika gry
    always@(posedge speed[3])
    begin
    
    //sprawdzenie czy blok glowy weza jest "w srodku" bloku jedzenia
        if((((x_head - x_food < 20) & (x_head - x_food > 0)) 
        || ((x_food - x_head > 0) & (x_food - x_head < 20))) 
        & (((y_head - y_food < 20) & (y_head - y_food > 0))
        || ((y_food - y_head < 20)) & (y_food - y_head > 0)))
    
    //jezeli tak to zwiekszamy rozmiar oraz ustawiamy zmienna okreslajaca moment wygenerowania nowego bloku jedzenia = 1  
            begin
                s_size = s_size + 1; 
                new_food = 1;
            end
    
    //jezeli zmienna new_food == 1. generujemy pseudolosowo koordynaty nowego bloku jedzenia       
        if(new_food)
            begin
                x_food = 80 + (x_head*2 + x_body1*2 + x_body2*1)%450 ;
                y_food = 80 + (y_head*2 + x_body1)%320; 
                new_food = 0;
            end    
            
        ////sprawdzenie czy blok glowy weza jest "w srodku" bloku ramki planszy   
        //if(((((x_head - x_border1 < 640) & (x_head - x_border1 > 0)) 
        //|| ((x_border1 - x_head > 0) & (x_border1 - x_head < 640))) 
        //& (((y_head - y_border1 < 20) & (y_head - y_border1 > 0))
        //|| ((y_border1 - y_head < 20)) & (y_border1 - y_head > 0)))
            
        //|| ((((x_head - x_border1 < 640) & (x_head - x_border1 > 0)) 
        //|| ((x_border1 - x_head > 0) & (x_border1 - x_head < 640))) 
        //& (((y_head - y_border1 < 480) & (y_head - y_border1 > 460))
        //|| ((y_border1 - y_head < 480)) & (y_border1 - y_head > 460)))
              
        //|| ((((x_head - x_border1 < 20) & (x_head - x_border1 > 0)) 
        //|| ((x_border1 - x_head > 0) & (x_border1 - x_head < 20))) 
        //& (((y_head - y_border1 < 480) & (y_head - y_border1 > 0))
        //|| ((y_border1 - y_head < 480)) & (y_border1 - y_head > 0)))
            
        //|| ((((x_head - x_border1 < 640) & (x_head - x_border1 > 620)) 
        //|| ((x_border1 - x_head > 620) & (x_border1 - x_head < 640))) 
        //& (((y_head - y_border1 < 480) & (y_head - y_border1 > 0))
        //|| ((y_border1 - y_head < 480)) & (y_border1 - y_head > 0))))
        
            ////jezeli tak to ustawienie konca gry == 1
            //begin
                //game_over = 1;
            //end
    
        ////reset gry do wartosci poczatkowych jezeli game_over == 1
        //if (game_over)
        //begin
            //s_size = 4;
            //x_head = 200;
            //y_head = 150;
            //x_body1 = 200;
            //y_body1 = 130;
            //x_body2 = 0;
            //y_body2 = 0;
            //x_body3 = 0;
            //y_body3 = 0;
            //x_body4 = 0;
            //y_body4 = 0;
            //x_body5 = 0;
            //y_body5 = 0;
            //x_body6 = 0;
            //y_body6 = 0;
            //x_body7 = 0;
            //y_body7 = 0;
            //x_body8 = 0;
            //y_body8 = 0;
            //x_body9 = 0;
            //y_body9 = 0;
            //x_body10 = 0;
            //y_body10 = 0;
            //x_body11 = 0;
            //y_body11 = 0;
            //x_body12 = 0;
            //y_body12 = 0;
            //x_body13 = 0;
            //y_body13 = 0;
            //x_body14 = 0;
            //y_body14 = 0;
            //x_body15 = 0;
            //y_body15 = 0;
            //x_body16 = 0;
            //y_body16 = 0;
            //x_body17 = 0;
            //y_body17 = 0;
            //x_body18 = 0;
            //y_body18 = 0;
            //x_body19 = 0;
            //y_body19 = 0;
            //x_body20 = 0;
            //y_body20 = 0;
            //x_food = 310; 
            //y_food = 230; 
            //game_over = 0;
        //end
        
    //ruch weza, zastepowanie odpowiednich blokow nastepnym blokiem w zaleznosci od rozmiaru
    y_body1 <= y_head; 
    x_body1 <= x_head;
    
    if(s_size>2)       
        begin
            y_body2 <= y_body1;
            x_body2 <= x_body1;
        end  
    if(s_size>3)
        begin
            y_body3 <= y_body2;
            x_body3 <= x_body2;
        end
    if(s_size>4)
        begin
            y_body4 <= y_body3;
            x_body4 <= x_body3;
        end
    if(s_size>5)
        begin
            y_body5 <= y_body4;
            x_body5 <= x_body4;
        end
    if(s_size>6)
        begin
            y_body6 <= y_body5;
            x_body6 <= x_body5;
        end
    if(s_size>7)
        begin
            y_body7 <= y_body6;
            x_body7 <= x_body6;
        end
    if(s_size>8)
        begin
            y_body8 <= y_body7;
            x_body8 <= x_body7;
        end
    if(s_size>9)
        begin
            y_body9 <= y_body8;
            x_body9 <= x_body8;
        end
    if(s_size>10)
        begin
            y_body10 <= y_body9;
            x_body10 <= x_body9;
        end
    if(s_size>11)
        begin
            y_body11 <= y_body10;
            x_body11 <= x_body10;
        end
    if(s_size>12)
        begin
            y_body12 <= y_body11;
            x_body12 <= x_body11;
        end
    if(s_size>13)
        begin
            y_body13 <= y_body12;
            x_body13 <= x_body12;
        end
    if(s_size>14)
        begin
            y_body14 <= y_body13;
            x_body14 <= x_body13;
        end
    if(s_size>15)
        begin
            y_body15 <= y_body14;
            x_body15 <= x_body14;
        end
    if(s_size>16)
        begin
            y_body16 <= y_body15;
            x_body16 <= x_body15;
        end
    if(s_size>17)
        begin
            y_body17 <= y_body16;
            x_body17 <= x_body16;
        end
    if(s_size>18)
        begin
            y_body18 <= y_body17;
            x_body18 <= x_body17;
        end
    if(s_size>19)
        begin
            y_body19 <= y_body18;
            x_body19 <= x_body18;
        end
    if(s_size>20)
        begin
            y_body20 <= y_body19;
            x_body20 <= x_body19;
        end
        
        
    //ruch weza zalezny od zmiennej direction, ktorej wartosc ustawiana jest po odpowiedniom nacisnieciu przycisku
    //waz porusza sie odpowiednio o 30 pixeli
    if(direction == 0) //input = left
        begin
            x_head <= x_head - 30;
        end
    if(direction == 1) // input = right
        begin
            x_head <= x_head + 30;
        end
    if(direction == 3) //input = down
        begin
            y_head <= y_head + 30;
        end
    if(direction == 2) //input = up
        begin
            y_head <= y_head - 30;
        end
    end
    
        
    //deklaracja obiektow gry    
    always@(*)
    begin
        game_area = (x>20) & (x<620) & (y>20) & (y< 460);  //plansza jest 640x480, wiec obszar gry jest 620x460, animate
                                                           //ramka ma szerokosc 30 pixeli
        s_head = (x > x_head) & (x < x_head + 30) & (y>y_head) & (y<y_head + 30); //glowa weza 30x30 pixeli
             
        //kazdy element ciala weza 30x30 pixeli                                                                       
        s_body1 = (x > x_body1) & (x < x_body1 + 30) & (y>y_body1) & (y<y_body1 + 30);
        s_body2 = (x > x_body2) & (x < x_body2 + 30) & (y>y_body2) & (y<y_body2 + 30);
        s_body3 = (x > x_body3) & (x < x_body3 + 30) & (y>y_body3) & (y<y_body3 + 30);
        s_body4 = (x > x_body4) & (x < x_body4 + 30) & (y>y_body4) & (y<y_body4 + 30);
        s_body5 = (x > x_body5) & (x < x_body5 + 30) & (y>y_body5) & (y<y_body5 + 30);
        s_body6 = (x > x_body6) & (x < x_body6 + 30) & (y>y_body6) & (y<y_body6 + 30);
        s_body7 = (x > x_body7) & (x < x_body7 + 30) & (y>y_body7) & (y<y_body7 + 30);
        s_body8 = (x > x_body8) & (x < x_body8 + 30) & (y>y_body8) & (y<y_body8 + 30);
        s_body9 = (x > x_body9) & (x < x_body9 + 30) & (y>y_body9) & (y<y_body9 + 30);
        s_body10 = (x > x_body10) & (x < x_body10 + 30) & (y>y_body10) & (y<y_body10 + 30);
        s_body11 = (x > x_body11) & (x < x_body11 + 30) & (y>y_body11) & (y<y_body11 + 30);
        s_body12 = (x > x_body12) & (x < x_body12 + 30) & (y>y_body12) & (y<y_body12 + 30);
        s_body13 = (x > x_body13) & (x < x_body13 + 30) & (y>y_body13) & (y<y_body13 + 30);
        s_body14 = (x > x_body14) & (x < x_body14 + 30) & (y>y_body14) & (y<y_body14 + 30);
        s_body15 = (x > x_body15) & (x < x_body15 + 30) & (y>y_body15) & (y<y_body15 + 30);
        s_body16 = (x > x_body16) & (x < x_body16 + 30) & (y>y_body16) & (y<y_body16 + 30);
        s_body17 = (x > x_body17) & (x < x_body17 + 30) & (y>y_body17) & (y<y_body17 + 30);
        s_body18 = (x > x_body18) & (x < x_body18 + 30) & (y>y_body18) & (y<y_body18 + 30);
        s_body19 = (x > x_body19) & (x < x_body19 + 30) & (y>y_body19) & (y<y_body19 + 30);
        s_body20 = (x > x_body20) & (x < x_body20 + 30) & (y>y_body20) & (y<y_body20 + 30);
        
        //blok jedzenie rowniez 30x30 pixeli
        food = (x > x_food) & (x < x_food + 30) & (y > y_food) & (y < y_food + 30); 
        
        //ramka gry, sklada sie z 4 blokow o szerokosci 20 pixeli i dlugosci odpowiednio 640 lub 480 pixeli
        border1 = (x > x_border1) & (x < x_border1 + 640) & (y > y_border1) & (y < y_border1 + 20);
        border2 = (x > x_border1) & (x < x_border1 + 20) & (y > y_border1) & (y < y_border1 + 480);
        border3 = (x > x_border1) & (x < x_border1 + 640) & (y > y_border2) & (y < y_border1 + 480);
        border4 = (x > x_border2) & (x < x_border1 + 640) & (y > y_border1) & (y < y_border1 + 480);
    end
        
        
    //dobranie kolorow gry
    always@(*)
    begin        
        vgaGreen[3] = s_body1 | s_body2 | s_body3 | s_body4 | s_body5 | s_body6 | s_body7 | s_body8 | s_body9 | s_body10 | s_body11 | s_body12 | s_body13 & ~(food | s_head);
        vgaBlue[3] = food | border1 | border2 | border3 | border4; 
        vgaRed[3] = s_head | border1 | border2 | border3 | border4;
    
    //plansza = czarna, cialo weza = zielone, glowa weza = czerwona, ramka = niebieska + czerwona = rozowa       
    end
    
endmodule
