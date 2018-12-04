# Pascal as a New Programming Language Project

__Project Name__: Pascal Programming <br/>
__Authors__: Thanh Nguyen & Jemal Jemal <br/>
__Description__: A CSCI-222 Programming Language project that investigates Pascal as a programming language through research and software implementations. This README overviews the programs and their setting up process. <br/>
__Url__: [Moodle](https://moodle-1819.wooster.edu/mod/assign/view.php?id=16923) <br/>

### Table of Contents
1. [Environment Set Up](#setup)
2. [Odd Factorial](#oddFact)  
3. [Tribonacci](#trib)  
4. [Racket Interpreter](#interp)  

### Environment Set Up
<a name="setup"/>
To install a FreePascal (FPC) compiler, folllow the installation guide in the paper.
<br/>
After installing the FPC compiler, you can compile and run the programs.
<br/>
FPC source code is under \*.PAS files. Pascal files need compiling before running.
<br/>
To compile the files, navigate to the reposiory, and run ```fpc  *.pas```. The compilation will result in an executable \*.EXE file as well as other neccessary files needed for the execution.

### Odd Factorial
<a name="oddFact"/>
Calculate the product of first N odd numbers.
<br/>
To run the program, run  

```./factorialOdd <a non-negative integer N>```

### Tribonacci
<a name="trib"/>
Calculate the Nth Tribonacci number.
<br/>
To run the program, run 

```./tribonacci <a positive integer N>```


### Racket Interpreter
<a name="interp"/>
Interpreter for Racket expression.
<br/>
To run the program, run 

```./interpreter '<a valid string type Racket expression>'```

#### Valid input
The interpreter only deals with integers and booleans. In terms of functions, the interpreter evaluates arithmetic functions that outputs integers, logic functions that outputs booleans, and branching if statement. 
<br/>
Valid input ```./interpreter '1101'``` or ```./interpreter '#f'```
<br/>
Invalid input
```./interpreter 'a'``` or ```./interpreter```

### If statement
```
./interpreter '(if <condition> <true case> <false case>)'
```
The *if statement* take exactly three arguments: a condition, a true case, and false case. Condition accepts booleans, integers (which will always be evaluated as true), and other functions. 
<br/>
Valid input: ```./interpreter '(if (= 2 2) #t #f)'```
<br/>
Invalid input: ```./interpreter '(if (= 2 2) #f)'```

#### Arithmetic Function Interpretation with *+*, *-*, and _*_
Arithmetic functions take exactly two integer input arguments and output an integer. 
<br/>
Valid input: ```./interpreter '(+ 2 1222)'```
<br/>
Invalid input: ```./interpreter '(+ 2 (* 1 0))'```

#### Logic Interpretation with *and*, *or*, & *=*
Logic functions take exactly two arguments and output a boolean expression. 
<br/>
```or``` and ```and```'s take any kind of argument. Integer arguments are true. 
<br/>
```=```'s arguments must either be integer atoms or functions that return integers.
<br/>
Valid input: 
1. ```./interpreter '(= (- 2 2) 0)'```
2. ```./interpreter '(or (+ 2 3) #t)'```
3. ```./interpreter '(and (= (+ 0 0) (- 2 2)) #t)'```
<br/>
Invalid input: ```./interpreter '(= (+ 1 0) #t)'```

#### Error handling
Inputs that violate the above rules will not be accepted. Invalid input will result in an error message and program termination. Common errors are invalid numbers of arguments, invalid data types, etc.