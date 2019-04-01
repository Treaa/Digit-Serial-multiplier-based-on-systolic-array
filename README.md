# Digit-Serial-multiplier-based-on-systolic-array
The verilog implementation of digit-serial multiplier based on systolic array on GF(2^163) domain.

Including verilog src, testbench for functional simulation and SOC verification on FPGA.

# Algorithm for MSB-first Multiplication in GF(2^m)
Input: A(x), B(x), G(x)  
Output: P(x) = A(x)B(x)modG(x)
t(j,0)=0, 0<=j<=m-1
t(0,i)=0, 1<=i<=m-1
for i=1 to m do
	for j=m-1 to 0 do
      t(j,i) = t(m-1,i-1)g(j) + b(m-i)a(j) + t(j-1,i-1)
P(x) = T^m(x)
t(j,i) represents the jth coefficient of T^i, a(i), b(i), g(i) represent the ith coefficient of A(x), B(x), G(x) respectively.
		 
 
