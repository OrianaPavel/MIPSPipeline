----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2022 10:18:03 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
  Port (clk : in STD_LOGIC;
        button : in STD_LOGIC;
        enable: out STD_LOGIC
         );
end MPG;

architecture Behavioral of MPG is
constant ones : STD_LOGIC_VECTOR( 15 downto 0) := (others => '1');
signal count : std_logic_vector(15 downto 0) := (others=>'0');
signal en : std_logic := '0';
signal Q1 : STD_LOGIC := '0';
signal Q2 : STD_LOGIC := '0';
signal Q3 : STD_LOGIC := '0';



begin

enable <= (not Q3) and Q2;

process(clk)
begin
     en <= '0';
     if rising_edge(clk) then
        count <= count +1;
     end if;
     if count = ones then
        en <= '1';
     end if;
end process;

process(clk,en,button)
begin 
    if rising_edge(clk) then
        if en = '1' then
            Q1 <= button;
        end if;
    end if;
end process;

process(Q1)
begin
    if rising_edge(clk) then
        Q2 <= Q1;
    end if;
end process;

process(Q2)
begin
    if rising_edge(clk) then
        Q3 <= Q2;
    end if;
end process;



end Behavioral;
