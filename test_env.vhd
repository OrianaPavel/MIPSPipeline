----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2022 10:37:44 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture Behavioral of test_env is

component MPG
    Port (clk : in STD_LOGIC;
          button : in STD_LOGIC;
          enable: out STD_LOGIC
         );
end component;

component SSD 
    Port (clk : in STD_LOGIC;
         Digits: in STD_LOGIC_VECTOR(15 downto 0);
         CAT : out STD_LOGIC_VECTOR(6 downto 0);
         AN : out STD_LOGIC_VECTOR(3 downto 0) );
end component;
component IFetch
    Port (en: in STD_LOGIC;
        clk: in STD_LOGIC;
        rst : in STD_LOGIC;
        BrAdd : in STD_LOGIC_VECTOR(15 downto 0);
        Jadd: in STD_LOGIC_VECTOR(15 downto 0);
        PCSrc: in STD_LOGIC;
         Jump : in STD_LOGIC;
        Intr: out STD_LOGIC_VECTOR(15 downto 0);
         PCPlus: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component UC
Port (Opcode: in STD_LOGIC_VECTOR(2 downto 0);
        RegDst:out STD_LOGIC;
        ExtOp:out STD_LOGIC;
        AluSrc:out STD_LOGIC;
        Branch:out STD_LOGIC;
        Jump:out STD_LOGIC;
        MemWrite:out STD_LOGIC;
        MemToReg:out STD_LOGIC;
        RegWrite:out STD_LOGIC;
        AluOp: out STD_LOGIC_VECTOR(1 downto 0));
end component;
component IDecode
     Port(clk:in STD_LOGIC;
     WriteAdd: in STD_LOGIC_VECTOR(2 downto 0);
    RegWrite:in STD_LOGIC;
    ExtOp:in STD_LOGIC;
    RegDst: in STD_LOGIC;
    Instr:in STD_LOGIC_VECTOR(15 downto 0);
    WD: in STD_LOGIC_VECTOR(15 downto 0);
    RD1:out STD_LOGIC_VECTOR(15 downto 0);
    RD2:out STD_LOGIC_VECTOR(15 downto 0);
    Ext_Imm: out STD_LOGIC_VECTOR(15 downto 0);
    func:out STD_LOGIC_VECTOR(2 downto 0);
    sa:out STD_LOGIC  
    );
end component;
component ALU is
   Port (clk: in STD_LOGIC;
         sa: in STD_LOGIC;
         AluSrc : in STD_LOGIC;
         RD1: in STD_LOGIC_VECTOR(15 downto 0);
         RD2: in STD_LOGIC_VECTOR(15 downto 0);
         Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
         AluRes: out STD_LOGIC_VECTOR(15 downto 0);
         zero: out STD_LOGIC;
         func: in STD_LOGIC_VECTOR(2 downto 0);
         AluOP: in STD_LOGIC_VECTOR(1 downto 0)
         );
end component;
component MemRam is
  Port (MemWrite: in STD_LOGIC;
        clk: in STD_LOGIC;
        Adr:in STD_LOGIC_VECTOR(15 downto 0);
        WriteData: in STD_LOGIC_VECTOR(15 downto 0);
        ReadData: out STD_LOGIC_VECTOR(15 downto 0));
end component;


signal func:STD_LOGIC_VECTOR(2 downto 0):= (others=>'0');
signal AluOp: STD_LOGIC_VECTOR(1 downto 0):= (others=>'0');
signal sa: STD_LOGIC:= '0';
signal RD1,RD2,Ext_Imm,MuxMemToReg,ReadData: STD_LOGIC_VECTOR(15 downto 0)  := (others=>'0');
signal RegDst,ExtOp,AluSrc,Branch,Jump,MemWrite,MemWriteEn,MemToReg,RegWrite,EnWriteEn: STD_LOGIC := '0';
signal count, Instr, PcPlus,AluRes,Jadd,BrAdd : std_logic_vector(15 downto 0) := (others=>'0');
signal en,rst,zero,PcSrc,enWriteMem : STD_LOGIC := '0';
signal RegWriteEn : STD_LOGIC := '0';
signal wa: STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');

signal REG_IF_ID: STD_LOGIC_VECTOR(31 downto 0)  := (others=>'0');
signal REG_ID_EX: STD_LOGIC_VECTOR(77 downto 0)  := (others=>'0');
signal REG_EX_MEM: STD_LOGIC_VECTOR(55 downto 0) := (others=>'0');
signal REG_MEM_WB: STD_LOGIC_VECTOR(36 downto 0) := (others=>'0');

begin
ssd1 : SSD port map(clk => clk, Digits => count,CAT => cat, AN => an );
mpg1 : MPG port map(clk => clk, button => btn(0), enable => en );
mpg2 : MPG port map(clk => clk, button => btn(1), enable => rst );
mpg3 : MPG port map(clk => clk, button => btn(2), enable => enWriteMem); 


ifetch1 : IFetch port map( en => en,clk => clk,rst => rst  , BrAdd => BrAdd, Jadd => Jadd, PCSrc => PcSrc, Jump => Jump,Intr => Instr, PCPlus => PcPlus );
uc1 : UC port map(Opcode => REG_IF_ID(15 downto 13),RegDst => RegDst,ExtOp => ExtOp,AluSrc => AluSrc,Branch => Branch,Jump => Jump,MemWrite => MemWrite,MemToReg => MemToReg,RegWrite => RegWrite,AluOp => AluOp);
idecode1 : IDecode port map(clk => clk,WriteAdd=> REG_MEM_WB(2 downto 0),RegWrite => RegWriteEn,ExtOp => ExtOp,RegDst => RegDst,Instr => REG_IF_ID(15 downto 0),WD => MuxMemToReg,RD1 => RD1, RD2 => RD2,Ext_Imm => Ext_Imm,func => func, sa => sa );
alu1 : ALU port map(clk => clk,sa => REG_ID_EX(77),AluSrc => REG_ID_EX(70),RD1 => REG_ID_EX(53 downto 38), RD2 => REG_ID_EX(37 downto 22),Ext_Imm =>REG_ID_EX(21 downto 6),AluRes =>AluRes,zero=>zero,func=>REG_ID_EX(5 downto 3),AluOp=>REG_ID_EX(72 downto 71));
memRam1 : MemRam port map(MemWrite => REG_EX_MEM(52),clk=>clk,Adr => REG_EX_MEM(34 downto 19),WriteData => REG_EX_MEM(18 downto 3),ReadData =>ReadData);

RegWriteEn <= REG_MEM_WB(35) and en;
MemWriteEn <= MemWrite;
PcSrc <= Branch and REG_EX_MEM(55);
BrAdd <= Ext_Imm + REG_ID_EX(69 downto 54);
Jadd <= "000" & REG_IF_ID(12 downto 0);
MuxMemToReg <= REG_MEM_WB(34 downto 19) when REG_MEM_WB(36) = '1' else REG_MEM_WB(18 downto 3);

process(RegDst,REG_IF_ID(9 downto 7),REG_IF_ID(6 downto 4))
begin
    case RegDst is
        when '0' => wa <=  REG_IF_ID(9 downto 7);
        when '1' => wa <=  REG_IF_ID(6 downto 4);
    end case;
end process;

--led(15 downto 0) <= rd1;
led(15 downto 0) <="000000"& RegDst & ExtOp & AluSrc & Branch & Jump & AluOp & MemWrite & MemToReg & RegWrite;
process(sw(7 downto 5),Instr,PcPlus,RD1,RD2,MuxMemToReg,Ext_Imm)
begin
    case sw(7 downto 5) is
        when "000" => count <= Instr;
        when "001" => count <= PcPlus;
        when "010" => count <= RD1;
        when "011" => count <= ReadData;
        when "100" => count <= MuxMemToReg;
        when "101" => count <= rd2;
        when "110" => count <= AluRes;
        when "111" => count <= Ext_Imm;
    end case;
end process;


process(clk,PcPlus,Instr)
begin
    if rising_edge(clk) then
        REG_IF_ID <= PcPlus & Instr; 
    end if;
end process;

process(clk,MemToReg,RegWrite,MemWrite,Branch,AluOP,AluSrc,REG_IF_ID(31 downto 16),RD1,RD2,Ext_Imm,func,MuxMemToReg)
begin
    if rising_edge(clk) then
        REG_ID_EX <= sa & MemToReg & RegWrite & MemWrite & Branch & AluOP & AluSrc & REG_IF_ID(31 downto 16) & RD1 & RD2 & Ext_Imm & func & wa;
    end if;
end process;

process(clk,REG_ID_EX(77),REG_ID_EX( 76 downto 73),BrAdd, AluRes,REG_ID_EX(37 downto 22),REG_ID_EX(2 downto 0))
begin
    if rising_edge(clk) then
        REG_EX_MEM <= REG_ID_EX(77) & REG_ID_EX( 76 downto 73) & BrAdd & AluRes & REG_ID_EX(37 downto 22) & REG_ID_EX(2 downto 0);
    end if;
end process;

process(clk,REG_EX_MEM(54 downto 53),ReadData,REG_EX_MEM(34 downto 19),REG_EX_MEM(2 downto 0))
begin   
    if rising_edge(clk) then
        REG_MEM_WB <= REG_EX_MEM(54 downto 53) & ReadData & REG_EX_MEM(34 downto 19) & REG_EX_MEM(2 downto 0);
    end if;
end process;
end Behavioral;
