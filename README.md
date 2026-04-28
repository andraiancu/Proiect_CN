# Proiect_CN
# 8-bit ALU Project Documentation

## Project Overview

This project implements an 8-bit Arithmetic Logic Unit (ALU) using structural Verilog HDL. The ALU supports four arithmetic operations:

* Addition
* Subtraction
* Multiplication
* Division

The multiplication algorithm used is **Booth Radix-2**, and the division algorithm used is **Restoring Division**.

The design follows a structural approach, using separate hardware modules for arithmetic operations, control logic, multiplexing, and registers.

---

## Objectives

The main objectives of the project were:

* Design a functional 8-bit ALU
* Implement arithmetic operations structurally in Verilog
* Create a Control Unit for operation selection
* Verify correctness using simulation and testbenches
* Respect the laboratory project requirements

---

## Architecture

The ALU is composed of the following modules:

### 1. Arithmetic Unit

Contains:

* Adder/Subtractor (9-bit with sign extension)
* Booth Radix-2 Multiplier
* Restoring Divider

### 2. Control Unit

Responsible for:

* decoding `op_select`
* generating `mult_start`
* generating `div_start`
* managing `done` signals

### 3. Multiplexer

A 4-to-1 16-bit multiplexer selects the final output:

* `00` → Addition
* `01` → Subtraction
* `10` → Multiplication
* `11` → Division

### 4. Registers

Used for internal accumulator values:

* A register
* Q register
* M register
* control signals

---

## Operation Selection

| op_select | Operation      |
| --------- | -------------- |
| 00        | Addition       |
| 01        | Subtraction    |
| 10        | Multiplication |
| 11        | Division       |

---

## Addition and Subtraction

Addition and subtraction are implemented using the same module:

`adder_sub_9bit`

Features:

* sign extension
* 2's complement subtraction
* ripple carry full adders

For subtraction:

* `mode = 1`
* B is complemented
* carry-in = 1

This produces:

A - B = A + (~B + 1)

---

## Multiplication

### Algorithm Used: Booth Radix-2

Registers used:

* A → accumulator
* Q → multiplier
* M → multiplicand
* Q(-1) → previous bit

Logic:

* `01` → Add M
* `10` → Subtract M
* `00 / 11` → No operation

After each step:

* arithmetic right shift is performed

After 8 iterations:

Final product:

`{A, Q}`

---

## Division

### Algorithm Used: Restoring Division

Registers used:

* A → partial remainder
* Q → dividend / quotient
* M → divisor

Algorithm:

1. Shift left `[A,Q]`
2. Compute `A - M`
3. If negative:

   * restore A
   * set Q[0] = 0
4. Else:

   * keep subtraction result
   * set Q[0] = 1

After 8 iterations:

* Q = quotient
* A = remainder

---

## Testbench

The testbench verifies all four operations.

### Test Cases

### Addition

25 + 10 = 35

### Subtraction

25 - 10 = 15

### Multiplication

7 × 3 = 21

### Division

20 / 4 = 5
remainder = 0

---

## Simulation Results

Simulation output:

* Addition → correct
* Subtraction → correct
* Multiplication → correct
* Division → correct

Final division result:

Quotient = 5
Remainder = 0

This confirms correct functionality of the complete ALU.

---

## Conclusion

The project successfully implements a complete structural 8-bit ALU in Verilog.

The final system supports:

* addition
* subtraction
* multiplication
* division

using:

* Booth Radix-2 multiplication
* Restoring division

All operations were tested successfully and the architecture matches the required structural design constraints.

The project is ready for final submission and presentation.

The project successfully implements a complete structural 8-bit ALU in Verilog.

The final system supports:

* addition
* subtraction
* multiplication
* division

using:

* Booth Radix-2 multiplication
* Restoring division

All operations were tested successfully and the architecture matches the required structural design constraints.

The project is ready for final submission and presentation.
