=begin
Author: Jabari Zakiya,   Original: 2009-12-25
Revision-2: 2009-12-31
Revision-3: 2010-6-2
Revision-4: 2010-12-15
Revision-5: 2011-5-11
Revision-6: 2011-5-15

Module 'Roots' provides two methods 'root' and 'roots'
which will find all the nth roots of real and complex
numerical values.

---------------
Install process:
Place module file 'roots.rb' into 'lib' directory of ruby
version. Then from irb session, or a source code file, do:

require 'roots'
or
require '/path_to/roots.rb'
---------------

Use syntax:  val.root(n,{k})
root(n,k=0) n is root 1/n exponent,  integer > 0 
            k is nth ccw root 1..n , integer >=0
If k not given default root returned, which are:
for +val => real root  |val**(1.0/n)|
for -val => real root -|val**(1.0/n)| when n is odd
for -val => first ccw complex root    when n is even

9.root(2); -32.root(5,3); (-100.43).root 6,6

Use syntax:  val.roots(n,{opt})
roots(n,opt=0) n is root 1/n exponent, integer > 0
               opt, optional string input, are:
   0   : default (no input), return array of n ccw roots
'c'|'C': complex, return array of complex roots
'e'|'E': even, return array even numbered roots
'o'|'O': odd , return array odd  numbered roots
'i'|'I': imag, return array of imaginary roots
'r'|'R': real, return array of real roots
An empty array is returned for an opt with no members.

9348134943.roots(9); -89.roots(4,'real'); 2.2.roots 3,'Im'
For Ruby 1.9.x can also use symbol as option: 384.roots 4,:r

Can ask: How many complex roots of x: x.roots(n,'c').size
What's the 3rd 5th root of (4+9i): Complex(4,9).root(5,3)

Use syntax:  Roots.digits_to_show
With gem version 1.1.0 this method was added to allow users to set
and see the number of decimal digits displayed. If no input is
given, the number of digits previously set is shown. The default
value is 8. Providing an input value sets the number of digits to
display. An input value < 1 will be set to a value of 1, to
display at least one decimal digit. An input greater than the
maximum digits shown for a given Ruby will display that maximum

Roots.digits_to_show => 8

10.root 5 => 1.58489319

Roots.digits_to_show 11 => 11

10.root 5 => 1.58489319246

Roots.digits_to_show 16 => 16

10.root 5 => 1.5848931924611136

Roots.digits_to_show 17 => 17

10.root 5 => 1.5848931924611136

Roots.digits_to_show 0 => 1

10.root 5 => 1.6
---------------

Mathematical Foundations

For complex number (x+iy) = a*e^(i*arg) = a*[cos(arg) + i*sin(arg)]

The root values of a number are:

1) root(n) = (x + iy)^(1/n)
2) root(n) = (a*e^(i*arg))^(1/n)
3) root(n,k) = (a*e^i*(arg + 2kPI))^(1/n)
4) root(n,k) = a^(1/n)*(e^i*(arg + 2kPI))^(1/n)
5) root(n,k) = |a^(1/n)|*e^i*(arg + 2kPI)/n
6) root(n,k) = |a^(1/n)|*(cos(arg/n+2kPI/n) + i*sin(arg/n+2kPI/n))
   define  mag = |a^(1/n)|, theta = arg/n, and delta = 2PI/n
7) root(n,k)= mag*[cos(theta + k*delta) + i*sin(theta + k*delta)], k=0..n-1

Thus, there are n distinct roots (values): 

---------------
Ruby currently gives incorrect values for x|y axis angles.
cos PI/2   =>  6.12303176911189e-17 
sin PI     =>  1.22460635382238e-16
cos 3*PI/2 => -1.83690953073357e-16  
sin 2*PI   => -2.44921970764475e-16

These all should be 0.0, which causes incorrect root values there.
I 'fix' these errors by setting aliases of sin|cos to 0.0 if the
absolute value of the other function equals 1.0 so they produce
the correct root values.
=end

# file roots.rb

module Roots
  require 'complex'
  include Math

  def root(n,k=0) # return kth (1..n) value of root n or default for k=0
    raise "Root  n not an integer >  0" unless n.kind_of?(Integer) && n>0
    raise "Index k not an integer >= 0" unless k.kind_of?(Integer) && k>=0
    return self if n == 1 || self == 0
    mag = abs**n**-1 ; theta = arg/n ; delta = 2*PI/n
    return rootn(mag,theta,delta,k>1 ? k-1:0) if kind_of?(Complex)
    return rootn(mag,theta,delta,k-1) if k>0 # kth root of n for any real
    return  mag.round(Roots.digits_to_show) if self > 0 # pos real default
    return -mag.round(Roots.digits_to_show) if n&1 == 1 # neg real default, n odd
    return rootn(mag,theta)    # neg real default, n even, 1st ccw root
  end

  def roots(n,opt=0) #  return array of root n values, [] if no value
    raise "Root n not an integer > 0" unless n.kind_of?(Integer) && n>0
    raise "Invalid option" unless opt == 0 || opt =~ /^(c|e|i|o|r|C|E|I|O|R)/
    return [self] if n == 1 || self == 0
    mag = abs**n**-1 ; theta = arg/n ; delta = 2*PI/n
    roots = []
    case opt
    when /^(o|O)/  # odd  roots 1,3,5...
      0.step(n-1,2) {|k| roots << rootn(mag,theta,delta,k)}
    when /^(e|E)/  # even roots 2,4,6...
      1.step(n-1,2) {|k| roots << rootn(mag,theta,delta,k)}
    when /^(r|R)/  # real roots     Complex(x,0) = (x+i0)
      n.times {|k| x=rootn(mag,theta,delta,k); roots << x if x.imag == 0}
    when /^(i|I)/  # imaginry roots Complex(0,y) = (0+iy)
      n.times {|k| x=rootn(mag,theta,delta,k); roots << x if x.real == 0}
    when /^(c|C)/  # complex  roots Complex(x,y) = (x+iy)
      n.times {|k| x=rootn(mag,theta,delta,k); roots << x if x.arg*2 % PI != 0} 
    else           # all n roots
      n.times {|k| roots << rootn(mag,theta,delta,k)}
    end
    return roots
  end

  private # not accessible as methods in mixin class
  # Alias sin|cos to fix C lib errors to get 0.0 values for X|Y axis angles.
  def sine(x);   cos(x).abs == 1 ? 0 : sin(x) end
  def cosine(x); sin(x).abs == 1 ? 0 : cos(x) end
  def self.digits_to_show(n = @digits_to_show || 8)
    @digits_to_show = n < 1 ? 1 : n 
  end

  def rootn(mag,theta,delta=0,k=0) # root k of n of real|complex
    angle_n = theta + k*delta
    x = mag*Complex(cosine(angle_n),sine(angle_n))
    Complex(x.real.round(Roots.digits_to_show), x.imag.round(Roots.digits_to_show))
  end
end

# Mixin 'root' and 'roots' as methods for all number classes.
class Numeric; include Roots end