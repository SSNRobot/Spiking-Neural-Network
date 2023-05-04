-- Author: Phillip Salowe
-- Revision: 3/23/2023
-- Description:
-- 	Takes the spike count from the SNN as an input and calculates motor
-- 	duty cycle count used by the motor driver block.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DutyCycle_Calculator is
 
   port( count : in std_logic_vector (9 downto 0);   -- input spike count
         DC : out std_logic_vector(13 downto 0));     -- output frequency

end DutyCycle_Calculator;

architecture sequential of DutyCycle_Calculator is

    signal A, B: INTEGER;

begin
    A <= to_integer(unsigned(count));   -- convert the input bit vector to an integer representation

    B <= (((242831 * A) / 3000000) + 15) * 50;  -- convert the integer for spike count into a frequency

    DC <= std_logic_vector(to_unsigned(B, 14));  -- convert the integer version of a frequency to a bit vector
	 
end sequential; 
