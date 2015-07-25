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

## Usage

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
73.root 6 => 2.044343218831229
73.root 6,1 => (2.044343218831229+0.0i)
(-100.43).root 6,6 => (1.8671299361124354-1.0779879712265246i)
Complex(3,19).root 7,4 => (-1.4793916060223173+0.37266672915983323i)
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
```

**Mathematical Foundations**

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
```

## Author
Jabari Zakiya

## License
GPLv2+
