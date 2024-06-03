library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port (
        clk, en, send, rst : in std_logic;
        char : in std_logic_vector(7 downto 0);
        ready, tx : out std_logic
    );
end uart_tx;

architecture Behavioral of uart_tx is
    type fsm_state is (idle, start, data);
    signal fsm_current, fsm_next: fsm_state := idle;
    signal data_buffer: std_logic_vector(7 downto 0) := (others => '0');
    signal bit_index: integer range 0 to 7 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                fsm_current <= idle;
                tx <= '1';
                ready <= '1';
                bit_index <= 0;
                data_buffer <= (others => '0');
            elsif en = '1' then
                case fsm_current is
                    when idle =>
                        if send = '1' then
                            data_buffer <= char;
                            fsm_next <= start;
                        else
                            tx <= '1';
                            ready <= '1';
                        end if;
                    when start =>
                        tx <= '0';
                        ready <= '0';
                        fsm_next <= data;
                    when data =>
                        tx <= data_buffer(bit_index);
                        if bit_index = 7 then
                            fsm_next <= idle;
                            ready <= '1';
                            bit_index <= 0;
                        else
                            bit_index <= bit_index + 1;
                        end if;
                end case;
                fsm_current <= fsm_next;
            end if;
        end if;
    end process;
end Behavioral;
