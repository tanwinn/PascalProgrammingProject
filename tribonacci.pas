program tribonacci;
{
** Thanh Nguyen & Jemal Jemal
** Input an N postive integer
** Output Nth element in the Tribonacci sequence }

function trib(nterms: integer): longword;
{** 
	Input: integer
	Outout: nth term in the sequence
}
var
   trib1, trib2, trib0 : longword;
   temp : longword;
   count : integer;
 
begin
	// initalize variables
	count := 0;
	trib0 := 0;
	trib1 := 1;
	trib2 := 1;

	// base case
	if (nterms = 1) then
		trib := 0
	else if (nterms = 2) or (nterms = 3) then
		trib := 1
	else
		begin
			for count := 4 to nterms do
				begin
					// migrate trib to the next elem
					temp := trib2;
					trib2 := trib0 + trib1 + trib2;
					trib0 := trib1;
					trib1 := temp;
				end;
			trib := trib2;
		end;
end;

procedure error(message: string);
{** Display error message then terminate the program}
begin
	writeln(message);
	writeln('Exit the program');
	halt();
end;

function args(): integer;
{** Command-line input }
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
		error('The program requires one argument of integer type. For example: ./tribonacci <integer>');
end;

procedure validateArg(arg: integer);
{** Input validation}
begin
	if arg <= 0 then
		error('Invalid input');
end;

var
	arg: integer;
begin
	arg := args();
	validateArg(arg);
	writeln(trib(arg));
end.