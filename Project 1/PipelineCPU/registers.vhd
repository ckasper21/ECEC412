library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity registers is
  port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD:in std_logic_vector(31 downto 0);
       CLK,RegWrite:in std_logic;
       RD1,RD2:out std_logic_vector(31 downto 0));
end registers;

architecture Behavioral of registers is

type regFile_Type is array(0 to 31) of std_logic_vector(31 downto 0);
signal regFile: regFile_Type;

begin

process(CLK,RegWrite,WR)
variable check_begin:boolean := true;

begin

if(check_begin) then
	regFile(0) <= "00000000000000000000000000000000";
	regFile(8) <= "00000000000000000000000000000000";
	regFile(9) <= "00000000000000000000000000000100";
	regFile(10) <= "00000000000000000000000000000100";
	regFile(20) <= "00000000000000000000000000001110";
	regFile(21) <= "00000000000000000000000000000101";
	regFile(22) <= "00000000000000000000000000001000";
	regFile(23) <= "00000000000000000000000000000011";
	regFile(29) <= "00000000000000000000000000000000"; -- DataPointer ($dp)
	check_begin := false;
end if;

if CLK = '1' then
	if RegWrite = '1' then
		regFile(to_integer(unsigned(WR)))<= WD;
	end if;
end if;

if CLK = '0' then
	RD1 <= regFile(to_integer(unsigned(RR1)));
	RD2 <= regFile(to_integer(unsigned(RR2)));
end if;

end process;

end Behavioral;