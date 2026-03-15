library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

package	misc is

	function log2 (x : positive) return natural;

end misc;

package body misc is 

	function log2 (x : positive) return natural is
		variable i : natural;
	begin
		i := 0;
		while (2**i < x) and i < 31 loop
			i := i+1;
		end loop;
		return i;
	end function;

end misc;
