----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 11:19:33 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
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
end ALU;

architecture Behavioral of ALU is
signal count : std_logic_vector(1 downto 0) := (others=>'0');

signal mux : std_logic_vector(15 downto 0) := (others=>'0');

signal sum,RD2ALU,mul,andRez,orRez,xorRez,AluOut : std_logic_vector(15 downto 0) := (others=>'0');
signal sub : std_logic_vector(15 downto 0) := (others=>'0');
signal shiftr : std_logic_vector(15 downto 0) := (others=>'0');
signal shiftl : std_logic_vector(15 downto 0) := (others=>'0');
signal AluCtlr: STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
signal mul32: STD_LOGIC_VECTOR(31 downto 0);
begin

RD2ALU <= RD2 when AluSrc = '0' else Ext_Imm;

sum <= RD1 + RD2ALU;
--sum <=  Ext_Imm;
sub <= RD1 - RD2ALU;
shiftl <= RD1(14 downto 0) & "0" when sa = '1' else RD1(15 downto 0);
shiftr <= "0" & RD1(15 downto 1) when sa = '1' else RD1(15 downto 0);
mul32 <= RD1 * RD2ALU;
mul <= mul32(15 downto 0);
andRez <= RD1 and RD2ALU;
orRez <= RD1 or RD2ALU;
xorRez <= RD1 xor RD2ALU;

zero <= '1' when conv_integer(AluOut) = 0 else '0';
AluRes <= AluOut;

process(AluOp,func)
begin
    case AluOp is
        when "00" => 
            case func is
                when "000" => AluCtlr <= "000";
                when "001" => AluCtlr <= "001";
                when "010" => AluCtlr <= "110";
                when "011" => AluCtlr <= "111";
                when "100" => AluCtlr <= "011";
                when "101" => AluCtlr <= "100";
                when "110" => AluCtlr <= "101";
                when "111" => AluCtlr <= "010";
            end case;
        when "01" => AluCtlr <= "000";
        when "10" => AluCtlr <= "001";
        when "11" => AluCtlr <= "011";
    end case;
end process;

process(sum,sub,mul,andRez,orRez,xorRez,shiftL,shiftR,AluCtlr)
begin
    case AluCtlr is
        when "000" => AluOut <= sum;
        when "001" => AluOut <= sub;
        when "010" => AluOut <= mul;
        when "011" => AluOut <= andRez;
        when "100" => AluOut <= orRez;
        when "101" => AluOut <= xorRez;
        when "110" => AluOut <= shiftL;
        when "111" => AluOut <= shiftR;
    end case;
end process;

end Behavioral;
