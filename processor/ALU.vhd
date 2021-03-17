library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity ALU is port (
    clk : in std_logic;
    A : in signed(15 downto 0); 
    B : in signed(15 downto 0); 
    Salu : in signed (4 downto 0);
    Y : out signed(15 downto 0);
    C, Z, S, P : out std_logic
);
end entity;

architecture rtl of ALU is
begin
    process (clk, Salu, A, B)
        --zmienne varA i varB służą do przechowania wartości
        --podanych odpowiednio na wejście A i B ALU
        variable result, varA, varB : signed (16 downto 0);
        variable CF, ZF, SF, PF : std_logic;
        
        begin
            varA(16) := '0';
            varA(15 downto 0) := A;
            varB(16) := '0';
            varB(15 downto 0) := B;

            case Salu is
                --przepisanie wejścia A na wyjście
                when "00000" =>
                    result := varA;
                --przepisanie wejścia B na wyjście
                when "00001" =>
                    result := varB;
                --dodawanie    
                when "00010" =>
                    result := varA + varB;
                --odejmowanie
                when "00011" =>
                    result := varA - varB;
                --operacja OR
                when "00100" =>
                    result := varA or varB;
                --operacja AND
                when "00101" =>
                    result := varA and varB;
                --operacja XOR
                when "00110" =>
                    result := varA xor varB;
                --operacja XNOR
                when "00111" =>
                    result := varA xnor varB;
                --operacja NOT dla B
                when "01000" =>
                    result := not varB;
                --operacja NOT dla A
                when "01001" =>
                    result := not varA;
                -- liczba B z odwrotnym znakiem
                when "01010" =>
                    result := to_signed(0, 17) - varB;
                -- liczba A z odwrotnym znakiem
                when "01011" =>
                    result := to_signed(0, 17) - varA;
                -- wyzerowanie wyjścia
                when "01100" =>
                    result := to_signed(0, 17);
                -- suma wejść z przeniesieniem
                when "01101" =>
                    if(CF = '1') then
                        result := varA + varB + to_signed(1, 17);
                    else
                        result := varA + varB;
                    end if;
                -- różnica wejść z przeniesieniem
                when "01110" =>
                    if(CF = '1') then
                        result := varA - varB - to_signed(1, 17);
                    else 
                        result := varA - varB;
                    end if;
                --inkrementacja A
                when "01111" =>
                    result := varA + to_signed(1, 17);
                --inkrementacja B
                when "10000" =>
                    result := varB + to_signed(1, 17);
                --dekrementacja A
                when "10001" =>
                    result := varA - to_signed(1, 17);
                --inkrementacja B
                when "10010" =>
                    result := varB - to_signed(1, 17);
                --shift right
                when "10011" =>
                    result(16) := '0';
                    result(15 downto 0) := varA (16 downto 1);
                --shift left
                when "10100" =>
                    result(0) := '0';
                    result(16 downto 1) := varA(15 downto 0);

                --porównanie dwóch wejść ze sobą
                when "10101" =>
                    if(varA = varB) then
                        result := to_signed(1,17);
                    else
                        result := to_signed(0,17);
                    end if;
                --RPL8 (zamiana 4 starszych bitów z 4 młodszymi bitami wartości 8-bitowej)
                when "10110" =>
                    result(16 downto 8) := varA(16 downto 8); 
                    result(3 downto 0) := varA(7 downto 4);
                    result(7 downto 4) := varA(3 downto 0);
                --RPL4 (zamiana 2 starszych bitów z 2 młodszymi bitami wartości 4-bitowej)
                when "10111" =>
                    result(16 downto 4) := varA(16 downto 4);
                    result(1 downto 0) := varA(3 downto 2);
                    result(3 downto 2) := varA(1 downto 0);
                when others => null;
            end case;
        
        Y <= result(15 downto 0);
        Z <= ZF;
        S <= SF;
        C <= CF;
        P <= PF;

        if(clk'event and clk = '1') then
            if(result = to_signed(0, 17)) then
                ZF := '1';
            else
                ZF := '0';
            end if;
                
            if(result(15) = '1') then
                SF := '1';
            else
                SF := '0';
            end if;

            CF := result(16);
            PF := result(15) xor result(14) xor result(13) xor result(12) xor result(11) xor result(10) xor result(9) xor result(8) xor
                  result(7) xor result(6) xor result(5) xor result(4) xor result(3) xor result(2) xor result(1) xor result(0);

        end if;

    end process;
end rtl;