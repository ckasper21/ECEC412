library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL;

entity ForwardingUnit is
  port(RR1,RR2,WR_EXMEM,WR_MEMWB:in std_logic_vector(4 downto 0);
       RegWriteEXMEM,RegWriteMEMWB:in std_logic;
       fwdA,fwdB:out std_logic_vector(1 downto 0);
	fwdC: out std_logic);
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

signal fwdA_sig,fwdB_sig: std_logic_vector(1 downto 0);
signal fwdC_sig: std_logic;

begin

fwdA <= fwdA_sig;
fwdB <= fwdB_sig;
fwdC <= fwdC_sig;

process(RR1,RR2,WR_EXMEM,WR_MEMWB)

begin

fwdA_sig <= "00";
fwdB_sig <= "00";
fwdC_sig <= '0';

-- Solves EX hazards
if RegWriteEXMEM = '1' and (WR_EXMEM /= "00000") and (WR_EXMEM = RR1) then
	fwdA_sig <= "10";
end if;

if RegWriteEXMEM = '1' and (WR_EXMEM /= "00000") and (WR_EXMEM = RR2) then
	fwdB_sig <= "10";
end if;

-- Solves MEM hazards
if RegWriteMEMWB = '1' and (WR_MEMWB /= "00000") and (WR_MEMWB = RR1) then
	fwdA_sig <= "01";
end if;

if RegWriteMEMWB = '1' and (WR_MEMWB /= "00000") and (WR_MEMWB = RR2) then
	fwdB_sig <= "01";
end if;

-- Add SW / LW SW hazards
if RegWriteMEMWB = '1' and (WR_MEMWB /= "00000") and (WR_EXMEM = WR_MEMWB) then
	fwdC_sig <= '1';
end if;

end process;

end Behavioral;