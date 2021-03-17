library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity Registers is port ( 
  clk : in std_logic;
  DATA_INPUT : in signed (15 downto 0); -- dane przekazywane z zewnątrz (z modułu współpracy z pamięcią) [DI]
  ALU_Y : in signed (15 downto 0); -- dane przekazywane z wyjścia Y ALU do modułu rejestrów [BA]
  S_ALU_A, S_ALU_B : in signed (3 downto 0); -- wskazuje rejestr spod którego mają zostać odczytane dane i przekazane do ALU_A (analogicznie dla ALU_B) [SBB] [SBC]
  S_ALU_Y : in signed (3 downto 0); -- wkazuje rejestr do którego mają zostać zapisane dane z ALU_Y [SBA]
  Sid : in signed (2 downto 0); -- kod operacji inkrementacji lub dekrementacji zawartości wybranych rejestrów [Sid]
  Sadr : in signed (2 downto 0); -- wskazuje który rejestr ma zostać wyprowadzony na wyjście ADR [SA]
  ALU_A, ALU_B : out signed (15 downto 0); -- dane przekazywane na wejścia A i B jednostki ALU [BB] [BC]
  ADR : out signed (15 downto 0); -- adres przekazywany do modułu współpracy z pamięcią [A]
  IRout : out signed (15 downto 0); -- kod rozkazu procesora
  reset : in std_logic
  ); 
end entity;

architecture rtl of Registers is
    begin
    process (clk, reset, S_ALU_A, S_ALU_B, S_ALU_Y, Sid, Sadr, DATA_INPUT)

    variable IR, TMP, B, C, D, E, F : signed (15 downto 0) := to_signed(0,16);
    variable A : signed (15 downto 0) := to_signed(8,16);
    variable AD, ATMP, ES : signed (15 downto 0) := to_signed(0,16);
    variable PC : signed (15 downto 0) := to_signed(0,16);
    variable SP : signed (15 downto 0) := x"FFFF";
    variable AP1, AP2 : signed (7 downto 0) := to_signed(0,8);


    begin
        if(clk'event and clk = '1') then
            case Sid is
                when "000" =>
                    null;
                when "001" =>
                    PC := PC + 1;
                when "010" =>
                    SP := SP + 1;
                when "011" =>
                    SP := SP - 1;
                when "100" =>
                    AD := AD + 1;
                when "101" =>
                    AD := AD - 1;
                when others =>
                    null;
            end case;

            case S_ALU_Y is
                when "0000" =>
                    IR := ALU_Y;
                when "0001" =>
                    TMP := ALU_Y;
                when "0010" => 
                    A := ALU_Y;
                when "0011" =>
                    B := ALU_Y;
                when "0100" =>
                    C := ALU_Y;
                when "0101" =>
                    D := ALU_Y;
                when "0110" =>
                    E := ALU_Y;
                when "0111" =>
                    F := ALU_Y;
                when "1000" =>
                    ATMP := ALU_Y;
                when "1001" =>
                    AP1 := ALU_Y (15 downto 8);
                    AP2 := ALU_Y (7 downto 0);
                when "1010" =>
                    ES := ALU_Y;
                when others =>
                    null;
            end case;
        end if;

        case S_ALU_A is
            when "0000" =>
                ALU_A <= DATA_INPUT;
            when "0001" =>
                ALU_A <= TMP;
            when "0010" =>
                ALU_A <= A;
            when "0011" =>
                ALU_A <= B;
            when "0100" =>
                ALU_A <= C;
            when "0101" =>
                ALU_A <= D;
            when "0110" =>
                ALU_A <= E;
            when "0111" =>
                ALU_A <= F;
            when "1000" =>
                ALU_A (15 downto 8) <= AP1;
                ALU_A (7 downto 0) <= AP2;
            when "1001" =>
                ALU_A <= ES;
            when "1010" =>
                ALU_A <= IR and "0000000000011111";
            when others =>
                null;
        end case;

        case S_ALU_B is
            when "0000" =>
                ALU_B <= DATA_INPUT;
            when "0001" =>
                ALU_B <= TMP;
            when "0010" =>
                ALU_B <= A;
            when "0011" =>
                ALU_B <= B;
            when "0100" =>
                ALU_B <= C;
            when "0101" =>
                ALU_B <= D;
            when "0110" =>
                ALU_B <= E;
            when "0111" =>
                ALU_B <= F;
            when "1000" =>
                ALU_B (15 downto 8) <= AP1;
                ALU_B (7 downto 0) <= AP2;
            when "1001" =>
                ALU_B <= ES;
            when "1010" =>
                ALU_B <= IR and "0000000000011111";
            when others =>
                null;
        end case;

        case Sadr is
            when "000" =>
                ADR <= AD;
            when "001" =>
                ADR <= PC;
            when "010" =>
                ADR <= SP;
            when "011" =>
                ADR <= ATMP;
            when "100" =>
                ADR <= IR;
            when others =>
                null;
        end case;

        IRout <= IR;

        if (reset='1') then
            SP := x"FFFF";
            PC := to_signed(0,16);
            A := to_signed(8,16);
            B := to_signed(0,16);
            C := to_signed(0,16);
            D := to_signed(0,16);
            E := to_signed(0,16);
            F := to_signed(0,16);
        end if;
        
    end process;
end rtl;