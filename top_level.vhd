library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        TXD : in std_logic;
        btn : in std_logic_vector(1 downto 0);
        clk : in std_logic;
        CTS : out std_logic;
        RTS : out std_logic;
        RXD : out std_logic
    );
end top_level;

architecture Behavioral of top_level is

    signal debounce_signal1, debounce_signal2 : std_logic;
    signal division_enable : std_logic;
    signal communication_ready, trigger_send : std_logic;
    signal character_data : std_logic_vector(7 downto 0);

begin
    CTS <= '0';
    RTS <= '0';

    -- Instantiating the debounce module for btn(0)
    u1: entity work.debounce
        port map(
            clk => clk,
            btn => btn(0),
            dbnc => debounce_signal1
        );

    -- Instantiating the debounce module for btn(1)
    u2: entity work.debounce
        port map(
            clk => clk,
            btn => btn(1),
            dbnc => debounce_signal2
        );

    -- Instantiating the clock_div module
    u3: entity work.clock_div
        port map(
            clk => clk,
            div => division_enable
        );

    -- Instantiating the sender module
    u4: entity work.sender
        port map(
            CLK => clk,
            EN => division_enable,
            BTN => debounce_signal2,
            RDY => communication_ready,
            RST => debounce_signal1,
            CHAR => character_data,
            SEND => trigger_send
        );

    -- Instantiating the uart module
    u5: entity work.uart
        port map(
            clk => clk,
            en => division_enable,
            send => trigger_send,
            rx => TXD,
            rst => debounce_signal1,
            charSend => character_data,
            ready => communication_ready,
            tx => RXD
        );

end Behavioral;
