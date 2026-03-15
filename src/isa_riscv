library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

package	isa_riscv is

	constant opcode_ADD : std_logic_vector(3 downto 0) := "0000";
	constant opcode_SUB : std_logic_vector(3 downto 0) := "1000";
	constant opcode_SLL : std_logic_vector(3 downto 0) := "0001";
	constant opcode_SLT : std_logic_vector(3 downto 0) := "0010";
	constant opcode_SLTU: std_logic_vector(3 downto 0) := "0011";
	constant opcode_XOR : std_logic_vector(3 downto 0) := "0100";
	constant opcode_SRL : std_logic_vector(3 downto 0) := "0101";
	constant opcode_SRA : std_logic_vector(3 downto 0) := "1101";
	constant opcode_OR  : std_logic_vector(3 downto 0) := "0110";
	constant opcode_AND : std_logic_vector(3 downto 0) := "0111";

	constant func_JALR : std_logic_vector(2 downto 0) := "000";
	constant func_BEQ : std_logic_vector(2 downto 0) := "000";
	constant func_BNE : std_logic_vector(2 downto 0) := "001";
	constant func_BLT : std_logic_vector(2 downto 0) := "100";
	constant func_BGE : std_logic_vector(2 downto 0) := "101";
	constant func_BLTU : std_logic_vector(2 downto 0) := "110";
	constant func_BGEU : std_logic_vector(2 downto 0) := "111";
	constant func_LB : std_logic_vector(2 downto 0) := "000";
	constant func_LH : std_logic_vector(2 downto 0) := "001";
	constant func_LW : std_logic_vector(2 downto 0) := "010";
	constant func_LBU : std_logic_vector(2 downto 0) := "100";
	constant func_LHU : std_logic_vector(2 downto 0) := "101";
	constant func_SB : std_logic_vector(2 downto 0) := "000";
	constant func_SH : std_logic_vector(2 downto 0) := "001";
	constant func_SW : std_logic_vector(2 downto 0) := "010";

	constant op_IMM : std_logic_vector(6 downto 0) := "0010011";
	constant op_LUI : std_logic_vector(6 downto 0) := "0110111";
	constant op_AUIPC : std_logic_vector(6 downto 0) := "0010111";
	constant op_OP : std_logic_vector(6 downto 0) := "0110011";
	constant op_JAL : std_logic_vector(6 downto 0) := "1101111";
	constant op_JALR : std_logic_vector(6 downto 0) := "1100111";
	constant op_BRANCH : std_logic_vector(6 downto 0) := "1100011";
	constant op_LOAD : std_logic_vector(6 downto 0) := "0000011";
	constant op_STORE : std_logic_vector(6 downto 0) := "0100011";

end isa_riscv;

package body isa_riscv is 

end isa_riscv;
