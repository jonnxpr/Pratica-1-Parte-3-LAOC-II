library verilog;
use verilog.vl_types.all;
entity cache is
    port(
        address         : in     vl_logic_vector(4 downto 0);
        clock           : in     vl_logic;
        wren            : in     vl_logic;
        dataIn          : in     vl_logic_vector(7 downto 0);
        dataOut         : out    vl_logic_vector(7 downto 0);
        hit             : out    vl_logic;
        miss            : out    vl_logic
    );
end cache;
