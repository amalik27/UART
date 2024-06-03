library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port (
        btn : in std_logic;
        clk : in std_logic;
        dbnc : out std_logic
    );
end debounce;

architecture Behavioral of debounce is

    signal delay_counter : std_logic_vector(21 downto 0) := (others => '0'); -- Initial value defined

begin

    debounce_process: process(clk)
    begin
        if rising_edge(clk) then
            if btn = '1' then
                -- Increment the counter while the button is pressed
                if unsigned(delay_counter) < 2500000 then
                    delay_counter <= std_logic_vector(unsigned(delay_counter) + 1);
                else
                    dbnc <= '1'; -- Set debounced output to high after 2.5 million cycles
                end if;
            else
                dbnc <= '0';
                delay_counter <= (others => '0'); -- Reset the counter when button is not pressed
            end if;
        end if;
    end process debounce_process;

end Behavioral;
