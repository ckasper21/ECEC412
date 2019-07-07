library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity Control is
port(Opcode: in std_logic_vector(5 downto 0);
ControlSigs: out std_logic_vector(9 downto 0));
end control;

architecture behav of Control is

begin

process(Opcode)

begin

case Opcode is
	when "000000" =>		--R-Format
		ControlSigs(9) <= '1';
		ControlSigs(8) <= '0';
		ControlSigs(7) <= '0';
		ControlSigs(6) <= '1';
		ControlSigs(5) <= '0';
		ControlSigs(4) <= '0';
		ControlSigs(3) <= '0';
		ControlSigs(2) <= '0';
		ControlSigs(1 downto 0) <= "10";
	when "100011" =>		--lw
	 	ControlSigs(9) <= '0';
		ControlSigs(8) <= '1';
		ControlSigs(7) <= '1';
		ControlSigs(6) <= '1';
		ControlSigs(5) <= '1';
		ControlSigs(4) <= '0';
		ControlSigs(3) <= '0';
		ControlSigs(2) <= '0';
		ControlSigs(1 downto 0) <= "00";
	when "101011" =>		--sw
		ControlSigs(9) <= '-';
		ControlSigs(8) <= '1';
		ControlSigs(7) <= '-';
		ControlSigs(6) <= '0';
		ControlSigs(5) <= '0';
		ControlSigs(4) <= '1';
		ControlSigs(3) <= '0';
		ControlSigs(2) <= '0';
		ControlSigs(1 downto 0) <= "00";
	when "000100" =>		--beq
		ControlSigs(9) <= '-';
		ControlSigs(8) <= '0';
		ControlSigs(7) <= '-';
		ControlSigs(6) <= '0';
		ControlSigs(5) <= '0';
		ControlSigs(4) <= '0';
		ControlSigs(3) <= '1';
		ControlSigs(2) <= '0';
		ControlSigs(1 downto 0) <= "01";
	when "000010" =>		--jump
		ControlSigs(9) <= '-';
		ControlSigs(8) <= '-';
		ControlSigs(7) <= '-';
		ControlSigs(6) <= '0';
		ControlSigs(5) <= '0';
		ControlSigs(4) <= '0';
		ControlSigs(3) <= '0';
		ControlSigs(2) <= '1';
		ControlSigs(1 downto 0) <= "--";
	when others =>
		ControlSigs <= "0000000000";
end case;
end process;
end behav;
