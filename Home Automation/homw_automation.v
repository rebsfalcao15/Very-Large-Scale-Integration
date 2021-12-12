//Verilog Program for Home Automation
module home_automation(
output reg b_alrm, f_alrm, heater, cooler, l_high, l_low,
input [7:0] temp_sen, lum_sen,
input d_sen, f_sen, clk, reset);

`define start 4'd0
`define fdoor 4'd2
`define fire 4'd3
`define t_heat 4'd4
`define t_cool 4'd5
`define l_bright 4'd6
`define l_dim 4'd7

reg [3:0] current_st;
reg [3:0] next_st;

parameter delay= 50;
parameter count=10;

initial
begin
	current_st <= `start; 
	next_st <= `start;
	b_alrm <= 1'b0;
	f_alrm <= 1'b0;
	heater <= 1'b0;
	cooler <= 1'b0;
	l_high <= 1'b0;
	l_low <= 1'b0;
end

//the state changes as per the sensor input
always@(posedge clk)
begin
	if(reset == 1'b1)
		next_st <=`start;
	else
		case(current_st)
		`start: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;

		end

		`fdoor: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end

		`fire: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end

		`t_cool: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end

		`t_heat: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end

		`l_bright: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end

		`l_dim: begin
			if(d_sen == 1'b1)
				next_st <=`fdoor;

			else if(f_sen == 1'b1)
				next_st <=`fire;

			else if(temp_sen >= 8'b1000110)
				next_st <=`t_cool;

			else if(temp_sen < 8'b1000110)
				next_st <=`t_heat;

			else if(lum_sen < 8'b1111)
				next_st <=`l_bright;

			else if(lum_sen >= 8'b1111)
				next_st <=`l_dim;
		end 

		default: next_st <= `start;

	endcase
current_st <= next_st;
end

//code for output logic
always @(posedge clk)
begin
	if(reset)
		next_st <= `start;
	else 
		case(current_st)
		`start: begin
			b_alrm = 1'b0;
			f_alrm = 1'b0;
			heater = 1'b0;
			cooler = 1'b0;
			l_high = 1'b0;
			l_low = 1'b0;
		end

		`fdoor: begin
			b_alrm = 1'b1;
			#delay b_alrm = 1'b0;
		end 

		`fire: begin 
			f_alrm = 1'b1;
			#delay f_alrm = 1'b0;
		end 

		`t_heat: begin
			if(temp_sen < 8'b1000110)
				heater = 1'b1;
			else if(temp_sen > 8'b1000110)
				heater = 1'b0;
		end 

		`t_cool: begin 
			if(temp_sen > 8'b1000110)
				cooler = 1'b1;
			if(temp_sen < 8'b1000110)
				cooler = 1'b0;
		end

		`l_bright: begin
			if(lum_sen < 8'b1111)
				l_low = 1'b1;
			else if(lum_sen > 8'b1111)
				 l_low = 1'b0;
		end

		`l_dim: begin 
			if(lum_sen >= 8'b1111)
				l_high = 1'b1;
			else if(lum_sen < 8'b1111)
				 l_high = 1'b0;
		end

		default: begin
			b_alrm = 1'b0;
			f_alrm = 1'b0;
			heater = 1'b0;
			cooler = 1'b0;
			l_high = 1'b0;
			l_low = 1'b0;
		end
	endcase
end
endmodule

//testbench for home automation 
module test_home_automation;
wire b_alrm;
wire f_alrm;
wire heater;
wire cooler;
wire l_high;
wire l_low;
reg [7:0] temp_sen, lum_sen;
reg d_sen, f_sen;
reg clk= 1'b1;
reg reset= 1'b0;
 
home_automation HA( b_alrm, f_alrm, heater, cooler, l_high, l_low, temp_sen, lum_sen, d_sen, f_sen, clk, reset);
always 
#5 clk =~ clk;

initial
begin
d_sen = 1'b0;
f_sen = 1'b0;
temp_sen = 8'b0;
lum_sen = 8'b0;
#50 temp_sen= 8'b1110_1110; 
#50 temp_sen= 8'b0;
#50 reset = 1'b1;
#50 reset = 1'b0;
#50 d_sen= 1'b1;
#50 d_sen= 1'b0;
#50 temp_sen= 8'b0000_1110; 
#50 temp_sen= 8'b0;
#50 f_sen= 1'b1;
#50 f_sen= 1'b0;
#50 lum_sen= 8'b0111;
#200 lum_sen= 8'b0;
#50 temp_sen= 8'b1000_1110; 
end 
endmodule
