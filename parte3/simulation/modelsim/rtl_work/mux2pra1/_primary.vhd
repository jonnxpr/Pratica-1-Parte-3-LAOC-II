library verilog;
use verilog.vl_types.all;
entity mux2pra1 is
    port(
        a               : in     vl_logic_vector(11 downto 0);
        b               : in     vl_logic_vector(11 downto 0);
        sel             : in     vl_logic;
        DataOut         : out    vl_logic_vector(11 downto 0)
    );
end mux2pra1;
