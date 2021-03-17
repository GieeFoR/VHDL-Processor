library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity Program is port (
        main_clk : in std_logic;
        main_reset : in std_logic
    );
end entity;

architecture Program_arch of Program is

component ALU is port (
    clk : in std_logic;
    A : in signed(15 downto 0); 
    B : in signed(15 downto 0); 
    Salu : in signed (4 downto 0);
    Y : out signed(15 downto 0);
    C, Z, S, P : out std_logic
);
end component;

component Registers is port ( 
    clk : in std_logic;
    DATA_INPUT : in signed (15 downto 0);
    ALU_Y : in signed (15 downto 0);
    S_ALU_A, S_ALU_B : in signed (3 downto 0);
    S_ALU_Y : in signed (3 downto 0);
    Sid : in signed (2 downto 0);
    Sadr : in signed (2 downto 0);
    ALU_A, ALU_B : out signed (15 downto 0);
    ADR : out signed (15 downto 0);
    IRout : out signed (15 downto 0);
    reset : in std_logic
); 
end component;

component RAM is
port
(
    address		: IN signed (15 DOWNTO 0);
    clock		: IN std_logic  := '1';
    data		: IN signed (15 DOWNTO 0);
    rden		: IN std_logic  := '1';
    wren		: IN std_logic ;
    q		: INOUT signed (15 DOWNTO 0)
);
end component;

component busint is port ( 
    ADR : in signed(15 downto 0);
    ALU_DATA_OUTPUT : in signed(15 downto 0);
    Smar, Smbr, WRin, RDin  : in std_logic;
    MEMORY_AD : out signed (15 downto 0);
    REGISTER_DATA_INPUT : out signed(15 downto 0);
    MEMORY_DATA : inout signed (15 downto 0);
    WR, RD : out std_logic 
); 
end component;

component control is port(
        clk: in std_logic;
        reset : in std_logic; 
        IR: in signed(15 downto 0);
        Salu : out signed(4 downto 0);
        S_ALU_A, S_ALU_B, S_ALU_Y: out signed(3 downto 0);
        Sid, Sadr: out signed(2 downto 0);
        Smar, Smbr, WR, RD: out std_logic
);
end component;

signal ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, ALU_DATA_OUTPUT : signed (15 downto 0);
signal Salu : signed (4 downto 0);
signal C, Z, S, P : std_logic;
signal REGISTER_DATA_INPUT, RAM_DATA, IR : signed (15 downto 0);
signal RAM_ADRESS_INPUT, REGISTER_ADRESS_OUTPUT : signed (15 downto 0);
signal S_ALU_A, S_ALU_B, S_ALU_Y : signed (3 downto 0);
signal Sid, Sadr : signed (2 downto 0);
signal WR_FromControl, RD_FromControl : std_logic;
signal WR_FromBusint, RD_FromBusInt : std_logic;
signal Smar, Smbr : std_logic;

begin
    ALU_1: ALU port map (main_clk, ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, Salu, ALU_DATA_OUTPUT, C, Z, S, P);
    REGISTER_1: Registers port map (main_clk, REGISTER_DATA_INPUT, ALU_DATA_OUTPUT, S_ALU_A, S_ALU_B, S_ALU_Y, 
                                    Sid, Sadr, ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, REGISTER_ADRESS_OUTPUT, IR, main_reset);
    RAM_1: RAM port map (RAM_ADRESS_INPUT, main_clk, RAM_DATA, RD_FromBusInt, WR_FromBusInt, RAM_DATA);
    BUSINT_1: busint port map (REGISTER_ADRESS_OUTPUT, ALU_DATA_OUTPUT, Smar, Smbr, WR_FromControl, RD_FromControl, 
                                RAM_ADRESS_INPUT, REGISTER_DATA_INPUT, RAM_DATA, WR_FromBusint, RD_FromBusInt);
    CONTROL_1: control port map (main_clk, main_reset, IR, Salu, S_ALU_A, S_ALU_B, S_ALU_Y, Sid, Sadr, Smar, Smbr, WR_FromControl, RD_FromControl);

end Program_arch;