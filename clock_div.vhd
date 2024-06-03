library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
    Port (
        clk : in std_logic;
        div : out std_logic
    );
end clock_div;

architecture Behavioral of clock_div is
    signal freq_counter : std_logic_vector(26 downto 0) := (others => '0');  -- Defines the frequency counter

begin

    clock_divider: process(clk)
    begin
        if rising_edge(clk) then
            -- The frequency division factor calculation for 50MHz to approximately 115200Hz
            -- Calculated division factor: 50Mhz / 115200Hz = 434 (approximated for easier handling)
            if unsigned(freq_counter) < 433 then  -- since counting starts from 0
                freq_counter <= std_logic_vector(unsigned(freq_counter) + 1);
                div <= '0';  -- Output remains low while counting
            else
                freq_counter <= (others => '0');  -- Reset counter
                div <= '1';  -- Toggle the output high briefly
            end if;
        end if;
    end process clock_divider;

end Behavioral;
