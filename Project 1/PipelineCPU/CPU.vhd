library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
port(clk:in std_logic; Overflow:out std_logic);
end CPU;

architecture structure of CPU is

-- Declaring each component

component PC is
port(clk:in std_logic;
AddressIn:in std_logic_vector(32-1 downto 0);
AddressOut:out std_logic_vector(32-1 downto 0));
end component;

component SignExtend is
port(x:in std_logic_vector(16-1 downto 0);
	y:out std_logic_vector(16*2-1 downto 0));
end component;

component ShiftLeft2 is
port(x:in std_logic_vector(32-1 downto 0);
	y:out std_logic_vector(32-1 downto 0));
end component;

component ShiftLeft2Jump is
port(x:in std_logic_vector(3 downto 0);
	y:in std_logic_vector(32-7 downto 0);
	z:out std_logic_vector(32-1 downto 0));
end component;

component mux5 is
port(x,y:in std_logic_vector (4 downto 0);
	sel:in std_logic;
	z:out std_logic_vector(4 downto 0));
end component;

component mux32 is
Port (x,y:in STD_LOGIC_VECTOR(31 downto 0);
	sel:in STD_LOGIC;
	z: out  STD_LOGIC_VECTOR(31 downto 0));
end component;

component And2 is
port (x,y: in std_logic;
	z:out std_logic);
end component;

component ALU32 is
generic(n:natural:=32);
port(a,b:in std_logic_vector(n-1 downto 0);
	Oper:in std_logic_vector(3 downto 0);
	Result:buffer std_logic_vector(n-1 downto 0);
	Zero,Overflow:buffer std_logic);
end component;

component registers is
  port(RR1,RR2,WR:in std_logic_vector(4 downto 0);
       WD:in std_logic_vector(31 downto 0);
       Clk,RegWrite:in std_logic;
       RD1,RD2:out std_logic_vector(31 downto 0));
end component;

component InstMemory is
port(Address:in std_logic_vector(31 downto 0);
	ReadData:out std_logic_vector(31 downto 0));
end component;

component DataMemory is
port(WriteData:in std_logic_vector(31 downto 0);
	Address:in std_logic_vector(31 downto 0);
	MemRead,MemWrite,CLK:in std_logic;
	ReadData:out std_logic_vector(31 downto 0));
end component;

component ALUControl is
port(ALUOp:in std_logic_vector(1 downto 0);
	Funct:in std_logic_vector(5 downto 0);
	Operation:out std_logic_vector(3 downto 0));
end component;

component Control is
port(Opcode:in std_logic_vector(5 downto 0);
	RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump:out std_logic;
	ALUOp:out std_logic_vector(1 downto 0));
end component;

-- MultiCycle components
component IFID is
port(clk: in std_logic;
	Inst,InstPC4:in std_logic_vector(31 downto 0);
	Inst_out,InstPC4_out:out std_logic_vector(31 downto 0));
end component;

component IDEX is
port(clk: in std_logic;
	InstPC4,RR1,RR2,SE:in std_logic_vector(31 downto 0);
	Inst2016,Inst1511: in std_logic_vector(4 downto 0);
	InstPC4_out,RR1_out,RR2_out,SE_out:out std_logic_vector(31 downto 0);
	Inst2016_out,Inst1511_out:out std_logic_vector(4 downto 0);

	RegDst, Branch, MemRead, MemtoReg,ALUSrc, RegWrite, MemWrite  : in std_logic;
	ALUOp: in std_logic_vector(1 downto 0);
	RegDst_out, Branch_out, MemRead_out, MemtoReg_out,ALUSrc_out, RegWrite_out, MemWrite_out  : out std_logic;
	ALUOp_out: out std_logic_vector(1 downto 0));
end component;

component EXMEM is
port(clk: in std_logic;
	ALUADD,ALUResult,RR2:in std_logic_vector(31 downto 0);
	WR: in std_logic_vector(4 downto 0);
	zero:in std_logic;
	ALUADD_out,ALUResult_out,RR2_out:out std_logic_vector(31 downto 0);
	WR_out: out std_logic_vector(4 downto 0);
	zero_out: out std_logic;

	Branch, MemRead, MemtoReg, RegWrite, MemWrite:in std_logic;
	Branch_out,MemRead_out,MemtoReg_out,RegWrite_out,MemWrite_out:out std_logic);
end component;

component MEMWB is
port(clk: in std_logic;
	RD,ALUResult:in std_logic_vector(31 downto 0);
	WR: in std_logic_vector(4 downto 0);
	RD_out,ALUResult_out:out std_logic_vector(31 downto 0);
	WR_out: out std_logic_vector(4 downto 0);

	MemtoReg,RegWrite: in std_logic;
	MemtoReg_out,RegWrite_out: out std_logic);
end component;

--Declare Signals based on Single Cycle CPU
signal instruction,A,C,D,E,F,G,H,J,K,L,M,N,P,Q:std_logic_vector(31 downto 0);

-- MultiCycle Signals
signal instruction2,CC,DD,DDD,EE,GG,GGG,HH,LL,LLL,MM:std_logic_vector(31 downto 0);
signal inst2016,inst1511,BB,BBB:std_logic_vector(4 downto 0);
signal zero2:std_logic:='0';

signal B:std_logic_vector(4 downto 0);
signal R:std_logic:='0';
signal RegDst,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Zero:std_logic:='0';
signal Jump:std_logic;
signal Branch: std_logic:= '0';
signal ALUOp:std_logic_vector(1 downto 0);
signal operation: std_logic_vector(3 downto 0);
signal four:std_logic_vector(31 downto 0):="00000000000000000000000000000100";

-- MultiCycle Control Signals
signal RegDst2,Branch2,MemRead2,MemtoReg2,MemWrite2,ALUSrc2,RegWrite2:std_logic:='0';
signal ALUOp2:std_logic_vector(1 downto 0);
signal MemRead3,MemtoReg3,RegWrite3,MemWrite3:std_logic:='0';
signal Branch3:std_logic:='0';
signal MemtoReg4,RegWrite4:std_logic;
begin


--Start 
PC1:PC port map(clk=>clk,AddressIn=>P,AddressOut=>A);
InstMem: InstMemory port map(Address=>A,ReadData=>instruction);
Add4: ALU32 port map(a=>A,b=>four,Oper=>"0010",Result=>L,Zero=>open,Overflow=>open);
Control1: Control port map(Opcode=>instruction2(31 downto 26),RegDst=>RegDst,Branch=>Branch,MemRead=>MemRead,MemtoReg=>MemtoReg,MemWrite=>MemWrite,ALUSrc=>ALUSrc,RegWrite=>RegWrite,Jump=>Jump,ALUOp=>ALUOp);
Mux1:mux5 port map(x=>inst2016,y=>inst1511,sel=>RegDst2,z=>B);
Register1:registers port map(RR1=>instruction2(25 downto 21),RR2=>instruction2(20 downto 16),WR=>BBB,WD=>J,RegWrite=>RegWrite4,Clk=>clk,RD1=>C,RD2=>D);
SignExtend1:SignExtend port map(instruction2(15 downto 0),E);
Mux2:mux32 port map(DD,EE,ALUSrc2,F);
ALUControl1:ALUControl port map(ALUOp2,EE(5 downto 0),operation);
ALU1:ALU32 port map(CC,F,operation,G,Zero,open);
Shift1:ShiftLeft2 port map(EE,K);
AddALU:ALU32 port map(LLL,K,"0010",M,open,open);
ShiftJump:ShiftLeft2Jump port map(L(31 downto 28),instruction(25 downto 0),Q);
And1:And2 port map(Branch3,Zero2,R);
Mux3:mux32 port map(L,MM,R,N);
DMemory:DataMemory port map(DDD,GG,MemRead3,MemWrite3,clk,H);
Mux4:mux32 port map(GGG,HH,MemtoReg4,J);
Mux_5:mux32 port map(N,Q,R,P);
IFID1:IFID port map(clk,Instruction,L,instruction2,LL);
IDEX1:IDEX port map(clk,LL,C,D,E,instruction2(20 downto 16),instruction2(15 downto 11),LLL,CC,DD,EE,inst2016,inst1511,RegDst,Branch,MemRead,MemtoReg,ALUSrc,RegWrite,MemWrite,ALUOp,RegDst2,Branch2,MemRead2,MemtoReg2,ALUSrc2,RegWrite2,MemWrite2,ALUOp2);
EXMEM1:EXMEM port map(clk,M,G,DD,B,Zero,MM,GG,DDD,BB,Zero2,Branch2,MemRead2,MemtoReg2,RegWrite2,MemWrite2,Branch3,MemRead3,MemtoReg3,RegWrite3,MemWrite3);
MEMWB1:MEMWB port map(clk,H,GG,BB,HH,GGG,BBB,MemtoReg3,RegWrite3,MemtoReg4,RegWrite4);
end structure;