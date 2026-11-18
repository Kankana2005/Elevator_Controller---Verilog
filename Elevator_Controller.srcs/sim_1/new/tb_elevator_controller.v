`timescale 1ns / 1ps

module tb_elevator_controller;

//-----------------------------------------------------
// Inputs
//-----------------------------------------------------

reg clk;
reg reset;

reg [2:0] request_floor;

//-----------------------------------------------------
// Outputs
//-----------------------------------------------------

wire [2:0] current_floor;
wire motor_up;
wire motor_down;
wire door_open;

//-----------------------------------------------------
// Instantiate DUT
//-----------------------------------------------------

elevator_controller
DUT(clk,reset,request_floor,current_floor,motor_up,motor_down,door_open);

//-----------------------------------------------------
// Clock Generation (10 ns Period)
//-----------------------------------------------------

always #5 clk = ~clk;

//-----------------------------------------------------
// Test Sequence

//-----------------------------------------------------

initial
begin

clk = 0;
reset = 1;
request_floor = 2'd0;

// Apply Reset
#20;
reset = 0;

//-------------------------------------------------
// Move to Floor 3
//-------------------------------------------------

#20;
request_floor = 2'd3;

#60;

//-------------------------------------------------
// Move to Floor 1
//-------------------------------------------------

request_floor = 2'd1;

#50;

//-------------------------------------------------
// Move to Floor 0
//-------------------------------------------------

request_floor = 2'd0;

#40;

request_floor = 3'd4;
#100;

//-------------------------------------------------
// Finish Simulation
//-------------------------------------------------

#20;
$finish;

end

//-----------------------------------------------------
// Monitor

//-----------------------------------------------------

initial
begin
$monitor("Time=%0t | Req=%0d | Current=%0d | UP=%b | DOWN=%b | DOOR=%b",
$time,
request_floor,
current_floor,
motor_up,
motor_down,
door_open);
end

endmodule