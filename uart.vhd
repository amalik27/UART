library ieee;
use ieee.std_logic_1164.all;

entity uart is
    port (
        clk, en, send, rx, rst      : in std_logic;
        charSend                    : in std_logic_vector(7 downto 0);
        ready, tx, newChar          : out std_logic;
        charRec                     : out std_logic_vector(7 downto 0)
    );
end uart;

architecture structural of uart is

begin

    -- Instantiating the uart_rx using the work library
    r_x: entity work.uart_rx port map(
        clk => clk,
        en => en,
        rx => rx,
        rst => rst,
        newChar => newChar,
        char => charRec);

    -- Instantiating the uart_tx using the work library
    t_x: entity work.uart_tx port map(
        clk => clk,
        en => en,
        send => send,
        rst => rst,
        char => charSend,
        ready => ready,
        tx => tx);

end structural;
