%{
#include <stdio.h>
#include <string.h>
void yyerror(char *);
extern int yylex();
extern char *yytext;
extern FILE *yyin;
extern FILE *yyout;
char *array[1000];
char *arr[100];
char *idstr[100];
char *txt[100];
int i = 0;
int x = 0;
int y = 0;
int z = 0;
%}

%union
{
	char	*sval;
};

%token	<sval> BOOL
%token	<sval> MYNULL
%token	<sval> INTEGER
%token	<sval> FLOAT
%token	<sval> SCIENTIFIC
%token	<sval> LETTERS
%token	LCBRACKET
%token	RCBRACKET
%token	LSBRACKET
%token	RSBRACKET
%token	COMMA
%token	COLUMN
%token	AP


%start json

%%

json	: element
	;

value	: object
	| array	{ printf("\n"); }
	| string
	| number
	| BOOL	{ printf("%s\n", $1); }
	| MYNULL	{ printf("%s\n", $1); }
	;

element	: value
	;

object	: LCBRACKET members RCBRACKET
	| LCBRACKET RCBRACKET
	;

members	: member
	| member COMMA members
	;

member	: string COLUMN element
	;

array	: LSBRACKET elements RSBRACKET
	| LSBRACKET RSBRACKET
	;

elements	: element
		| element COMMA elements
		;

number	: INTEGER	{ printf("%s", $1); arr[x] = $1; x++;}
	| FLOAT	{ printf("%s\n", $1); }
	| SCIENTIFIC	{ printf("%s", $1); }
	;

string	: AP LETTERS AP	{ array[i] = $2;  printf("\"%s\"", $2);  if(i > 0){if(strcmp(array[i - 1], "text") == 0){txt[z] = $2; z++;if(strlen($2) > 140){yyerror("\nERROR text field over 140 characters"); YYERROR;}}} i++; }
	| AP INTEGER AP	{ printf("\"%s\"", $2); idstr[y] = $2; y++; }
	| AP AP	{ printf("\"\""); }
	;


%%


YYSTYPE yylval;
extern int linenum;
void yyerror(char *s){
	printf("Line %d: %s\n", linenum, s);
}

int main( int argc, char *argv[] ){

	if ( argc > 1 ){
	
		yyin = fopen(argv[1], "r");	
	}
	else{
		yyin = stdin;
	}
	yyout = fopen("output","w");
	yyparse();
	int token;

	int flag = 0;
	for(int j = 0; j < x; j++){
		
		for(int i = j + 1;i < x; i++){
			if(strcmp(arr[j],arr[i]) == 0){
				printf("ERROR id does not uniqe\n");
				flag = 1;
			}
		}
	}
	
	for(int j = 0; j < y; j++){
		
		for(int i = j + 1;i < y; i++){
			if(strcmp(idstr[j],idstr[i]) == 0){
				printf("ERROR id_str does not uniqe\n");
				flag = 1;

			}
		}
	}

	if(yylex() == 0 && flag == 0){
		printf("\nThe json source parsed whith no syntax errors\n");
	}

	/*puts("Do you want to retweet ? If yes press yes else no");
	char w[20];
	scanf("%s", w);
	char name[20];
	if(strcmp(w,"yes") == 0){
		printf("Give your screen name\n");
		scanf("%s", name);
		printf("{\n\t");
		printf("\"text\": \"%s\",\n\t", txt[0]);
		printf("\"user\":{\n\t\t");
		printf("\"screen_name\": \"%s\"\n\t}\n}\n",name);
	}*/
	
	return 0;
}
