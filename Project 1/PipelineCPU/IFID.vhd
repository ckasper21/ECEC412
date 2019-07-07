library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity IFID is
port(clk: in std_logic;
	Inst,InstPC4:in std_logic_vector(31 downto 0);
	Inst_out,InstPC4_out:out std_logic_vector(31 downto 0));
end IFID;

architecture Behavioral of IFID is
signal Inst_sig,InstPC4_sig: std_logic_vector(31 downto 0);
begin
Inst_sig <= Inst;
InstPC4_sig <= InstPC4;
process(clk)

begin

if clk='1' and clk'event then
	Inst_out <= Inst_sig;
	InstPC4_out <= InstPC4_sig;
end if;

end process;

end Behavioral;
