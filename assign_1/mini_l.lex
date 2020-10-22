/*
 * Description: Read and identify keywords from a given min file
 */

%{
#include <math.h>
#include <unistd.h>
%}

ID [a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]
NUM [0-9]+
INVALID_ID_1 [0-9_]{ID}
INVALID_ID_2 [a-zA-Z][a-zA-Z0-9_]*

	int num_lines = 1, num_chars = 0;
%%
" "|"\t"	//do nothing
"//".*		//do nothing
"##".*		//do nothing
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]	//do nothing
\n		++num_lines; num_chars = 0;
function	printf("FUNCTION\n"); ++num_chars;
beginparams	printf("BEGIN_PARAMS\n"); ++num_chars;
endparams 	printf("END_PARAMS\n"); ++num_chars;
beginlocals	printf("BEGIN_LOCALS\n"); ++num_chars;
endlocals	printf("END_LOCALS\n"); ++num_chars;
beginbody	printf("BEGIN_BODY\n"); ++num_chars;
endbody		printf("END_BODY\n"); ++num_chars;
integer		printf("INTEGER\n"); ++num_chars;
array		printf("ARRAY\n"); ++num_chars;
of		printf("OF\n"); ++num_chars;
if		printf("IF\n"); ++num_chars;
then		printf("THEN\n"); ++num_chars;
endif		printf("ENDIF\n"); ++num_chars;
else		printf("ELSE\n"); ++num_chars;
while		printf("WHILE\n"); ++num_chars;
do		printf("DO\n"); ++num_chars;
for		printf("FOR\n"); ++num_chars;
beginloop	printf("BEGINLOOP\n"); ++num_chars;
endloop		printf("ENDLOOP\n"); ++num_chars;
continue	printf("CONTINUE\n"); ++num_chars;
read		printf("READ\n"); ++num_chars;
write		printf("WRITE\n"); ++num_chars;
and		printf("AND\n"); ++num_chars;
or		printf("OR\n"); ++num_chars;
not		printf("NOT\n"); ++num_chars;
true		printf("TRUE\n"); ++num_chars;
false		printf("FALSE\n"); ++num_chars;
return		printf("RETURN\n"); ++num_chars;
"-"		printf("SUB\n"); ++num_chars;
"+"		printf("ADD\n"); ++num_chars;
"*"		printf("MULT\n"); ++num_chars;
"/"		printf("DIV\n"); ++num_chars;
"%"		printf("MOD\n"); ++num_chars;
"<="		printf("LTE\n"); ++num_chars;
">="		printf("GTE\n"); ++num_chars;
">"		printf("GT\n"); ++num_chars;
"<"		printf("LT\n");	++num_chars;
"=="		printf("EQ\n");	++num_chars;
{ID}		printf("IDENT %s\n", yytext); ++num_chars;
{NUM}		printf("NUMBER %d\n", atoi(yytext)); ++num_chars;
{INVALID_ID_1}	printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_chars, yytext); ++num_chars;
{INVALID_ID_2}	printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", num_lines, num_chars, yytext); ++num_chars; 
";"		printf("SEMICOLON\n"); ++num_chars;
":"		printf("COLON\n"); ++num_chars;
","		printf("COMMA\n"); ++num_chars;
"("		printf("L_PAREN\n"); ++num_chars;
")"		printf("R_PAREN\n"); ++num_chars;
"["		printf("L_SQUARE_BRACKET\n"); ++num_chars;
"]"		printf("R_SQUARE_BRACKET\n"); ++num_chars;
:=		printf("ASSIGN\n"); ++num_chars;
.		printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_chars, yytext); ++num_chars;
%%

main()
{
	yylex();
}
