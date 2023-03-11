----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2022 10:53:28 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
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
end UC;

architecture Behavioral of UC is

begin
process(Opcode)
begin
    RegDst<= '0';ExtOp<='0';AluSrc<='0';Branch<='0';Jump<='0';AluOp<="00";MemWrite<='0';MemToReg<='0';RegWrite<='0';
    case(Opcode) is
        when "000" => RegDst <= '1'; RegWrite <= '1';
        when "001" => RegWrite <= '1'; AluSrc <= '1'; AluOp<="01"; ExtOp<='1';
        when "010" => RegWrite <= '1'; AluSrc <= '1'; MemToReg <= '1'; AluOp<="01";
        when "011" => MemWrite <= '1'; AluSrc <= '1';AluOp<="01";
        when "100" => Branch <= '1'; AluOp<="10";ExtOp<='1';
        when "101" => RegWrite <= '1'; AluSrc <= '1'; AluOp<="10"; ExtOp<='1';
        when "110" => RegWrite <= '1'; AluSrc <= '1'; AluOp<="11";
        when "111" => Jump <= '1';
    end case;
end process;

end Behavioral;
