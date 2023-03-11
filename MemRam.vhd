----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 11:10:54 AM
-- Design Name: 
-- Module Name: MemRam - Behavioral
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

entity MemRam is
  Port (MemWrite: in STD_LOGIC;
        clk: in STD_LOGIC;
        Adr:in STD_LOGIC_VECTOR(15 downto 0);
        WriteData: in STD_LOGIC_VECTOR(15 downto 0);
        ReadData: out STD_LOGIC_VECTOR(15 downto 0));
end MemRam;

architecture Behavioral of MemRam is
type MemRam is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ram: MemRam :=(x"0000",
                      x"0000",
                      x"0001",
                      x"0000",
                      x"0001",
                      x"0000",
                      x"0001",
                      others=>x"0000");

begin
ReadData <= ram(conv_integer(Adr(7 downto 0)));
process(clk,MemWrite)
begin
    if rising_edge(clk) then
        if MemWrite = '1' then
            ram(conv_integer(Adr(7 downto 0))) <= WriteData;
        end if;
    end if;
end process;

end Behavioral;
