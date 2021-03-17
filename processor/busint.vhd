library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity busint is port ( 
  ADR : in signed(15 downto 0); -- adres pobierany z rejestrów [A]
  ALU_DATA_OUTPUT : in signed(15 downto 0); -- dane pobierane z alu [DO]
  Smar, Smbr, WRin, RDin : in std_logic;  -- sygnały sterujące zapisem i odczytem
  MEMORY_AD : out signed (15 downto 0); -- magistrala adresowa (magistrala do pamięci zewnętrznej) [AD]
  REGISTER_DATA_INPUT : out signed(15 downto 0); -- dane przekazywane do rejestrów [DI]
  MEMORY_DATA : inout signed (15 downto 0); -- magistrala danych we/wy (magistrala do pamięci zewnętrznej) [D]
  WR, RD : out std_logic ); 
end entity; 

architecture rtl of busint is 
  begin 
  process(Smar, ADR, Smbr, ALU_DATA_OUTPUT, MEMORY_DATA, WRin, RDin) 
    variable MBRin, MBRout: signed(15 downto 0); 
    variable MAR : signed(15 downto 0); 

    begin 
      if(Smar='1') then 
        MAR := ADR; 
      end if; 

      if(Smbr='1') then 
        MBRout := ALU_DATA_OUTPUT; 
      end if; 

      if (RDin='1') then 
        MBRin := MEMORY_DATA; 
      end if; 

      if (WRin='1') then 
        MEMORY_DATA <= MBRout; 
      else 
        MEMORY_DATA <= "ZZZZZZZZZZZZZZZZ"; 
      end if; 

      REGISTER_DATA_INPUT <= MBRin; 
      MEMORY_AD <= MAR; 
      WR <= WRin; 
      RD <= RDin; 
  end process; 
end rtl; 