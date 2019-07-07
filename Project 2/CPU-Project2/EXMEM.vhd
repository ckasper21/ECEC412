library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity EXMEM is
port(clk: in std_logic;
	ALUResult,RR2:in std_logic_vector(31 downto 0);
	WR: in std_logic_vector(4 downto 0);
	zero:in std_logic;
	ALUResult_out,RR2_out:out std_logic_vector(31 downto 0);
	WR_out: out std_logic_vector(4 downto 0);
	zero_out: out std_logic;

	Branch, MemRead, MemtoReg, RegWrite, MemWrite:in std_logic;
	Branch_out,MemRead_out,MemtoReg_out,RegWrite_out,MemWrite_out:out std_logic);
end EXMEM;

architecture Behavioral of EXMEM is
signal ALUResult_sig,RR2_sig: std_logic_vector(31 downto 0);
signal WR_sig: std_logic_vector(4 downto 0);
signal zero_sig,Branch_sig, MemRead_sig, MemtoReg_sig, RegWrite_sig,MemWrite_sig: std_logic:='0';

begin
ALUResult_sig <= ALUResult;
RR2_sig <= RR2;
WR_sig <= WR;
zero_sig <= zero;
Branch_sig <= Branch;
MemRead_sig <= MemRead;
MemtoReg_sig <= MemtoReg;
RegWrite_sig <= RegWrite;
MemWrite_sig <= MemWrite;

process(clk)

begin

if clk='1' and clk'event then
	zero_out<=zero_sig;
	ALUResult_out<=ALUResult_sig;
	RR2_out<=RR2_sig;
	WR_out <= WR_sig;
	Branch_out <= Branch_sig;
	MemRead_out <= MemRead_sig;
	MemtoReg_out <= MemtoReg_sig;
	RegWrite_out <= RegWrite_sig;
	MemWrite_out <= MemWrite_sig;
end if;

end process;

end Behavioral;
