library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    port (
        clk, en, rx, rst    : in std_logic;
        newChar             : out std_logic;
        char                : out std_logic_vector(7 downto 0)
    );
end uart_rx;

architecture fsm of uart_rx is

    type fsm_state is (idle, start, data);
    signal state : fsm_state := idle;

    signal shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal bit_count : std_logic_vector(2 downto 0) := (others => '0');
    signal rx_shift : std_logic_vector(3 downto 0) := (others => '0');
    signal voted : std_logic := '0';

begin

    process(clk) begin
        if rising_edge(clk) then
            rx_shift <= rx_shift(2 downto 0) & rx;
        end if;
    end process;

    process(rx_shift)
    begin
        if ((rx_shift(3) = '1' and rx_shift(2) = '1') or
        (rx_shift(3) = '1' and rx_shift(1) = '1') or
        (rx_shift(2) = '1' and rx_shift(1) = '1')) then
            voted <= '1';
        else
            voted <= '0';
        end if;
    end process;

    process(clk) begin
    if rising_edge(clk) then

        if rst = '1' then
            state <= idle;
            shift_reg <= (others => '0');
            bit_count <= (others => '0');
            newChar <= '0';
        elsif en = '1' then
            case state is
                when idle =>
                    newChar <= '0';
                    if voted = '0' then
                        state <= start;
                    end if;

                when start =>
                    shift_reg <= voted & shift_reg(7 downto 1);
                    bit_count <= (others => '0');
                    state <= data;

                when data =>
                    if unsigned(bit_count) < 7 then
                        shift_reg <= voted & shift_reg(7 downto 1);
                        bit_count <= std_logic_vector(unsigned(bit_count) + 1);
                    elsif voted = '1' then
                        state <= idle;
                        newChar <= '1';
                        char <= shift_reg;
                    else
                        state <= idle;
                    end if;

                when others =>
                    state <= idle;

            end case;
        end if;

    end if;
    end process;

end fsm;
