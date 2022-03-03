# Lexical and Syntax Analyser for JSON with Flex and Bison

## Admissions
JSON String : Is a collection that consists of 0 or more UNICODE characters in
double quotes, it uses \ as escape characters.
    examples:
        ""
        "test"
        "info \"with quotes\""

JSON Number : Is like numbers in C or in JAVA instead of hexadecimal and octadecimal.
    examples:
        20     (integer)
        -20.50 (float)
        5.3e-3 (scientific notation)

JSON Array : Is a collection of values in order inside [ ] separated with , (comma)

Rules
    -"text" field must be 0 up to 140 characters
    -“user” field must contain a unique "id" ως positive integer and “name”, “screen_name”, “location” as strings .
    -“created_at” must have form “Day_name MMM DD XX:XX:XX YYYY” where Day_name = Δευτέρα, Τρίτη, κ.ο.κ., M = Month,
    D = Day, XX:XX:XX the form of timestamp and Y = Year.
    -“id_str” must be string and UNIQUE.

## Main files
JBNF.txt: This file contains the bnf grammar on which the parser rely on.
json.y  : This is the input file for Bison.
json.l  : This is the input file for Flex.

## Compile instructions
bison -y -d calc.y               : Produce y.tab.c and y.tab.h
flex calc.l                      : Produce lex.yy.c
gcc -c y.tab.c lex.yy.c          : Produce lex.yy.o and y.tab.o
gcc y.tab.o lex.yy.o -o parser   : Produce the parser executable

# Run parser
On terinal run
./parser json_file


## Examples

exam_files  : Directory containing json examples for the parser
|_ e.json   - A compete example that parsed succesfully, with the appropriate message.
|_ e1.json  - The same example but with a bracket removed at line 28. Parsing ends with message "Line 28: syntax error".
|_ e3.json  - A example with a text field over 140 characters. Parsing ends with "ERROR text field over 140 characters".
|_ e4.json  - This example contains two str_id fields with the same value. The output message is "ERROR id_str does not uniqe".
|_ e5.json  - Example that contains two id fields with the same value.
|_ ex2.txt  - JSON example in one line the parser outputs the example with the appropriate tabs.
|_ ex3.txt  - Another correct example.