# Elevator_Controller---Verilog

A Verilog HDL implementation of a single-elevator controller, designed and simulated in Xilinx Vivado. The design is a finite state machine (FSM) that moves an elevator car toward a requested floor, driving motor and door-control outputs along the way.

## Overview

The controller tracks the elevator's current floor and compares it against a requested floor on every clock edge. Based on the comparison, it transitions through states to drive the motor up or down one floor at a time, then opens the door once the requested floor is reached.

## Features

- Synchronous FSM with **4 states**: `IDLE`, `MOVE_UP`, `MOVE_DOWN`, `OPEN_DOOR`
- 3-bit floor request input and 3-bit current-floor output
- Independent `motor_up` / `motor_down` control signals (never asserted simultaneously)
- `door_open` signal asserted only once the destination floor is reached
- Active-high synchronous reset returning the car to floor 0 in `IDLE`
- Self-checking testbench with clock generation and `$monitor`-based signal tracing

## Tools & Technologies

- **HDL:** Verilog
- **Design/Simulation Tool:** Xilinx Vivado (Project Mode)
- **Simulator:** Vivado Simulator (XSim)

## Project Structure

```
Elevator-Controller-Verilog/
├── Elevator_Controller.xpr                                   # Vivado project file
├── Elevator_Controller.srcs/
│   ├── sources_1/new/
│   │   └── Elevator_controller.v                             # RTL: elevator_controller module
│   └── sim_1/new/
│       └── tb_elevator_controller.v                          # Testbench: tb_elevator_controller
├── docs/
│   ├── RTL_schematic.png                                     # RTL schematic view
│   ├── Elaborated_design.png                                 # Elaborated design view
│   ├── Synthesized_design.png                                # Post-synthesis design view
│   └── VLSI_Capstone_Project_Elevator_Controller.pdf          # Project write-up
├── .gitignore
└── README.md
```

> Note: Vivado-generated directories (`.cache`, `.runs`, `.sim`, `.ip_user_files`, `.hw`) are excluded from version control via `.gitignore`. Vivado regenerates them automatically when the project is opened or built.

## Module Description

### `elevator_controller` (`Elevator_controller.v`)

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 | System clock |
| `reset` | input | 1 | Synchronous, active-high reset |
| `request_floor` | input | 3 | Requested destination floor |
| `current_floor` | output reg | 3 | Elevator's current floor |
| `motor_up` | output reg | 1 | Drives motor to move the car up |
| `motor_down` | output reg | 1 | Drives motor to move the car down |
| `door_open` | output reg | 1 | Indicates the door is open |

**State machine:**

- `IDLE` — Motor and door outputs are deasserted. Compares `request_floor` to `current_floor`; moves to `MOVE_UP` or `MOVE_DOWN` if they differ, otherwise stays idle.
- `MOVE_UP` — Asserts `motor_up`, increments `current_floor` by one each clock cycle, and transitions to `OPEN_DOOR` once the requested floor is reached.
- `MOVE_DOWN` — Asserts `motor_down`, decrements `current_floor` by one each clock cycle, and transitions to `OPEN_DOOR` once the requested floor is reached.
- `OPEN_DOOR` — Asserts `door_open` for one cycle, then returns to `IDLE`.

### `tb_elevator_controller` (`tb_elevator_controller.v`)

Instantiates `elevator_controller` as the DUT, generates a 10 ns-period clock, applies a reset, and then drives a sequence of floor requests (including an out-of-range request) while a `$monitor` statement logs `current_floor`, `motor_up`, `motor_down`, and `door_open` over time.

## How to Open and Simulate in Vivado

1. Launch **Xilinx Vivado**.
2. **Open Project** → select `Elevator_Controller.xpr` from this repository.
3. Vivado will regenerate the `.runs`, `.sim`, and `.cache` directories as needed — this is expected.
4. In the **Sources** pane, confirm `tb_elevator_controller` is set as the simulation top module (under `sim_1`).
5. Run **Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation**.
6. Observe `current_floor`, `motor_up`, `motor_down`, and `door_open` in the waveform viewer, and check the Tcl console for the `$monitor` output.

## Future Improvements

- Add an `.xdc` constraints file to target a specific FPGA board for on-hardware testing.
- Parameterize the number of floors instead of relying on the current 3-bit encoding.
- Add door-open timing (hold for N cycles) instead of a single-cycle pulse.
- Add input validation/queuing for multiple or out-of-range floor requests.
- Expand the testbench with assertions for automated pass/fail checking instead of manual waveform inspection.
