library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstMemory isport(Address:in std_logic_vector(31 downto 0);     ReadData:out std_logic_vector(31 downto 0));end InstMemory;

architecture Behavioral of InstMemory is

type mem_type is array(0 to 256) of std_logic_vector(7 downto 0);
signal memArray: mem_type;

begin
process(Address) 
variable check_begin:boolean:=true;
begin
if (check_begin) then
-- set up memory with converted assembly code.
-- Code 1
-- add $s3 $s4 $s5
memArray(0)<="00000010";
memArray(1)<="10010101";
memArray(2)<="10011000";
memArray(3)<="00100000";
-- lw $s0 0($dp)
memArray(4)<="10001111";
memArray(5)<="10110000";
memArray(6)<="00000000";
memArray(7)<="00000100";
-- lw $s1 4($dp)
memArray(8)<="10001111";
memArray(9)<="10110001";
memArray(10)<="00000000";
memArray(11)<="00000000";
-- sub $s7 $s4 $s6 
memArray(12)<="00000010";
memArray(13)<="10010110";
memArray(14)<="10111000";
memArray(15)<="00100010";
-- sw $s3 8($dp)
memArray(16)<="10101111";
memArray(17)<="10110011";
memArray(18)<="00000000";
memArray(19)<="00001000";

check_begin:=false;

end if;
ReadData<=memArray(to_integer(unsigned(Address))) & memArray(to_integer(unsigned(Address))+1) & memArray(to_integer(unsigned(Address))+2) & memArray(to_integer(unsigned(Address))+3);
end process;
end Behavioral;