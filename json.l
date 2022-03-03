%{
#include "y.tab.h"
int linenum = 1;
int count = 0;
int arcount = 0;
int flagcomma = 0;
%}

%option noyywrap

ws	[ \t\n]+
bool "true"|"false"
sign	"+"|"-"
digit	[0-9]
digit19	[1-9]
digits	{digit}+
integer	{sign}?{digit}|{sign}?{digit19}{digits}
float	{integer}"."{digits}
scientific	{integer}(".")?{digits}("e"|"E"){sign}{digit19}({digits}|"")
letter	[a-zA-Z0-9]|"\\"{escape}|{symbols}|[ \t]
letters	{letter}+
escape	\\|\/|b|n|r|t|u{hex}{hex}{hex}
hex	{digit}|[a-f]|[A-F]
symbols	\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\_|\+|\-|\'|\\|\?|\<|\>|\.|[a-zA-Z0-9]:|[a-zA-Z],
number	{integer}|{float}|{scientific}

%%

{ws}	{/*ignore*/}

{bool}	{ yylval.sval = malloc(strlen(yytext));
	  strncpy(yylval.sval, yytext, strlen(yytext)); return BOOL; }
"null"	{ yylval.sval = malloc(strlen(yytext));
	  strncpy(yylval.sval, yytext, strlen(yytext)); return MYNULL; }

{integer}	{ yylval.sval = malloc(strlen(yytext));
	  	  strncpy(yylval.sval, yytext, strlen(yytext)); return INTEGER; }

{float}	{ yylval.sval = malloc(strlen(yytext));
	  	  strncpy(yylval.sval, yytext, strlen(yytext)); return FLOAT; }

{scientific}	{ yylval.sval = malloc(strlen(yytext));
	  	  strncpy(yylval.sval, yytext, strlen(yytext)); return SCIENTIFIC; }

{letters}	{ yylval.sval = malloc(strlen(yytext));
	  	  strncpy(yylval.sval, yytext, strlen(yytext)); return LETTERS; }


"{"	{ count++; if(count == 1 && arcount == 0){ printf("{\n\t"); linenum++;}else{printf("{\n");linenum++;for(int i = 0; i <= count + arcount; i++){printf("\t");}} return LCBRACKET; }
"}"	{ if(count == 1 && arcount == 0){printf("\n}");linenum++;}else{printf("\n");linenum++; for(int i = 0; i < count -1 + arcount + (arcount == 1); i++){printf("\t");}printf("}");if(flagcomma == 1){flagcomma = 0;}else{printf("\n");linenum++;}} count--; return RCBRACKET; }
"["	{ arcount++; if(count == 0 && arcount == 1){ printf("[\n\t");linenum++;}else{printf("[\n");linenum++;for(int i = 0; i <= count + arcount; i++){printf("\t");}} return LSBRACKET; }
"]"	{ if(count == 0 && arcount == 1){printf("\n]");linenum++;}else{printf("\n");linenum++; for(int i = 0; i < count -1 + arcount + (arcount == 1); i++){printf("\t");}printf("]");if(flagcomma == 1){flagcomma = 0;}else{printf("\n");linenum++;}} arcount--; return RSBRACKET; }
","	{ flagcomma = 1; if(count == 1){ printf(",\n\t");linenum++;}else{printf(",\n");linenum++;for(int i = 0; i <= count; i++){printf("\t");}} return COMMA; }
":"	{ printf(": "); return COLUMN; }
"\""	{ return AP; }
.	{}

%%
