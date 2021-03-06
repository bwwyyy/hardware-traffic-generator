----------------------------------------------------------------------------------
-- Flow generator:
-- responsible of sending 1 flow at 10 Gbit/s
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flow_generator is
    Port (
        CLK             : in std_logic;
        RESET           : in std_logic;
        -- Input FrameLink (configuration)
        RX_DATA         : in std_logic_vector(63 downto 0);
        RX_REM          : in std_logic_vector(2 downto 0);
        RX_SOF_N        : in std_logic;
        RX_EOF_N        : in std_logic;
        RX_SOP_N        : in std_logic;
        RX_EOP_N        : in std_logic;
        RX_SRC_RDY_N    : in std_logic;
        RX_DST_RDY_N    : out std_logic;
        -- Output FrameLink (traffic)
        TX_DATA         : out std_logic_vector(63 downto 0);
        TX_REM          : out std_logic_vector(2 downto 0);
        TX_SOF_N        : out std_logic;
        TX_EOF_N        : out std_logic;
        TX_SOP_N        : out std_logic;
        TX_EOP_N        : out std_logic;
        TX_SRC_RDY_N    : out std_logic;
        TX_DST_RDY_N    : in std_logic;
        -- Reconfiguration
        RECONF          : in std_logic
    );
end flow_generator;

architecture Behavioral of flow_generator is

    -- Number of signals that should link modifiers
    constant LINK_SIGNALS   : integer := 6;

    type data_array is array(0 to LINK_SIGNALS-1) of std_logic_vector(63 downto 0);
    type rem_array is array(0 to LINK_SIGNALS-1) of std_logic_vector(2 downto 0);
    -- Links between framelink modules
    signal link_data        : data_array;
    signal link_rem         : rem_array;
    signal link_sof_n       : std_logic_vector(LINK_SIGNALS-1 downto 0);
    signal link_eof_n       : std_logic_vector(LINK_SIGNALS-1 downto 0);
    signal link_sop_n       : std_logic_vector(LINK_SIGNALS-1 downto 0);
    signal link_eop_n       : std_logic_vector(LINK_SIGNALS-1 downto 0);
    signal link_src_rdy_n   : std_logic_vector(LINK_SIGNALS-1 downto 0);
    signal link_dst_rdy_n   : std_logic_vector(LINK_SIGNALS-1 downto 0);

begin

    -- Skeleton sender
    skeleton: entity work.skeleton_sender
    generic map (
        ID => X"01"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => RX_DATA,
        RX_REM => RX_REM,
        RX_SOF_N => RX_SOF_N,
        RX_EOF_N => RX_EOF_N,
        RX_SOP_N => RX_SOP_N,
        RX_EOP_N => RX_EOP_N,
        RX_SRC_RDY_N => RX_SRC_RDY_N,
        RX_DST_RDY_N => RX_DST_RDY_N,
        TX_DATA => link_data(0),
        TX_REM => link_rem(0),
        TX_SOF_N => link_sof_n(0),
        TX_EOF_N => link_eof_n(0),
        TX_SOP_N => link_sop_n(0),
        TX_EOP_N => link_eop_n(0),
        TX_SRC_RDY_N => link_src_rdy_n(0),
        TX_DST_RDY_N => link_dst_rdy_n(0),
        RECONF => RECONF
    );

    -- Increment modifier
    increment: entity work.increment
    generic map (
        ID => X"06"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(0),
        RX_REM => link_rem(0),
        RX_SOF_N => link_sof_n(0),
        RX_EOF_N => link_eof_n(0),
        RX_SOP_N => link_sop_n(0),
        RX_EOP_N => link_eop_n(0),
        RX_SRC_RDY_N => link_src_rdy_n(0),
        RX_DST_RDY_N => link_dst_rdy_n(0),
        TX_DATA => link_data(5),
        TX_REM => link_rem(5),
        TX_SOF_N => link_sof_n(5),
        TX_EOF_N => link_eof_n(5),
        TX_SOP_N => link_sop_n(5),
        TX_EOP_N => link_eop_n(5),
        TX_SRC_RDY_N => link_src_rdy_n(5),
        TX_DST_RDY_N => link_dst_rdy_n(5),
        RECONF => RECONF
    );


    -- Checksum computer 1
    checksum: entity work.checksum
    generic map (
        ID => X"03"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(5),
        RX_REM => link_rem(5),
        RX_SOF_N => link_sof_n(5),
        RX_EOF_N => link_eof_n(5),
        RX_SOP_N => link_sop_n(5),
        RX_EOP_N => link_eop_n(5),
        RX_SRC_RDY_N => link_src_rdy_n(5),
        RX_DST_RDY_N => link_dst_rdy_n(5),
        TX_DATA => link_data(1),
        TX_REM => link_rem(1),
        TX_SOF_N => link_sof_n(1),
        TX_EOF_N => link_eof_n(1),
        TX_SOP_N => link_sop_n(1),
        TX_EOP_N => link_eop_n(1),
        TX_SRC_RDY_N => link_src_rdy_n(1),
        TX_DST_RDY_N => link_dst_rdy_n(1),
        RECONF => RECONF
    );

    -- Checksum computer 2
    checksum2: entity work.checksum
    generic map (
        ID => X"04"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(1),
        RX_REM => link_rem(1),
        RX_SOF_N => link_sof_n(1),
        RX_EOF_N => link_eof_n(1),
        RX_SOP_N => link_sop_n(1),
        RX_EOP_N => link_eop_n(1),
        RX_SRC_RDY_N => link_src_rdy_n(1),
        RX_DST_RDY_N => link_dst_rdy_n(1),
        TX_DATA => link_data(2),
        TX_REM => link_rem(2),
        TX_SOF_N => link_sof_n(2),
        TX_EOF_N => link_eof_n(2),
        TX_SOP_N => link_sop_n(2),
        TX_EOP_N => link_eop_n(2),
        TX_SRC_RDY_N => link_src_rdy_n(2),
        TX_DST_RDY_N => link_dst_rdy_n(2),
        RECONF => RECONF
    );

    -- Ethernet FCS computation
    eth_fcs: entity work.ethernet_fcs
    generic map (
        ID => X"02"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(2),
        RX_REM => link_rem(2),
        RX_SOF_N => link_sof_n(2),
        RX_EOF_N => link_eof_n(2),
        RX_SOP_N => link_sop_n(2),
        RX_EOP_N => link_eop_n(2),
        RX_SRC_RDY_N => link_src_rdy_n(2),
        RX_DST_RDY_N => link_dst_rdy_n(2),
        TX_DATA => link_data(3),
        TX_REM => link_rem(3),
        TX_SOF_N => link_sof_n(3),
        TX_EOF_N => link_eof_n(3),
        TX_SOP_N => link_sop_n(3),
        TX_EOP_N => link_eop_n(3),
        TX_SRC_RDY_N => link_src_rdy_n(3),
        TX_DST_RDY_N => link_dst_rdy_n(3),
        RECONF => RECONF
    );

    -- Packet rate limiter
    rate: entity work.rate
    generic map (
        ID => X"05"
    ) port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(3),
        RX_REM => link_rem(3),
        RX_SOF_N => link_sof_n(3),
        RX_EOF_N => link_eof_n(3),
        RX_SOP_N => link_sop_n(3),
        RX_EOP_N => link_eop_n(3),
        RX_SRC_RDY_N => link_src_rdy_n(3),
        RX_DST_RDY_N => link_dst_rdy_n(3),
        TX_DATA => link_data(4),
        TX_REM => link_rem(4),
        TX_SOF_N => link_sof_n(4),
        TX_EOF_N => link_eof_n(4),
        TX_SOP_N => link_sop_n(4),
        TX_EOP_N => link_eop_n(4),
        TX_SRC_RDY_N => link_src_rdy_n(4),
        TX_DST_RDY_N => link_dst_rdy_n(4),
        RECONF => RECONF
    );

    -- Configuration remover
    config_rm: entity work.config_remover
    port map (
        CLK => CLK,
        RESET => RESET,
        RX_DATA => link_data(4),
        RX_REM => link_rem(4),
        RX_SOF_N => link_sof_n(4),
        RX_EOF_N => link_eof_n(4),
        RX_SOP_N => link_sop_n(4),
        RX_EOP_N => link_eop_n(4),
        RX_SRC_RDY_N => link_src_rdy_n(4),
        RX_DST_RDY_N => link_dst_rdy_n(4),
        TX_DATA => TX_DATA,
        TX_REM => TX_REM,
        TX_SOF_N => TX_SOF_N,
        TX_EOF_N => TX_EOF_N,
        TX_SOP_N => TX_SOP_N,
        TX_EOP_N => TX_EOP_N,
        TX_SRC_RDY_N => TX_SRC_RDY_N,
        TX_DST_RDY_N => TX_DST_RDY_N,
        RECONF => RECONF
    );

end Behavioral;

