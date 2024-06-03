library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_tb is
end top_level_tb;

architecture Test_Bench of top_level_tb is
    signal sim_clk, sim_en : std_logic := '0';
    signal sim_btn : std_logic_vector(1 downto 0) := (others => '0');
    signal sim_txd, sim_rxd : std_logic := '0';

begin
    clk_process: process
    begin
        sim_clk <= '0';
        wait for 4 ns;
        sim_clk <= '1';
        wait for 4 ns;
    end process;

    btn_process: process
    begin
        wait for 5 ms;
        sim_btn <= "10";
        wait for 50 ms;
        sim_btn <= "00";
        wait for 50 ms;
        sim_btn <= "01";
        wait for 50 ms;
        sim_btn <= "00";
        wait for 50 ms;
    end process;

    dut: entity work.top_level
        port map(
            clk => sim_clk,
            btn => sim_btn,
            TXD => sim_txd,
            RXD => sim_rxd
        );

    clock_div_instance: entity work.clock_div
        port map(
            clk => sim_clk,
            div => sim_en
        );

end Test_Bench;
