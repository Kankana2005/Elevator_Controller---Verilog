`timescale 1ns / 1ps
module
elevator_controller(clk,reset,request_floor,current_floor,motor_up,motor_down,door_open);
input clk;
input reset;
input [2:0] request_floor;

output reg [2:0] current_floor;
output reg motor_up;
output reg motor_down;
output reg door_open;

//-----------------------------------------------------
// State Encoding
//-----------------------------------------------------
parameter IDLE = 2'b00;
parameter MOVE_UP = 2'b01;
parameter MOVE_DOWN = 2'b10;
parameter OPEN_DOOR = 2'b11;
reg [1:0] state;
//-----------------------------------------------------
// FSM
//-----------------------------------------------------
always @(posedge clk or posedge reset)
begin
if(reset)
begin
state <= IDLE;
current_floor <= 2'd0;
motor_up <= 0;
motor_down <= 0;
door_open <= 0;
end
else
begin
case(state)
//-------------------------------------------------
// IDLE
//-------------------------------------------------
IDLE:
begin
motor_up <= 0;
motor_down <= 0;

door_open <= 0;
if(request_floor > current_floor)
state <= MOVE_UP;
else if(request_floor < current_floor)
state <= MOVE_DOWN;
end
//-------------------------------------------------
// MOVE UP
//-------------------------------------------------
MOVE_UP:
begin
motor_up <= 1;
motor_down <= 0;
door_open <= 0;
current_floor <= current_floor + 1;
if(current_floor + 1 == request_floor)
state <= OPEN_DOOR;
end
//-------------------------------------------------
// MOVE DOWN
//-------------------------------------------------
MOVE_DOWN:
begin
motor_up <= 0;
motor_down <= 1;
door_open <= 0;
current_floor <= current_floor - 1;
if(current_floor - 1 == request_floor)
state <= OPEN_DOOR;
end
//-------------------------------------------------
// OPEN DOOR
//-------------------------------------------------

OPEN_DOOR:
begin
motor_up <= 0;
motor_down <= 0;
door_open <= 1;
state <= IDLE;
end
endcase
end
end
endmodule