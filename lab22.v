module lab22(//input Count,
			output reg [7:0] DATA_R, DATA_G, DATA_B,
			output reg [2:0] COMM,
			output reg [2:0] s = 3'b000,
			output reg [2:0] s4 = 3'b000,
			input left, right, change, down,
			output enable,
			output IH,
			output testled,
			output reg [0:7] level = 8'b00000000,
			output reg [0:6] z = 7'b0000001,
			input CLK,
			input		reg	rst_n,
			output	reg			lcd_rs,
			output		lcd_rw,
			output	reg			lcd_en,
			output	reg	[7:0]	lcd_data	
			);
			assign enable = 1'b1;
			int now = 0;
			reg newblock;
			int level_n = 0;
	var bit [0:7] blank = 8'b11111111;
			
	var bit [7:0][7:0] blank_Char = '{8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111};
	var bit [0:7][0:7] windows_Char = '{8'b11111111,
													8'b10011001,
													8'b10011001,
													8'b11111111,
													8'b11100111,
													8'b11011011,
													8'b10111101,
													8'b01111110};
	var bit [0:10][0:11] front_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] blank_front_Char = '{12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111};
	var bit [0:10][0:11] back_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] backup_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] back_test_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] front_test_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] back_test_two_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] over_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111111111};
	
	parameter logic [0:3] tetris [0:111] = '{//I
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  
													  4'b1111,
													  4'b1111,
													  4'b1111,
													  4'b0000,
													  
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  
													  4'b1111,
													  4'b1111,
													  4'b1111,
													  4'b0000,
													  //J
													  4'b1011,
													  4'b1011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0111,
													  4'b0001,
													  4'b1111,
													  
													  4'b0011,
													  4'b0111,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b1101,
													  4'b1111,
													  //L
													  4'b0111,
													  4'b0111,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b0111,
													  4'b1111,
													  
													  4'b0011,
													  4'b1011,
													  4'b1011,
													  4'b1111,
													  
													  4'b1111,
													  4'b1101,
													  4'b0001,
													  4'b1111,
													  //O
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  //S
													  4'b1111,
													  4'b1001,
													  4'b0011,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  
													  4'b1111,
													  4'b1001,
													  4'b0011,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  //T
													  4'b1111,
													  4'b1011,
													  4'b0001,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b1011,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  //Z
													  4'b1111,
													  4'b0011,
													  4'b1001,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b1001,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b0111,
													  4'b1111};
	
	divfreq F0 (CLK, CLK_div);
	divfreq2 F1 (CLK, CLK_div2);
	divfreq_change F4 (CLK, CLK_div_change);
	lcd	F5(
					.clk(CLK),
					.rst_n(rst_n),
					.lcd_rs(lcd_rs),
					.lcd_rw(lcd_rw),
					.lcd_en(lcd_en),
					.lcd_data(lcd_data)	
	);

	byte cnt;
	int x;
	int y;
	byte tmp_x;
	byte tmp_y;
	reg flag1;
	reg [0:1] rotate = 2'b00;
	int over;
	int clean_flag;

	initial
		begin
			cnt = 0;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			IH = 0;
			newblock <= 0;
			x = 5;
			y = 9;
			tmp_x = 0;
			tmp_y = 0;
			rotate = 0;
			flag1 <= 1'b1;
			s <= s4%7;
			over = 0;
			z <= 7'b0000001;
			level_n = 0;
		end
	
	always @(posedge CLK_div)// update screen
		begin
			if(cnt >= 7)
				cnt <= 0;
			else
				cnt <= cnt+1;
			COMM <= cnt;
			
			
			if(newblock)
			begin
				//testled <= 1'b0;
				back_Char <= back_Char&front_Char;
				s <= s4%7; //get new block
				
				
				//clean whole line
				for(int j=0;j<8;j++)
				begin
					
					clean_flag = 1;
					for(int i=2;i<10;i++)
						if(back_Char[i][j]==1'b1)
							clean_flag = 0;
					
					//if((~clean_Char&~back_Char)==(~clean_Char)) //old
					if(clean_flag)
					begin
						for(int i=0;i<11;i++)
							begin
								for(int element=j;element<7;element++)
									back_Char[i][element] <= back_Char[i][element+1];
								back_Char[i][7] <= 1'b1;
							end
						//level max -> level up (speed up)
						if(level == 8'b10000000)//if you want to level up quickly, change to 8'b10000000 will level up very fast and easy
						begin
							level_n = level_n + 1;
							level <= 8'b00000000;
							
						end
						//level plus
						else
							level <= {1'b1, level[0:6]};
					end
				end
				
				//game over
				if(~over_Char&~back_Char) //vector "every bit AND", a quickly way
				begin
					front_Char <= blank_front_Char;
					back_Char <= blank_front_Char;
					over = 1;
					level <= 8'b00000000;
					level_n = 0;
				end
				
			end
			
			//clean
			front_Char <= blank_front_Char;
			//GAME OVER will NOT show new blocks, windows cry only
			if(over==0)
			begin
			for(int i=0;i<4;i++)
				begin
					front_Char[x+i][y+:4] <= tetris[s*16+i+rotate*4];
				end
			end
			
			//print
			//DATA_B <= clean_Char[cnt+2][0:7];
			DATA_R <= front_Char[cnt+2][0:7];
			DATA_G <= back_Char[cnt+2][0:7];
			
			//print level number
			//Hexadecimal to 7SEG
			if(level_n==0)
				z <= 7'b0000001;
			else if(level_n==1)
				z <= 7'b1001111;
			else if(level_n==2)
				z <= 7'b0010010; 
			else if(level_n==3)
				z <= 7'b0000110;
			else if(level_n==4)
				z <= 7'b1001100;
			else if(level_n==5)
				z <= 7'b0100100; 
			else if(level_n==6)
				z <= 7'b0100000;
			else if(level_n==7)
				z <= 7'b0001111;
			else if(level_n==8)
				z <= 7'b0000000;
			else if(level_n==9)
				z <= 7'b0000100;
			else
				z <= 7'b0000000;
			
			//print GAME OVER :(
			if(over>0&&over<50000)
			begin
				DATA_B <= ~windows_Char[cnt];
				DATA_G <= windows_Char[cnt];
				DATA_R <= windows_Char[cnt];
				over++;
			end
			else if(over>=50000)
			begin
				DATA_B <= 8'b11111111;
				over=0;
			end
			//prepare for touch check
			for(int i=0;i<11;i++)
			begin
				back_test_Char[i] <= {1'b0, back_Char[i][0:7],3'b111};
				back_test_two_Char[i] <= {2'b00, back_Char[i][0:5],4'b1111};
				front_test_Char[i] <= {front_Char[i][0:8],3'b111};
			end
			
		end
	always @(posedge CLK_div2)// quickly add number as random base
		begin
			s4 <= s4 + 1'b1;
		end
	always @(posedge CLK_div_change)
		begin
			if(over==0)
			begin
				int count = 0;
				int dcount = 0;
				int slow = 0;
				//user input
				if(slow > 10)
				begin
					slow = 0;
					if(change)
					begin
						rotate <= rotate + 1'b1;
					end
					else if(left && front_Char[2]==12'b111111111111)
						x = x - 1;
					else if(right && front_Char[9]==12'b111111111111)
						x = x + 1;
				end
				else
					slow++;
				
				if(newblock==1)
					newblock<=0;
				else if(down && y>0 &&~(~front_test_Char&~back_test_two_Char) && dcount == 0)			// 0 present that HAVE BLOCK
				begin
					y = y - 1;
					dcount = 1;
					count = 0;
				end
				else if(count>40 - 4*level_n)
				begin
					count <= 0;
					dcount = 1;
					
					if(~front_test_Char&~back_test_Char) //hit floor
						begin
							newblock <= 1;
							x = 5;
							y = 9;
							rotate <= 0;
						end	
					else if(y>0)
						y = y - 1;
					else
					begin
						newblock <= 1;
						x = 5;
						y = 9;
						rotate <= 0;
				end
			end
			else
				count++;
			
			//prevent user fall down too fast
			if(dcount>20&&~(~front_test_Char&~back_test_two_Char))
				dcount = 0;
			else if(~(~front_test_Char&~back_test_two_Char))
				dcount = dcount + 1;
			else
				dcount = 0;
			
			//fix tetris overflow
			if(x==1 && tetris[s*16+rotate*4]!=4'b1111)
				x = x + 1;
			if(x==0 && s==0 && (rotate==0||rotate==2))
				x = x + 2;
			else if(x==-1 && s==0 && (rotate==0||rotate==2))
				x = x + 3;
		
			end
		end
endmodule

//update front and do lots of things immediately
module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count > 2000)//2000
		begin
			Count <= 25'b0;
			CLK_div <= ~CLK_div;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

//generate random number
module divfreq2(input CLK, output reg CLK_div2);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count >= 333)
		begin
			Count <= 25'b0;
			CLK_div2 <= ~CLK_div2;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

//tetris full down speed
module divfreq_change(input CLK, output reg CLK_div_change);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count >= 500000)
		begin
			Count <= 25'b0;
			CLK_div_change <= ~CLK_div_change;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

module lcd(
	input				clk,
	input				rst_n,
	
	output	reg			lcd_rs,
	output			lcd_rw,
	output	reg			lcd_en,
	output	reg	[7:0]	lcd_data	
	);

	reg	[17:0]	cnt;
	reg	[3:0]	state_c;
	reg	[3:0]	state_n;
	reg	[4:0]	char_cnt;
	reg	[7:0]	data_display;

	localparam
		IDLE			= 4'd0,
		INIT 			= 4'd1,
		S0				= 4'd2,
		S1				= 4'd3,
		S2				= 4'd4,
		S3				= 4'd5,
		ROW1_ADDR		= 4'd6,
		WRITE			= 4'd7,
		ROW2_ADDR		= 4'd8,
		stop			= 4'd9;


	assign lcd_rw = 1'b0;


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 17'd0;
		end
		else begin
			if (cnt==17'd100_000 - 1) begin
				cnt <= 17'd0;
			end
			else begin
				cnt <= cnt + 1'b1;
			end
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_en <= 0;
		end
		else if (cnt==17'd50_000 - 1) begin
			lcd_en <= 1;
		end
		else if (cnt==17'd100_000 - 1) begin
			lcd_en <= 0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			char_cnt <= 0;
		end
		else if (state_c==WRITE && cnt==17'd50_000 - 1) begin
			if (char_cnt==5'd24) begin
				char_cnt <= 5'd0;
			end
			else begin
				char_cnt <= char_cnt + 1'b1;
			end
		end
	end

	always @(*) begin
		case(char_cnt)
			5'd0: data_display   = "T";
			5'd1: data_display   = "e";
			5'd2: data_display   = "t";
			5'd3: data_display   = "r";
			5'd4: data_display   = "i";
			5'd5: data_display   = "s";
			5'd6: data_display   = " ";
			5'd7: data_display   = "B";
			5'd8: data_display   = "A";
			5'd9: data_display   = "T";
			5'd10: data_display  = "T";
			5'd11: data_display  = "L";
			5'd12: data_display  = "E";
			5'd13: data_display  = "G";
			5'd14: data_display  = "o";
			5'd15: data_display  = "o";
			5'd16: data_display  = "d";
			5'd17: data_display  = "g";
			5'd18: data_display  = "a";
			5'd19: data_display  = "m";
			5'd20: data_display  = "e";
			5'd21: data_display  = "?";
			5'd22: data_display  = "?";
			5'd23: data_display  = "!";
			5'd24: data_display  = "!";
			default:data_display = "P";
		endcase
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state_c <= IDLE;
		end
		else if(cnt==17'd50_000 - 1) begin
			state_c <= state_n;
		end
	end

	reg	[19:0]	cnt_15ms;
	reg		flag	;
	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			cnt_15ms <= 0;
		end
		else if (state_c == IDLE) begin
			cnt_15ms <= cnt_15ms + 1'b1;
		end
	end

	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			flag <= 0;
		end
		else if (state_c==IDLE && cnt_15ms==20'd750000) begin
			flag <= 1;
		end
	end

	always @(*) begin
		case(state_c)
			IDLE		:
				begin
					if (flag) begin
						state_n = INIT;
					end
					else begin
						state_n = state_c;
					end
				end
			INIT 	:
				begin
					state_n = S0;
				end
			S0  	:
				begin
					state_n = S1;
				end
			S1  	:
				begin
					state_n = S2;
				end
			S2  	:
				begin
					state_n = S3;
				end
			S3  	:
				begin
					state_n = ROW1_ADDR;
				end
			ROW1_ADDR:
				begin
					state_n = WRITE;
				end
			WRITE		:
				begin
					if (char_cnt==5'd12) begin
						state_n = ROW2_ADDR;
					end
					else if (char_cnt==5'd24) begin
						state_n = stop;
					end
					else begin
						state_n = state_c;
					end
				end
			ROW2_ADDR:
				begin
					state_n = WRITE;
				end
			stop		:
				begin
					state_n = stop;
				end
			default:state_n = IDLE;
		endcase
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_data <= 8'd0;
		end
		else begin
			case(state_c)
				IDLE		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				INIT 		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				S0			:begin lcd_data <= 8'h08; lcd_rs <= 0;end
				S1			:begin lcd_data <= 8'h01; lcd_rs <= 0;end
				S2			:begin lcd_data <= 8'h06; lcd_rs <= 0;end
				S3			:begin lcd_data <= 8'h0c; lcd_rs <= 0;end
				ROW1_ADDR	:begin lcd_data <= 8'h80; lcd_rs <= 0;end
				WRITE		:begin lcd_data <= data_display; lcd_rs <= 1;end
				ROW2_ADDR	:begin lcd_data <= 8'hc0; lcd_rs <= 0;end
				stop		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				default:;
			endcase
		end
	end
endmodule
