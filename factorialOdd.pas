program factorialOdd;
{**
	Thanh Nguyen & Jemal Jemal
	Calculate the Factorial of N odd numbers
}

function factTwoSteps(n: integer): longword;
{** 
	Input: positive integer n
	Output: a two-step factorial (n*(n-2)*(n-4)*...*1)
}
begin
    if (n <= 1) then
        factTwoSteps := 1
    else
		begin
		    factTwoSteps := n * factTwoSteps(n - 2);
		end;		
end;

function factOddNumbers(n: integer): longword;
{** 
	Input: positive integer n
	Output: the multiplication of n odd numbers starting from 1
}
begin
	if (n = 0) then
		factOddNumbers := 0
	else
		factOddNumbers := factTwoSteps((n*2)-1);
end;

procedure error(message: string);
{** Display error message then terminate the program }
begin
	writeln(message);
	writeln('Exit the program');
	halt();
end;

function args(): integer;
{** Command-line input}
var
	iNum, code: integer;
begin
	if ParamCount = 1 then
		begin
			Val(ParamStr(1), iNum, code);
			if code = 0 then
				args := iNum
			else
				error('Input is not an integer');
		end
	else
		error('The program requires one argument of integer type. For example: ./factorialOdd <integer>');
end;

procedure validateArg(arg: integer);
{** Input validation}
begin
	if arg < 0 then
		error('Invalid input');
end;


var
	arg: integer;
begin
	arg := args();
	validateArg(arg);
	writeln(factOddNumbers(arg));
end.