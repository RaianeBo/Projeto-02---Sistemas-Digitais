library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display7seg is 
 port (
	z: in STD_LOGIC_VECTOR(3 downto 0);
	d: out STD_LOGIC_VECTOR(6 downto 0)
 ); 
 
end display7seg;

architecture display7seg_behav of display7seg is

begin
	process(z)
	begin
		case z is
			when "0000" => d <= "1000000"; --0
			when "0001" => d <= "1111001"; --1
			when "0010" => d <= "0100100"; --2
			when "0011" => d <= "0110000"; --3
			when "0100" => d <= "0011001"; --4
			when "0101" => d <= "0010010"; --5
			when "0110" => d <= "0000010"; --6
			when "0111" => d <= "1111000"; --7
			when "1000" => d <= "0000000"; --8
			when "1001" => d <= "0011000"; --9
			when "1010" => d <= "0000010"; --Ganhou
			when "1011" => d <= "0001100"; --Perdeu
			when "1100" => d <= "0111111"; --Número escondido
			when "1101" => d <= "1111111"; --Mantém o placar apagado
			when others => d <= "0000000"; 
		end case;
	end process;
end display7seg_behav;
