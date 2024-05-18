library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;


entity SobelOperator is
Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        --sobel_out : out STD_LOGIC_VECTOR(1 to 6);
        segment_data : out STD_LOGIC_VECTOR(6 downto 1)
        --segment_enable : out STD_LOGIC
        );
end SobelOperator;




architecture Behavioral of SobelOperator is
         type matrix2 is array(1 to 3, 1 to 3) of INTEGER ;
         type matrix6 is array(1 to 6, 1 to 6) of INTEGER ;
			type matrixs is array(1 to 6, 1 to 6) of INTEGER;
    constant Gx : matrix2:= ((-1, 0, 1), (-2, 0, 2), (-1, 0, 1));
    constant Gy : matrix2:= ((-1, -2, -1), (0, 0, 0), (1, 2, 1));
         constant pixel_in: matrix6 :=((255,255,0,0,255,255),(255,255,0,0,255,255),(0,0,0,0,0,0),(0,0,0,0,0,0),(255,255,0,0,255,255),(255,255,0,0,255,255)); -- we need to change the values

    signal gradient_x, gradient_y : integer;
    signal sobel_result : matrix6;
signal sobel_out: matrixs ; 

    constant threshold_value : integer := 100; -- we need to change
begin
    process(clk, rst)
    begin
        --if rst = '1' then
        --    sobel_out <= (others => (others => 0));
        --                        segment_data <= (others => '0');
        --    segment_enable <= '0';
        --els
  if rising_edge(clk) then
            for i in 1 to 6 loop
                for j in 1 to 6 loop
                    if i=1 and j=1 then
                        gradient_x <=
                            (pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3) +
                             pixel_in(i+1, j) * Gx(3, 2) + pixel_in(i+1, j+1) * Gx(3, 3));

                        gradient_y <=
                            (pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3) +
                             pixel_in(i+1, j) * Gy(3, 2) + pixel_in(i+1, j+1) * Gy(3, 3));

                        elsif i=1 and j=6 then
                        gradient_x <=
                            (pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2) +
                             pixel_in(i+1, j-1) * Gx(3, 1) + pixel_in(i+1, j) * Gx(3, 2));

                        gradient_y <=
                            (pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2) +
                             pixel_in(i+1, j-1) * Gy(3, 1) + pixel_in(i+1, j) * Gy(3, 2));
                        elsif i=6 and j=1 then
                        gradient_x <=
                            (pixel_in(i-1, j) * Gx(1, 2) + pixel_in(i-1, j+1) * Gx(1, 3) +
                             pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3));

                        gradient_y <=
                            (pixel_in(i-1, j) * Gy(1, 2) + pixel_in(i-1, j+1) * Gy(1, 3) +
                             pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3));
                                             elsif i=6 and j=6 then
                        gradient_x <=
                            (pixel_in(i-1, j-1) * Gx(1, 1) + pixel_in(i-1, j) * Gx(1, 2) +
                             pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2));

                        gradient_y <=
                            (pixel_in(i-1, j-1) * Gy(1, 1) + pixel_in(i-1, j) * Gy(1, 2) + 
                             pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2));
                    elsif i = 1 then
                        gradient_x <=
                            (pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3) +
                             pixel_in(i+1, j-1) * Gx(3, 1) + pixel_in(i+1, j) * Gx(3, 2) + pixel_in(i+1, j+1) * Gx(3, 3));

                        gradient_y <=
                            (pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3) +
                             pixel_in(i+1, j-1) * Gy(3, 1) + pixel_in(i+1, j) * Gy(3, 2) + pixel_in(i+1, j+1) * Gy(3, 3));
                    elsif i = 6 then
                        gradient_x <=
                            (pixel_in(i-1, j-1) * Gx(1, 1) + pixel_in(i-1, j) * Gx(1, 2) + pixel_in(i-1, j+1) * Gx(1, 3) +
                             pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3));

                        gradient_y <=
                            (pixel_in(i-1, j-1) * Gy(1, 1) + pixel_in(i-1, j) * Gy(1, 2) + pixel_in(i-1, j+1) * Gy(1, 3) +
                             pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3));
                    elsif j=1 then
                        gradient_x <=
                            (pixel_in(i-1, j) * Gx(1, 2) + pixel_in(i-1, j+1) * Gx(1, 3) +
                             pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3) +
                             pixel_in(i+1, j) * Gx(3, 2) + pixel_in(i+1, j+1) * Gx(3, 3));
                        gradient_y <=
                            (pixel_in(i-1, j) * Gy(1, 2) + pixel_in(i-1, j+1) * Gy(1, 3) +
                             pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3) +
                             pixel_in(i+1, j) * Gy(3, 2) + pixel_in(i+1, j+1) * Gy(3, 3));
                    elsif j=6 then
                        gradient_x <=(pixel_in(i-1, j-1) * Gx(1, 1) + pixel_in(i-1, j) * Gx(1, 2) +
                             pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2) +
                             pixel_in(i+1, j-1) * Gx(3, 1) + pixel_in(i+1, j) * Gx(3, 2));

                        gradient_y <= (pixel_in(i-1, j-1) * Gy(1, 1) + pixel_in(i-1, j) * Gy(1, 2)  +
                             pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2) + 
                             pixel_in(i+1, j-1) * Gy(3, 1) + pixel_in(i+1, j) * Gy(3, 2) );
                    else
                        gradient_x <= (pixel_in(i-1, j-1) * Gx(1, 1) + pixel_in(i-1, j) * Gx(1, 2) + pixel_in(i-1, j+1) * Gx(1, 3) +
                             pixel_in(i, j-1) * Gx(2, 1) + pixel_in(i, j) * Gx(2, 2) + pixel_in(i, j+1) * Gx(2, 3) +
                             pixel_in(i+1, j-1) * Gx(3, 1) + pixel_in(i+1, j) * Gx(3, 2) + pixel_in(i+1, j+1) * Gx(3, 3));

                        gradient_y <= (pixel_in(i-1, j-1) * Gy(1, 1) + pixel_in(i-1, j) * Gy(1, 2) + pixel_in(i-1, j+1) * Gy(1, 3) +
                             pixel_in(i, j-1) * Gy(2, 1) + pixel_in(i, j) * Gy(2, 2) + pixel_in(i, j+1) * Gy(2, 3) +
                             pixel_in(i+1, j-1) * Gy(3, 1) + pixel_in(i+1, j) * Gy(3, 2) + pixel_in(i+1, j+1) * Gy(3, 3));
                    end if;

                    sobel_result(i, j) <= abs(gradient_x) + abs(gradient_y);
                end loop;
            end loop;

            for i in 1 to 6 loop
                for j in 1 to 6 loop
                    if sobel_result(i, j) > threshold_value then
                        sobel_out(i, j) <= 1;
                    else
                        sobel_out(i, j) <= 0;
                    end if;
                end loop;
            end loop;
            --if segment_enable = '0' then
             --for j in 1 to 7 loop
               --    segment_data(j) <= sobel_out(1, j);
             --end loop;
              --  segment_enable <= '1';
            --else
               -- segment_enable <= '0';
            --end if;
        end if;
    end process;

end Behavioral;