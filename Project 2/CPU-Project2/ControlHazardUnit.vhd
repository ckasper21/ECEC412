library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity ControlHazardUnit is
  port(OPCode: in std_logic_vector(5 downto 0);
	isEqual: in std_logic;
       ControlSel:out std_logic;
	PCWrite,IFID_Flush_en: out std_logic);
end ControlHazardUnit;

architecture Behavioral of ControlHazardUnit is

begin

process(OPCode,isEqual)

begin

if OPCode = "000100" then -- beq
	if isEqual = '1' then
		ControlSel <= '1';
		PCWrite <= '0'; --?
		IFID_Flush_en <= '1';
	else
		ControlSel<= '1';
		PCWrite <= '0';
		IFID_Flush_en <= '0';
	end if;

elsif OPCode = "000101" then -- bne
	if isEqual = '0' then
		ControlSel <= '1';
		PCWrite <= '0'; --?
		IFID_Flush_en <= '1';
	end if;
else
	ControlSel <= '0';
	IFID_Flush_en <='0';
	PCWrite <= '1';--?
end if;

end process;

end Behavioral;
