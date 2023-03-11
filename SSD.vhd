----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 10:36:41 AM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
   Port (clk : in STD_LOGIC;
         Digits: in STD_LOGIC_VECTOR(15 downto 0);
         CAT : out STD_LOGIC_VECTOR(6 downto 0);
         AN : out STD_LOGIC_VECTOR(3 downto 0) );
end SSD;

architecture Behavioral of SSD is
signal Digit0,Digit1,Digit2,Digit3: STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
signal count : std_logic_vector(15 downto 0) := (others=>'0');
signal muxDigit: STD_LOGIC_VECTOR(3 downto 0) := (others =>'0');
begin

Digit0 <= Digits(3 downto 0);
Digit1 <= Digits(7 downto 4);
Digit2 <= Digits(11 downto 8);
Digit3 <= Digits(15 downto 12);

process(clk)
begin
    if rising_edge(clk) then
        count <= count + 1;
    end if;
end process;

process(count)
begin
    case count(15 downto 14) is
        when "00" => AN <= "1110";
        when "01" => AN <= "1101";
        when "10" => AN <= "1011";
        when "11" => AN <= "0111";
    end case;
    case count(15 downto 14) is
        when "00" => muxDigit <= Digit0;
        when "01" => muxDigit <= Digit1;
        when "10" => muxDigit <= Digit2;
        when "11" => muxDigit <= Digit3;
    end case;
end process;

process(muxDigit)
begin
     case muxDigit is
         when "0001" => CAT <= "1111001";   --1
         when "0010" => CAT <= "0100100";  --2
         when "0011" => CAT <= "0110000";  --3
         when "0100" => CAT <= "0011001";  --4
         when "0101" => CAT <= "0010010";  --5
         when "0110" => CAT <= "0000010";  --6
         when "0111" => CAT <= "1111000";  --7
         when "1000" => CAT <= "0000000";   --8
         when "1001" => CAT <= "0010000";  --9
         when "1010" => CAT <= "0001000";  --A
         when "1011" => CAT <= "0000011"; --b
         when "1100" => CAT <= "1000110";  --C
         when "1101" => CAT <= "0100001";  --d
         when "1110" => CAT <= "0000110";  --E
         when "1111" => CAT <= "0001110";  --F
         when others => CAT <= "1000000";  --0
        end case;
end process;

end Behavioral;
