# Pascal as a New Programming Language Project

__Project Name__: Pascal Programming 
__Authors__: Thanh Nguyen & Jemal Jemal
__Description__: A CSCI-222 Programming Language project that investigates Pascal as a programming language through research and software implementations. This README overviews the programs and their setting up process. 
__Url__: [Moodle](https://moodle-1819.wooster.edu/mod/assign/view.php?id=16923)

### Table of Contents
1. [Environment Set Up](#setup)
2. [Odd Factorial](#oddFact)  
3. [Tribonacci](#trib)  
4. [Racket Interpreter](#interp)  

### Environment Set Up
To install a FreePascal (FPC) compiler, folllow the installation guide in the paper.
After installing the FPC compiler, you can compile and run the programs.
FPC source code is under \*.PAS files. Pascal files need compiling before running.
To compile the files, navigate to the reposiory, and run `fpc  *.pas`. The compilation will result in an executable \*.EXE file as well as other neccessary files needed for the execution.

### Odd Factorial
<a name="oddFact"/>
Calculate the product of first N odd numbers.
To run the program, run `./factorialOdd <a non-negative integer N>`

### Tribonacci
<a name="trib"/>
Calculate the Nth Tribonacci number.
To run the program, run `./tribonacci <a positive integer N>`


### Racket Interpreter
<a name="interp"/>
Interpreter for Racket expression.
To run the program, run `./interpreter '<a valid string type Racket expression>'`

#### Valid input

#### Arithmetic Function Interpretation with *+*, *-*, and _*_

#### Logic Interpretation with *and*, *or*, & *=*

#### Error handling