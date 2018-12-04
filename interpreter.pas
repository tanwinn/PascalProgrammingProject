program interpreter;
{**
	Thanh Nguyen & Jemal Jemal
	Interpreter for Racket String
} 
type
	stringArray = array [0..2] of string;

function logicInterpret(expr: string): boolean; forward;
function argToInt(arg: string): integer; forward;
function symInterpret(expr: string): longint; forward;
function argToBool(arg: string): boolean; forward;

{=============== *Begin Error handling & validate functions* ==================}

function emptyParser(): stringArray;
{** Output an empty parser}
var 
	i: integer;
begin
	for i:=0 to 2 do
		emptyParser[i]:='';
end;

procedure error(message: string);
{** Display error message then terminate the program}
begin
	write('ERROR: ');
	writeln(message);
	writeln('Press enter to exit the program...');
	readln();
	halt();
end;

procedure validateParser(parser: stringArray);
var
	i: integer;
begin
	for i:=0 to 2 do
		if (parser[i]='') then
			error('Parsing error. Check your input.');
end;

function isAtom(expr: string): integer;
{** Classify the expression
	Input: a string-type expression
	Output: int code: int: 1, bool: 0, non-atom: -1 }	
var
	iNum, code: integer;
begin
	Val(expr, iNum, code);
	// expr is an int, return 1
	if code = 0 then
		isAtom := 1
	// expr is a boolean, return 0
	else if (expr[code] = '#') and ((expr[code+1] = 't') or (expr[code+1] = 'f')) then
		isAtom := 0
	// expr is not an atom, return -1
	else
		isAtom := -1; 
end;

function isLogicExpr(expr: string): boolean;
{** Classify the non-atom expr
	Input: an expression, must not be an atom, else error
	Output: true if expr is logic expr, false if expr is symExpr}
var
	i: integer;
begin
	i:=1;
	while (expr[i]='(') do
		i:=i+1;
	if ((expr[i+1] = 'a') and (expr[i] = 'n')) or ((expr[i] = 'o') and (expr[i+1] = 'r')) or (expr[i] = '=') then
		isLogicExpr:= true
	else if (expr[i] = '-') or (expr[i] = '+') or (expr[i] = '*')  then
		isLogicExpr:= false
	else 
		error('In isExpr: input is NOT an expression');
end;

{=============== *End Error handling & validate functions* ==================}

{=============== *Begin Converting functions* ==================}

function StrToInt(s: string): integer;
{** Input a string and return an integer}
var
	iNum: integer;
	code: integer;
begin
	if code = 0 then
	begin
		Val(s, iNum, code);
		StrToInt := iNum;
	end
	else
		error('PROGRAM ERROR in StrToInt: string is not a number');
end;

function IntToStr(num: integer): string;
var
	s: string;
begin
	Str(num, s);
	IntToStr := s;
end;

function argToInt(arg: string): integer;
{** convert argument to integer
	Input: string-type argument
	Output: either error if expr does not return int type
}
begin
	if (isAtom(arg)=-1) then
		argToInt := symInterpret(arg)
	else if (isAtom(arg)=1) then
		argToInt := StrToInt(arg)
	else
		error('Needs to be an integer or arithmetic expression');
end;

function argToBool(arg: string): boolean;
{** take an argument and compute it into a boolean
	if it's an boolean atom or = expr then evaluate it and return an boolean
	if it's a integer atom then error}
begin
	if (isAtom(arg)=-1) then
		argToBool := logicInterpret(arg)
	else if (isAtom(arg)=0) then
	begin
		if arg[2] = 't' then
			argToBool := true
		else
			argToBool := false;
	end
	else
		error('Needs to be an boolean or = expression');
end;

{=============== *End Converting functions* ==================}

{================== *Begin PARSER* =====================}

function logicParse(expr: string): stringArray;
{** Parser for logic functions: Equals, And, Or
		Logic Parser contains 3 elements: 
		sym, first arg, and second arg
	Input: string-type expression
	Output: parser-struct array of String
}

var
	i, iParser: integer;
	bracket: integer;
	tempExpr: string;
begin
	// clean up the parser
	logicParse := emptyParser();

	// clean up the bracket
	if (expr[1]='(') then 
	begin
		tempExpr := '';
		for i:=2 to length(expr)-1 do
			tempExpr:= tempExpr + expr[i];
		logicParse := logicParse(tempExpr);
		exit;
	end;
	
	// clean up the parser
	logicParse := emptyParser();

	iParser := 0; 
	bracket:=0;
	i := 1;
	// start with the second char of expr 
	while (expr[i] <> ' ') and (i<=length(expr)) do
	begin
		if i > length(expr) then
			error('Logic parsing error. Check your input.');
		logicParse[iParser] := logicParse[iParser] + expr[i];
		i := i+1;
	end;

	iParser := iParser + 1;
	
	// start parsing the first and second arguments 
	// into logicParse[1] or [2]
	while ((i <= length(expr)) and (iParser <= 2)) do
	begin
		while ((expr[i] = '(') or (expr[i] = ' ')) do
		begin
			// if there is bracket, the expr is not an atom
			if (expr[i] = '(') then
				bracket:= bracket + 1;
			i := i + 1;
		end;

		while (i <= length(expr)) do
		begin		
			// count the bracket inside the expr
			if (expr[i] = '(') then
				bracket:= bracket + 1
			
			// if there's only one bracket at the start of the 
			// expr and we reach a closing bracket
			// it means that we finish this expression
			else if ((expr[i] = ')') and (bracket = 1)) then
			begin
				i := i+1;
				break;
			end
			
			// else if we reach a closing bracket but there're 
			// other brackets inside the expr, then we keep the loop
			// and deduct one closing bracket
			else if ((expr[i] = ')') and (bracket > 1)) then
				bracket := bracket - 1
			
			// if the expr is an atom 
			// then whitespace signals the expr is over
			else if ((expr[i] = ' ') and (bracket = 0)) then
			begin
				i := i+1;
				break;
			end;

			// parse the expr into the parser
			logicParse[iParser] := logicParse[iParser] + expr[i];
			i := i + 1;
		end;
		// go to the next parser element
		iParser := iParser+1;
		bracket := 0;
	end;

	validateParser(logicParse);
	
end;

// Parser for if statement
function ifParse(expr: string): stringArray;
var
	i, iParser: integer;
	bracket: integer;

// if statement always has three elements: 
// cond, tStatement, and fStatement
// parser into 3 parts	
begin
	
	// clean up the parser
	ifParse:= emptyParser();

	i := 4;
	iParser:= 0;
	bracket := 0;
	// (if #t 1 2)
	while ((i <= length(expr)-1) and (iParser <= 2)) do
	begin
		// ignore the ( or white space before cond
		while ((expr[i] = '(') or (expr[i] = ' ')) do
		begin
			// count brackets
			if (expr[i] = '(') then
				bracket:= bracket + 1;
			i := i + 1;
		end;
		
		// get the expr inside the bracket, 
		// or if it's an atom, looks for whitespace
		while (i <= length(expr)-1) do
		begin
		
			// count the bracket inside the expr
			if (expr[i] = '(') then
				bracket:= bracket + 1
			
			// if there's only one bracket at the start of the 
			// expr and we reach a closing bracket
			// it means that we are done with this expression
			else if ((expr[i] = ')') and (bracket = 1)) then
			begin
				i := i+1;
				break;
			end
			
			// else if we reach a closing bracket but there're 
			// other brackets inside the expr, then we keep the loop
			// and deduct one closing bracket
			else if ((expr[i] = ')') and (bracket > 1)) then
				bracket := bracket - 1
			
			// if the expr is an atom 
			// then whitespace signals that the expr is over
			else if ((expr[i] = ' ') and (bracket = 0)) then
			begin
				i := i+1;
				break;
			end;

			// parse the expr into the parser
			ifParse[iParser] := ifParse[iParser] + expr[i];
			i := i + 1;
		end;

		// go to the next parser element
		iParser := iParser+1;
		bracket := 0;
	end;
	
	validateParser(ifParse);
	
end;

function symParse(expr: string): stringArray;
{** Parser for arithmetic operations
	Input: a string-type expression
	Output: parser of +, -, or *
}
var 
	i, iParser: integer;

begin
	// clean up the parser
	symParse := emptyParser();

	i := 1;
	iParser := 0;

	while ((i<=length(expr)) and (expr[i]<>')') and (iParser<=2)) do
	begin
		while (expr[i] = '(') or (expr[i] = ' ') do
			i := i+1;

		while (expr[i] <> ' ') and (expr[i]<>')') and (i<=length(expr)) do
		begin
			symParse[iParser] := symParse[iParser] + expr[i];
			i := i+1;
		end;
		iParser := iParser + 1;
	end;

	validateParser(symParse);

end;

{================== *End PARSER* =====================}

{================== *Begin Interpret functions* =================}
function logicInterpret(expr: string): boolean;
{** Interpreter for logic operations: and, or, =
	Input: string-type expression
	Output: evaluated expression type boolean
}
var
	parser: stringArray;
begin
	parser := logicParse(expr);
	
	// parser[0] is operator
	// parser[1] and [2] are arguments
	case parser[0] of
		'=':
			begin
				if (argToInt(parser[1]) = argToInt(parser[2])) then
					logicInterpret := true
				else
					logicInterpret := false;
			end;
		'and':
			logicInterpret := (argToBool(parser[1]) and argToBool(parser[2]));
		'or':
			logicInterpret := (argToBool(parser[1]) or argToBool(parser[2]));
	end;
end;

function symInterpret(expr: string): longint;
{** Interpreter for arithmetic operations: +, -, *
	Input: string-type expression
	Output: evaluated expression type longint
}
var
	a, b: longint;
	parser: stringArray;
	sym: string;
begin
	parser := symParse(expr);
	
	sym:= parser[0];
	a := StrToInt(parser[1]);
	b := StrToInt(parser[2]);
	
	case sym of
		'+':
			begin
				symInterpret := a+b;
			end;
		'*':
			begin
				symInterpret := a*b;
			end;
		'-':
			begin
				// desugar
				b := StrToInt(parser[2]);
				parser[0]:= '+';
				parser[2]:= IntToStr(-1*b);
				expr := '(' + parser[0] + ' ' + parser[1] + ' ' + parser[2] + ')' ;
				
				// evluate the desugared expr	
				symInterpret := symInterpret(expr);
			end;
		else
			error('Invalid input.');
	end;
end;

{================== *End Interpret functions* ==================}

procedure interpreter(expr: string);
{** Main interpreter
	Input: string type Racket expression
	Output: evaluated expression if valid input
}
var
	cond: boolean;
	parser: stringArray;
begin
	// writeln('::DEBUG:: Interpreter input: ', expr);
	if (expr[2] = '-') or (expr[2] = '+') or (expr[2] = '*')  then
		writeln(argToInt(expr))
	
	else if (expr[2] = 'a') or (expr[2] = 'o') or (expr[2] = '=') then
		writeln(argToBool(expr))
	
	else if (expr[2] = 'i') then
	begin
		parser := ifParse(expr);
		case isAtom(parser[0]) of
			// cond is boolean
			0: cond := argToBool(parser[0]);
			// cond is integer --> always true
			1: cond := true;
			// cond is expr --> evaluate 
			-1: cond := argToBool(parser[0]);
		else
			error('::PROGRAM ERROR:: interpreter func');
		end;
		case cond of
			true:
				case isAtom(parser[1]) of
					// cond is boolean
					0: writeln(parser[1]);
					// cond is integer 
					1: writeln(parser[1]);
					// cond is expr
					-1: interpreter('(' + parser[1] + ')');	
				else
					error('::PROGRAM ERROR:: interpreter func');	
				end;
			false:
				case isAtom(parser[2]) of
					// cond is boolean
					0: writeln(parser[2]);
					// cond is integer 
					1: writeln(parser[2]);
					// cond is expr
					-1: interpreter('(' + parser[2] + ')');			
				else
					error('::PROGRAM ERROR:: interpreter func');	
				end;
		end;
	end
	else 
		if isAtom(expr)>=0 then
			writeln(expr)
		else if isLogicExpr(expr) then
			writeln(expr)
		else 
			error('Invalid input.');
end;

function args(): string;
{** Command-line input }
begin
	if ParamCount = 1 then
		args := ParamStr(1)
	else
		error('The program requires one argument of string type. For example: ./interpreter (string)');
end;

begin
	// interpreter('(+ 123 -23)');
	// interpreter('(- 0 23)');
	// interpreter('(- 23220 23221)');
	// interpreter('(* 0 2238923)');	
	// interpreter('(if (= 1 0) 1 (= 0 0))');
	// interpreter('(if (= (* 7 1) (+ 3 4)) 1 0)');
	// interpreter('(if (= (* 7 1) 0) 1 0)');
	// interpreter('(if (= 1 0) 1 0)');
	// interpreter('(if (= (- 2 2) 0) 1 0)');
	// interpreter('(if #f (+ 2 1) (or #t (= (+ 5 4) (* -3 1))))');
	// interpreter('(if #f 1 (+ 2 3))');
	// interpreter('(if (and #f #t) 1 (+ 2 1))');
	// interpreter('(or (= 2 3) #t)');
	// interpreter('(and (= (+ 0 0) (- 2 2)) #t)');
	// // writeln(IntToStr(-12));
	// interpreter('(or #t (= 5 1))');
	// interpreter('(or #t #f)');
	interpreter(args());
end.