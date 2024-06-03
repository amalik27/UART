library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end uart_tb;

architecture tb of uart_tb is
    -- Testbench does not need a separate component declaration when using work.library
    signal rst : std_logic := '0';
    signal clk, en, send, rx, ready, tx, newChar : std_logic := '0';
    signal charSend, charRec : std_logic_vector(7 downto 0) := (others => '0');
    type str is array (0 to 4) of std_logic_vector(7 downto 0);
    signal word : str := (x"48", x"65", x"6C", x"6C");

begin
    -- Instantiate UART directly from work library
    dut: entity work.uart port map(
        clk => clk,
        en => en,
        send => send,
        rx => tx,  -- Cross-connected tx and rx to simulate a loopback
        rst => rst,
        charSend => charSend,
        ready => ready,
        tx => tx,
        newChar => newChar,
        charRec => charRec
    );

    -- Clock process for simulating a 125 MHz clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 4 ns;  -- Clock low for 4 ns
            clk <= '1';
            wait for 4 ns;  -- Clock high for 4 ns
        end loop;
    end process;

    -- Enable signal generation at approximately 115200 Hz
    en_process: process
    begin
        while true loop
            en <= '0';
            wait for 8680 ns;  -- Low for most of the time
            en <= '1';
            wait for 8 ns;    -- Short pulse
        end loop;
    end process;

    -- Test sequence to stimulate UART
    stim_process: process
        variable index: integer;
    begin  
        rst <= '1';
        wait for 100 ns; -- Initial reset
        rst <= '0';
        wait for 100 ns;

        for index in word'range loop
            wait until ready = '1' and en = '1';
            charSend <= word(index);
            send <= '1';
            wait for 200 ns; -- Simulate data hold time
            charSend <= (others => '0');
            send <= '0';
            wait until ready = '1' and newChar = '1';

            -- Check for data integrity
            if charRec /= word(index) then
                report "Send/Receive MISMATCH at time: " & time'image(now) &
                " expected: " & integer'image(to_integer(unsigned(word(index)))) &
                " received: " & integer'image(to_integer(unsigned(charRec)))
                severity ERROR;
            end if;
        end loop;

        wait for 1000 ns; -- Wait before finishing
        report "End of testbench" severity FAILURE; -- This will always run to end simulation
    end process;

end tb;
