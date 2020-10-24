/*
 * Description: Read and identify keywords from a given min file
 */

%{
#include <math.h>
#include <unistd.h>
%}

ID ([a-zA-Z]([a-zA-Z0-9_]*)([a-zA-Z]|[0-9]))|[a-zA-Z]
NUM [0-9]+
INVALID_ID_1 [0-9_]{ID}
INVALID_ID_2 [a-zA-Z]([a-zA-Z0-9_]*)

	int num_lines = 1, num_chars = 0;
%%
" "|"\t"	//do nothing
"//".*		//do nothing
"##".*		//do nothing
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]	//do nothing
\n		++num_lines; num_chars = 0;
function	printf("FUNCTION\n"); num_chars += yyleng;
beginparams	printf("BEGIN_PARAMS\n"); num_chars += yyleng;
endparams 	printf("END_PARAMS\n"); num_chars += yyleng;
beginlocals	printf("BEGIN_LOCALS\n"); num_chars += yyleng;
endlocals	printf("END_LOCALS\n"); num_chars += yyleng;
beginbody	printf("BEGIN_BODY\n"); num_chars += yyleng;
endbody		printf("END_BODY\n"); num_chars += yyleng;
beginprogram 	printf("BEGIN_PROGRAM\n"); num_chars += yyleng;
endprogram	printf("END_PROGRAM\n"); num_chars += yyleng;
integer		printf("INTEGER\n"); num_chars += yyleng;
array		printf("ARRAY\n"); num_chars += yyleng;
of		printf("OF\n"); num_chars += yyleng;
if		printf("IF\n"); num_chars += yyleng;
then		printf("THEN\n"); num_chars += yyleng;
endif		printf("ENDIF\n"); num_chars += yyleng;
else		printf("ELSE\n"); num_chars += yyleng;
while		printf("WHILE\n"); num_chars += yyleng;
do		printf("DO\n"); num_chars += yyleng;
for		printf("FOR\n"); num_chars += yyleng;
beginloop	printf("BEGINLOOP\n"); num_chars += yyleng;
endloop		printf("ENDLOOP\n"); num_chars += yyleng;
continue	printf("CONTINUE\n"); num_chars += yyleng;
read		printf("READ\n"); num_chars += yyleng;
write		printf("WRITE\n"); num_chars += yyleng;
and		printf("AND\n"); num_chars += yyleng;
or		printf("OR\n"); num_chars += yyleng;
not		printf("NOT\n"); num_chars += yyleng;
true		printf("TRUE\n"); num_chars += yyleng;
false		printf("FALSE\n"); num_chars += yyleng;
return		printf("RETURN\n"); num_chars += yyleng;
"-"		printf("SUB\n"); num_chars += yyleng;
"+"		printf("ADD\n"); num_chars += yyleng;
"*"		printf("MULT\n"); num_chars += yyleng;
"/"		printf("DIV\n"); num_chars += yyleng;
"%"		printf("MOD\n"); num_chars += yyleng;
"<="		printf("LTE\n"); num_chars += yyleng;
">="		printf("GTE\n"); num_chars += yyleng;
">"		printf("GT\n"); num_chars += yyleng;
"<"		printf("LT\n");	num_chars += yyleng;
"=="		printf("EQ\n");	num_chars += yyleng;
{ID}		printf("IDENT %s\n", yytext); num_chars += yyleng;
{NUM}		printf("NUMBER %d\n", atoi(yytext)); num_chars += yyleng;
{INVALID_ID_1}	printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_chars, yytext); num_chars += yyleng;
{INVALID_ID_2}	printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", num_lines, num_chars, yytext); num_chars += yyleng;
";"		printf("SEMICOLON\n"); num_chars += yyleng;
":"		printf("COLON\n"); num_chars += yyleng;
","		printf("COMMA\n"); num_chars += yyleng;
"("		printf("L_PAREN\n"); num_chars += yyleng;
")"		printf("R_PAREN\n"); num_chars += yyleng;
"["		printf("L_SQUARE_BRACKET\n"); num_chars += yyleng;
"]"		printf("R_SQUARE_BRACKET\n"); num_chars += yyleng;
:=		printf("ASSIGN\n"); num_chars += yyleng;
.		printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_chars, yytext); num_chars += yyleng;
%%

main()
{
	yylex();
}
