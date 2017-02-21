# Roots

## Introduction

This gem provides two methods `root` and `roots` which will find all the nth roots of real and complex values.

For details on the mathematical foundation and implementation details see my paper:

`Roots in Ruby`

https://www.scribd.com/doc/60067570/Roots-in-Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'roots'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roots

Then require as:

    require 'roots'
    
## Description

Starting with Roots 2.0.0 (2017-2-21) the methods **iroot2** and **irootn** were added.
They are instance_methods of **class Integer** that will accurately compute the exact real value 
squareroot and nth_root for arbitrary sized integers.

If you have an application where you need the exact correct integer real value for roots,
especially for arbitrary sized (large) integers, use these methods instead of **root|s**.
These methods work strictly in the integer domain, and do not first create floating point
approximations of these roots and then convert them to integers.

They are useful for applications in pure math, Number Theory, Cryptography, etc, where you
need to find the exact real integer roots of polynomials, encryption functions, etc.

The methods **root** and **roots** work for all the **Numeric** classes (integers, floats,
complex, rationals), and produce floating point results.  They, thus, produce floating
point approximations to the exact **Integer** values for real roots for arbitrary sized integers.

## Usage

**iroot2**
```
Use syntax:  ival.iroot2
Return the largest Integer +root+ of Integer ival such that root**2 <= ival
A negative ival will result in 'nil' being returned.

 9.iroot2 => 3
-9.iroot2 => nil

120.iroot2 => 10
121.iroot2 => 11
121.iroot2.class => Integer

(10**10).iroot2 => 100000
(10**10).root(2) => 100000.0
(10**10).roots(2)[0] => 100000.0+0.0i

(10**11).iroot2 => 316227
(10**11).root(2) => 316227.76601684
(10**11).roots(2)[0] => 316227.76601684+0.0i

(10**110).iroot2 => 10000000000000000000000000000000000000000000000000000000
(10**110).root(2) => 1.0e+55
(10**110).roots(2)[0] => 1.0e+55+0.0i

(10**111).iroot2 => 31622776601683793319988935444327185337195551393252168268
(10**111).root(2) => 3.1622776601683795e+55
(10**111).roots(2)[0] => 3.1622776601683795e+55+0.0i
```

**irootn**
```
Use syntax:  ival.irootn(n), where n is an Integer > 1
Return the largest Integer +root+ of Integer ival such that root**n <= ival
A negative ival for an even root n will result in 'nil' being returned.

81.irootn(2) => 9
81.irootn(3) => 4
81.irootn(4) => 3
81.irootn(4).class => Integer

-81.irootn(3) => -4
-81.irootn(4) => nil

100.irootn 4.5 => RuntimeError: root n is < 2 or not an Integer
100.irootn -2  => RuntimeError: root n is < 2 or not an Integer

(10**110).irootn(2) => 10000000000000000000000000000000000000000000000000000000 
(10**110).irootn(3) => 4641588833612778892410076350919446576 
(10**110).irootn(4) => 3162277660168379331998893544 
(10**110).irootn(5) => 10000000000000000000000 
(10**110).irootn(6) => 2154434690031883721 
(10**110).irootn(7) => 5179474679231211 
(10**110).irootn(8) => 56234132519034 
(10**110).irootn(9) => 1668100537200 
(10**110).irootn 10 => 100000000000
```

**root**
```
Use syntax:  val.root(n,{k})
root(n,k=0) n is root 1/n exponent,  integer > 0 
            k is nth ccw root 1..n , integer >=0
If k not given default root returned, which are:
for +val => real root  |val**(1.0/n)|
for -val => real root -|val**(1.0/n)| when n is odd
for -val => first ccw complex root    when n is even

9.root(2) => 3.0
-32.root(5,3) => (-2.0+0.0i)
73.root 6 => 2.04434322
73.root 6,1 => (2.04434322+0.0i)
(-100.43).root 6,6 => (1.86712994-1.07798797i)
Complex(3,19).root 7,4 => (-1.47939161+0.37266673i)
```

**roots**
```
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
For Ruby >= 1.9 can also use a symbol as option: 384.roots 4,:r

Can ask: How many complex roots of x: x.roots(n,'c').size
What's the 3rd 5th root of (4+9i): Complex(4,9).root(5,3)

8.roots 3 => [(2.0+0.0i), (-1.0+1.73205081i), (-1.0-1.73205081i)]
```

**Roots.digits_to_show**
```
With version 1.1.0 this method was added to allow users to set
and see the number of decimal digits displayed. If no input is
given, the number of digits previously set is shown. The default
value is 8. Providing an input value sets the number of digits to
display. An input value < 1 will be set to a value of 1, to
display at least one decimal digit. An input greater than the
maximum digits shown for a given Ruby will display that maximum.


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
```

## Mathematical Foundations

```
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

Thus, there are n distinct roots (values).

For integer numbers:

For binary based (digital) computers (cpu), all integers are represented as
binary numbers. To find the root 'n' of an integer 'num' we can use the following
process to find the largest integer nth 'root' such that root**n <= num.

For an integer composed of 'b' bits an nth root 'n' will have at most (b/n + 1) bits.

For squareroots n = 2:
For 9 = 0b1001, it has b = 4 bits, and its squareroot has at most (4/2 + 1) = 3 bits.
The squareroot of 9 is 3 = 0b11, which is 2 bits.

For 100 = 0b1100100, b = 7, and its squareroot has at most (7/2 + 1) = 4 bits.
The squareroot of 100 is 10 = 0b1010, which is 4 bits.

For cuberoots n = 3:
For 8 = 0b1000, it has b = 4 bits, and its cuberoot has at most (4/3 + 1) = 2 bits.
The cuberoot of 8 is 2 = 0b10, which is 2 bits.

For 125 = 0b1111101, b = 7, and its cuberoot has at most (7/3 + 1) = 3 bits.
The cuberoot of 125 is 5 = 0b101, which is 3 bits.

Algorithm:
           bits_shift = (num.bit_length)/n + 1  # determine max number of root bits
           bitn_mask = 1 << bits_shift           # set value for max bit position of root
           root = 0                              # initialize the value for root
           until bitn_mask == 0                  # step through all the bit positions for root
             root |= bitn_mask                   # set current bit position to '1' in root
             root ^= bitn_mask if root**n > num  # set it back to '0' if root too large
             bitn_mask >>= 1                     # set bitn_mask to next smaller bit position
           end
           root                                  # return exact integer value for root
```
## Author
Jabari Zakiya

## License
GPLv2+
