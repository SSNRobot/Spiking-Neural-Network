library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.ALL;


entity merge is
	
	
	
   port( 
	input1 : in std_logic_vector(9 downto 0);
	input2 : in std_logic_vector (2 downto 0);
   DC : out std_logic_vector (12 downto 0)
	);
		  
end merge;


architecture sequential of merge is

	

begin
 
	DC <=  input2 & input1;
	
end sequential;