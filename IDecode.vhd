----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2022 06:01:49 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
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
end IDecode;

architecture Behavioral of IDecode is
   signal wa,ra1,ra2: STD_LOGIC_VECTOR(2 downto 0);
   --signal rd1,rd2: STD_LOGIC_VECTOR(15 downto 0);
   type MEM is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
   signal reg_file: MEM :=(x"0000",
                           x"0003",
                           x"0000",
                           x"0000",
                           x"0000",
                           x"0000",
                           x"0002",
                           x"0001");
begin
func <= Instr(2 downto 0);
sa <= Instr(3);
ra1 <= Instr(12 downto 10);
ra2 <= Instr(9 downto 7);
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));
wa <= WriteAdd;
--process(RegDst,Instr(9 downto 7),Instr(6 downto 4))
--begin
--    case RegDst is
--        when '0' => wa <=  Instr(9 downto 7);
--        when '1' => wa <=  Instr(6 downto 4);
--    end case;
--end process;
-- falling_edge scriere rezolva hazard structural , 2 noop 
-- cu falling_edge scriere si citire in acelasi clock

process(clk,RegWrite,WD,wa)
begin
    if falling_edge(clk) then
        if RegWrite = '1' then
                reg_file(conv_integer(wa)) <= WD;
        end if;
    end if;
end process;

process(ExtOp,Instr(6 downto 0))
begin
    case ExtOp is
        when '0' => Ext_Imm <= "000000000" & Instr(6 downto 0);
        when '1' => 
            case Instr(6) is
                when '1' => Ext_Imm <= "111111111" & Instr(6 downto 0);
                when '0' => Ext_Imm <= "000000000" & Instr(6 downto 0);
            end case;
    end case;
end process;

end Behavioral;
