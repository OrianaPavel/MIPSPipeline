----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2022 10:56:30 AM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
  Port (en: in STD_LOGIC;
        clk: in STD_LOGIC;
        rst : in STD_LOGIC;
        BrAdd : in STD_LOGIC_VECTOR(15 downto 0);
        Jadd: in STD_LOGIC_VECTOR(15 downto 0);
        PCSrc: in STD_LOGIC;
         Jump : in STD_LOGIC;
        Intr: out STD_LOGIC_VECTOR(15 downto 0);
         PCPlus: out STD_LOGIC_VECTOR(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal data,PC,newPC,PcSrcMux,sPCPlus: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0') ;

type MEM is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal rom: MEM :=(
                    B"000_010_010_010_0_110",
                    B"000_011_011_011_0_110",
                    B"000_100_100_100_0_110",
                    B"000_000_010_010_0_010", -- NoOp
                    B"100_001_011_0000101",
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_110_100_100_0_000",
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_000_010_010_0_010", -- NoOp
                    --B"001_010_010_0000010",
                    B"010_100_101_0000000",
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_000_010_010_0_010", -- NoOp
                    B"000_010_101_010_0_000",
                    B"000_111_011_011_0_000",
                    B"000_000_010_010_0_010", -- NoOp
                    B"111_0000000000011",
                    B"011_000_010_000000",
                   others=>"0000000000000000");

begin
Intr <= data;
data <= rom(conv_integer(PC(7 downto 0)));
PcPlus <= sPCPlus;
sPCPlus <= PC + 1;
process(clk,rst,newPC,en)
begin
    if rst = '1' then
        PC <= x"0000"; 
    else
        if rising_edge(clk) then
            if en = '1' then
                PC <= newPC;
            end if;
        end if;
    end if;
end process;
--process(sPcPlus,BrAdd,PcSrc)
--begin
--     case PcSrc is
--         when '0' => PcSrcMux <= sPcPlus;
--         when '1' => PcSrcMux <= BrAdd;
--     end case;
--end process;
PcSrcMux <= sPcPlus when PcSrc = '0' else Bradd;
--process(newPC,PcSrcMux,JAdd)
--begin
--     case PcSrc is
--         when '0' => newPC <= PcSrcMux;
--         when '1' => newPC <= JAdd;
--     end case;
--end process;
newPc <= PcSrcMux when Jump = '0' else JAdd;

end Behavioral;
