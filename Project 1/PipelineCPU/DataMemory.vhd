library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity DataMemory is
	port(WriteData:in std_logic_vector(31 downto 0);
			Address:in std_logic_vector(31 downto 0);
			MemRead,MemWrite,CLK:in std_logic;
			ReadData:out std_logic_vector(31 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type mem_type is array(0 to 255) of std_logic_vector(7 downto 0);
signal memFile: mem_type;
				   
begin

process(CLK)
variable check_begin:boolean := true;

begin

if(check_begin) then
	memFile(0)<="00000000";
	memFile(1)<="00000000"; 
	memFile(2)<="00000000"; 
	memFile(3)<="00000100"; 
	memFile(4)<="00000000";
	memFile(5)<="00000000"; 
	memFile(6)<="00000000"; 
	memFile(7)<="00000100";   
	
	check_begin := false;
end if;

if CLK = '1' and CLK'event then
	if (MemWrite = '1') and (MemRead = '0') then
		memFile(to_integer(unsigned(Address))) <= WriteData(31 downto 24);
		memFile(to_integer(unsigned(Address)) + 1) <= WriteData(23 downto 16);
		memFile(to_integer(unsigned(Address)) + 2) <= WriteData(15 downto 8);
		memFile(to_integer(unsigned(Address)) + 3) <= WriteData(7 downto 0);
	end if;
end if;

if CLK='0' and CLK'event then
	if (MemWrite = '0') and (MemRead = '1') then
		ReadData <= memFile(to_integer(unsigned(Address))) & memFile(to_integer(unsigned(Address)) + 1) & memFile(to_integer(unsigned(Address)) + 2) & memFile(to_integer(unsigned(Address)) + 3);
	end if;
end if;

end process;

end Behavioral;
