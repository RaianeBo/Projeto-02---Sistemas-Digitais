library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity forca is
    port (CLOCK_50: in STD_LOGIC;
        V_SW : in STD_LOGIC_VECTOR(10 downto 0); --Resetor e seletores
        G_LEDR : out STD_LOGIC_VECTOR(4 downto 0);
        G_HEX0: out STD_LOGIC_VECTOR(6 downto 0);
        G_HEX1 : out STD_LOGIC_VECTOR(6 downto 0);
		    G_HEX2: out STD_LOGIC_VECTOR(6 downto 0);
		    G_HEX3: out STD_LOGIC_VECTOR(6 downto 0);
		    G_HEX4 : out STD_LOGIC_VECTOR(6 downto 0);
		    G_HEX5: out STD_LOGIC_VECTOR(6 downto 0)
    );
end forca;

architecture Behavioral of forca is
    type detector_state is (waiting, G, P, reset);
    signal pr_state,nx_state: detector_state;
    
    component display7seg is -- Declaração do display de 7 segmentos
		    port (z: in STD_LOGIC_VECTOR(3 downto 0);
		        d: out STD_LOGIC_VECTOR(6 downto 0)
		    );
	end component;
	
	component selector is  -- Declaração do seletor 
			port (
        clk : in std_logic;
        X0:  in std_logic;
        X1:  in std_logic;
        X2:  in std_logic;
        X3:  in std_logic;
        X4:  in std_logic;
        X5:  in std_logic;
        X6:  in std_logic;
        X7:  in std_logic;
        X8:  in std_logic;
        X9:  in std_logic;
        O:   out std_logic_vector(3 downto 0);
        Xout1: out std_logic_vector(9 downto 0);
        Xout2: out std_logic_vector(9 downto 0));
	end component;
    
    -- Declaração do número secreto (1234)
    signal letter1: STD_LOGIC_VECTOR(3 downto 0) := "0001";     --DISPLAY2
    signal letter2: STD_LOGIC_VECTOR(3 downto 0) := "0010";     --DISPLAY3
    signal letter3: STD_LOGIC_VECTOR(3 downto 0) := "0011";     --DISPLAY4
    signal letter4: STD_LOGIC_VECTOR(3 downto 0) := "0100";     --DISPLAY5
    
	signal new_letter: STD_LOGIC_VECTOR(3 downto 0);
	
	signal z1,z2,z3,z4:STD_LOGIC_VECTOR(3 downto 0);
	
	--Mantém o display perdeu/ganhou inicialmente apagado
	signal z0: STD_LOGIC_VECTOR(3 downto 0) := "1101";
	
	--LEDs que representam as vidas restantes (todos inicialmente acesos)
	signal led1,led2,led3,led4,led5: STD_LOGIC := '1';
	

	signal pr_s: STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
	signal nx_s: STD_LOGIC_VECTOR(9 downto 0);
	
	--Contador de erros e de letras
	 signal countErrors: std_logic_vector(5 downto 0) := "000000";
     signal countLetters: std_logic_vector(3 downto 0) := "0000";
	
begin
    G_LEDR(0) <= led1; --Acende o led 1. 
    G_LEDR(1) <= led2; --Acende o led 2.
    G_LEDR(2) <= led3; --Acende o led 3.
    G_LEDR(3) <= led4; --Acende o led 4.
    G_LEDR(4) <= led5; --Acende o led 5.
    G_HEX1 <= "1111111";  
    
    DISPLAY_letter1: display7seg 
		    port map (
		        z => z1,
		        d => G_HEX2
		        );
		        
	DISPLAY_letter2: display7seg
		    port map (
		        z => z2,
		        d => G_HEX3);
		        
	DISPLAY_letter3: display7seg
		    port map (
		        z => z3,
		        d => G_HEX4);
		        
	DISPLAY_letter4: display7seg 
		    port map (
		        z => z4,
		        d => G_HEX5
		        );
		        
	
	DISPLAY_winlose: display7seg 
		    port map (
		        z => z0,
		        d => G_HEX0
		        );

    DETECT_selector: selector
            port map (
               clk => CLOCK_50,
                X0 => V_SW(0),
                X1 => V_SW(1),
                X2 => V_SW(2),
                X3 => V_SW(3),
                X4 => V_SW(4),
                X5 => V_SW(5),
                X6 => V_SW(6),
                X7 => V_SW(7),
                X8 => V_SW(8),
                X9 => V_SW(9),
                O => new_letter,
                Xout1 => pr_s,
                Xout2 => nx_s
            );

    process (CLOCK_50,V_SW(10 downto 10),pr_state,nx_state)
    begin
    
       if (V_SW(10)='1') then
            pr_state <= reset;
        elsif(CLOCK_50'EVENT and CLOCK_50='1') then
            pr_state <= nx_state;
        end if;
       
    end process;
    
    process (pr_state,V_SW(9 downto 0),led1,led2,led3,
            z1,z2,z3,z4,z0,new_letter)
    begin
      case pr_state is
          when reset =>
              countErrors <= "000000";
              countLetters <= "0000";
              led1 <= '1';
              led2 <= '1';
              led3 <= '1';
              led4 <= '1';
              led5 <= '1';
              
              --DISPLAYS
              z1 <= "1100"; -- acende somente um traço no display.
              z2 <= "1100"; -- acende somente um traço no display.
              z3 <= "1100"; -- acende somente um traço no display.
              z4 <= "1100"; -- acende somente um traço no display.
              z0 <= "1101"; -- acende somente um traço no display.
             
              nx_state <= waiting;
                
          when waiting =>
            -- contabiliza os acertos 
            if ((pr_s(1) xor nx_s(1)) = '1') and (new_letter=letter1) then
                countLetters(0) <= '1';
                --DISPLAY
                z1 <= letter1;
                
            elsif ((pr_s(2) xor nx_s(2)) = '1') and (new_letter=letter2) then
                countLetters(1) <= '1';
                --DISPLAY
                z2 <=letter2;
                
        	elsif ((pr_s(3) xor nx_s(3)) = '1') and (new_letter=letter3) then
                countLetters(2) <= '1';
                --DISPLAY
                z3 <= letter3;
                
        	elsif ((pr_s(4) xor nx_s(4)) = '1') and (new_letter=letter4) then
                countLetters(3) <= '1';
                --DISPLAY
                z4 <= letter4;
                
            -- conta os erros     
            elsif ((pr_s(0) xor nx_s(0)) = '1') then
                countErrors(0)<='1';
            elsif ((pr_s(5) xor nx_s(5)) = '1') then
                countErrors(1)<='1';
            elsif ((pr_s(6) xor nx_s(6)) = '1') then
                countErrors(2)<='1';
            elsif ((pr_s(7) xor nx_s(7)) = '1') then
                countErrors(3)<='1';
            elsif ((pr_s(8) xor nx_s(8)) = '1') then
                countErrors(4)<='1';
            elsif ((pr_s(9) xor nx_s(9)) = '1') then
                countErrors(5)<='1';
        	end if;
        	
        	if (countLetters="1111") then
        	    nx_state <= G; -- vai para o estado "ganhou" caso todas 
        	                   --  as letras sejam descobertas
        	elsif ((countErrors="000001") or (countErrors="000010") 
        	or (countErrors="000100") or (countErrors="001000") 
        	or (countErrors="010000") or (countErrors="100000")) then
        	    -- Apaga um led caso ocorra um erro.
        	    led5 <= '0'; 
        	    led4 <= '1';
        	    led3 <= '1';
        	    led2 <= '1';
        	    led1 <= '1';
        	    nx_state <= waiting;
        	elsif ((countErrors="001001") or (countErrors="101000") 
        	or (countErrors="100010")  or (countErrors="010100") 
        	or (countErrors="001010") or (countErrors="010001") 
        	or (countErrors="110000") or (countErrors="001100")
        	or (countErrors="010010") or (countErrors="000110")
        	or (countErrors="011000") or (countErrors="100001")
        	or (countErrors="100100") or (countErrors="000011") 
        	or (countErrors="000101")) then
        	    -- Apaga dois leds caso ocorram dois erros. 
        	    led5 <= '0';
        	    led4 <= '0';
        	    led3 <= '1';
        	    led2 <= '1';
        	    led1 <= '1';
        	    nx_state <= waiting;
        	elsif ((countErrors="000111") or (countErrors="001011")
        	or (countErrors="001101") or (countErrors="001101") 
        	or (countErrors="001110") or (countErrors="010011") 
        	or (countErrors="010101") or (countErrors="010110") 
        	or (countErrors="011001") or (countErrors="011010")
        	or (countErrors="011100") or (countErrors="100011") 
        	or (countErrors="100101") or (countErrors="100110")
        	or (countErrors="101001") or (countErrors="101010")
        	or (countErrors="101100") or (countErrors="110001")
        	or (countErrors="110010") or (countErrors="110100")
        	or (countErrors="111000")) then
        	    -- Apaga três leds caso ocorram três erros.
        	    led5 <= '0';
        	    led4 <= '0';
        	    led3 <= '0';
        	    led2 <= '1';
        	    led1 <= '1';
        	    nx_state <= waiting;
        	elsif ((countErrors="001111") or (countErrors="010111") 
        	or (countErrors="011011") or (countErrors="011101") 
        	or (countErrors="011110") or (countErrors="100111") 
        	or (countErrors="101011") or (countErrors="101101") 
        	or (countErrors="101110") or (countErrors="110011") 
        	or (countErrors="110101") or (countErrors="110110") 
        	or (countErrors="111001") or (countErrors="111010") 
        	or (countErrors="111100")) then
        	    -- Apaga três leds caso ocorram três erros.
        	    led5 <= '0';
        	    led4 <= '0';
        	    led3 <= '0';
        	    led2 <= '0';
        	    led1 <= '1';
        	    nx_state <= waiting;
        	elsif ((countErrors="011111") or (countErrors="101111")
        	or (countErrors="110111") or (countErrors="111011") 
        	or (countErrors="111101") or (countErrors="111110")) then
        	    -- Apaga todos os leds e vai para o estado "Perdeu".
        	    led5 <= '0';
        	    led4 <= '0';
        	    led3 <= '0';
        	    led2 <= '0';
        	    led1 <= '0';
        	    nx_state <= P;
        	end if;
            
        when P =>
             --DISPLAYS
              z1 <= "1100";
              z2 <= "1100";
              z3 <= "1100";
              z4 <= "1100";
              z0 <= "1011"; -- Exibe um "P" no display. 
            
        when G =>
            --DISPLAYS
              z1 <= "1100";
              z2 <= "1100";
              z3 <= "1100";
              z4 <= "1100";
              z0 <= "1010"; -- Exibe um "G" no display. 
      end case;
    end process;
		        
    
end Behavioral;
