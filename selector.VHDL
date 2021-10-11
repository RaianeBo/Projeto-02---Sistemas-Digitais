library ieee;
use ieee.std_logic_1164.all;

entity selector is
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
        Xout2: out std_logic_vector(9 downto 0)
    );
end selector;

architecture behave of selector is
    signal X : std_logic_vector(9 downto 0); 
    signal X_meta : std_logic_vector(9 downto 0); 
    signal X_curr : std_logic_vector(9 downto 0); 
    signal X_last : std_logic_vector(9 downto 0); 
begin
    -- Concatena todas as entradas em um vetor
    X <= X9 & X8 & X7 & X6 & X5 & X4 & X3 & X2 & X1 & X0;

    sync: process(clk)
    begin
        if rising_edge(clk) then
            X_meta <= X;
            X_curr <= X_meta;
        end if;
    end process;

    
    X_last <= X_curr when rising_edge(clk);
    Xout1 <= X_curr;
    Xout2 <= X_last;

    process(X_curr, X_last)
    begin
        if    (X_curr(0) xor X_last(0)) = '1' then
            O <= "0000";
        elsif (X_curr(1) xor X_last(1)) = '1' then
            O <= "0001";
        elsif (X_curr(2) xor X_last(2)) = '1' then
            O <= "0010";
        elsif (X_curr(3) xor X_last(3)) = '1' then
            O <= "0011";
        elsif (X_curr(4) xor X_last(4)) = '1' then
            O <= "0100";
        elsif (X_curr(5) xor X_last(5)) = '1' then
            O <= "0101";
        elsif (X_curr(6) xor X_last(6)) = '1' then
            O <= "0110";
        elsif (X_curr(7) xor X_last(7)) = '1' then
            O <= "0111";
        elsif (X_curr(8) xor X_last(8)) = '1' then
            O <= "1000";
        elsif (X_curr(9) xor X_last(9)) = '1' then
            O <= "1001";
        else
            O <= "1100";
        end if;
    end process;
end behave;
