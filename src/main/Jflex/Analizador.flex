package org.example;

import java_cup.runtime.Symbol;
import java.io.PrintWriter;

%%
%class lexicoAnalizador
%public
%unicode
%line
%column
%cup
%eofval{
    return new Symbol(sym.EOF, yyline, yycolumn);
%eofval}

%{
private PrintWriter errorPrintWriter;

public lexicoAnalizador(java.io.Reader in, PrintWriter errorWriter) {
    this(in);
    this.errorPrintWriter = errorWriter;
}

public void reportLexicalError(String message) {
    if (errorPrintWriter != null) {
        errorPrintWriter.println("Error léxico: " + message + " en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
    } else {
        System.err.println("Error léxico: " + message + " en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
    }
}
%}

LETTER = [a-zA-Z\u00C0-\u017F_]
DIGIT = [0-9]
IDENTIFIER_CHAR = {LETTER} | {DIGIT}

%%

"IF"              { return new Symbol(sym.IF, yyline, yycolumn); }
"ELSE"            { return new Symbol(sym.ELSE, yyline, yycolumn); }
"ELSEIF"          { return new Symbol(sym.ELSEIF, yyline, yycolumn); }
"WHILE"           { return new Symbol(sym.WHILE, yyline, yycolumn); }
"LOOP"            { return new Symbol(sym.LOOP, yyline, yycolumn); }
"END"             { return new Symbol(sym.END, yyline, yycolumn); }
"DEFINE"          { return new Symbol(sym.DEFINE, yyline, yycolumn); }
"PRINT"           { return new Symbol(sym.PRINT, yyline, yycolumn); }
"RETURN"          { return new Symbol(sym.RETURN, yyline, yycolumn); }
"FUNCTION"        { return new Symbol(sym.FUNCTION, yyline, yycolumn); }
"THEN"            { return new Symbol(sym.THEN, yyline, yycolumn); }
"DO"              { return new Symbol(sym.DO, yyline, yycolumn); }

"INT"             { return new Symbol(sym.TYPE_INT, yyline, yycolumn); }
"BOOLEAN"         { return new Symbol(sym.TYPE_BOOLEAN, yyline, yycolumn); }
"FLOAT"           { return new Symbol(sym.TYPE_FLOAT, yyline, yycolumn); }
"STRING"          { return new Symbol(sym.TYPE_STRING, yyline, yycolumn); }

"TRUE"            { return new Symbol(sym.TRUE, yyline, yycolumn); }
"FALSE"           { return new Symbol(sym.FALSE, yyline, yycolumn); }

"+"               { return new Symbol(sym.MAS, yyline, yycolumn); }
"-"               { return new Symbol(sym.MENOS, yyline, yycolumn); }
"*"               { return new Symbol(sym.MULTIPLICACION, yyline, yycolumn); }
"/"               { return new Symbol(sym.DIVISION, yyline, yycolumn); }

"=="              { return new Symbol(sym.IGUAL_IGUAL, yyline, yycolumn); }
"!="              { return new Symbol(sym.DIFERENTE, yyline, yycolumn); }
">="              { return new Symbol(sym.MAYOR_IGUAL, yyline, yycolumn); }
"<="              { return new Symbol(sym.MENOR_IGUAL, yyline, yycolumn); }
">"               { return new Symbol(sym.MAYOR, yyline, yycolumn); }
"<"               { return new Symbol(sym.MENOR, yyline, yycolumn); }

"&&"              { return new Symbol(sym.AND, yyline, yycolumn); }
"||"              { return new Symbol(sym.OR, yyline, yycolumn); }
"!"               { return new Symbol(sym.NOT, yyline, yycolumn); }

"="               { return new Symbol(sym.ASIGNACION, yyline, yycolumn); }
"("               { return new Symbol(sym.PARENTESIS_IZQ, yyline, yycolumn); }
")"               { return new Symbol(sym.PARENTESIS_DER, yyline, yycolumn); }
"{"               { return new Symbol(sym.LLAVE_IZQ, yyline, yycolumn); }
"}"               { return new Symbol(sym.LLAVE_DER, yyline, yycolumn); }
";"               { return new Symbol(sym.PUNTO_Y_COMA, yyline, yycolumn); }
","               { return new Symbol(sym.COMA, yyline, yycolumn); }

{DIGIT}+                   { return new Symbol(sym.NUMERO, yyline, yycolumn, new Integer(yytext())); }
{DIGIT}+"."{DIGIT}+        { return new Symbol(sym.FLOTANTE, yyline, yycolumn, new Float(yytext())); }
\" ([^\"\n\r\\] | \\. )* \" { return new Symbol(sym.CADENA, yyline, yycolumn, yytext().substring(1, yytext().length()-1)); }
{LETTER}({IDENTIFIER_CHAR})* { return new Symbol(sym.IDENTIFICADOR, yyline, yycolumn, yytext()); }

"//"[^\r\n]* { /* ignorar */ }
[ \t\r\n]+    { /* ignorar */ }
.             { reportLexicalError("Carácter no reconocido: '" + yytext() + "'"); }