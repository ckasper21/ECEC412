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
-- set up memory with converted assembly code
--Code 1 & 2 (Change registers!): ### WITH NOPS - Pass
-- beq t1 t2 L
memArray(0)<="00010001";
memArray(1)<="00101010";
memArray(2)<="00000000";
memArray(3)<="00000011";
-- add t3 s4 s5
memArray(4)<="00000010";
memArray(5)<="10010101";
memArray(6)<="01011000";
memArray(7)<="00100000";
-- j exit
memArray(8)<="00001000";
memArray(9)<="00000000";
memArray(10)<="00000000";
memArray(11)<="00000101";
-- NOPS
memArray(12)<="UUUUUUUU";
memArray(13)<="UUUUUUUU";
memArray(14)<="UUUUUUUU";
memArray(15)<="UUUUUUUU";
-- L: sub t4 s4 s5
memArray(16)<="00000010";
memArray(17)<="10010101";
memArray(18)<="01100000";
memArray(19)<="00100010";
-- exit: add t5 s4 s4
memArray(20)<="00000010";
memArray(21)<="10010100";
memArray(22)<="01101000";
memArray(23)<="00100000";

check_begin:=false;

end if;
ReadData<=memArray(to_integer(unsigned(Address))) & memArray(to_integer(unsigned(Address))+1) & memArray(to_integer(unsigned(Address))+2) & memArray(to_integer(unsigned(Address))+3);
end process;
end Behavioral;