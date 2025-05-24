package org.example;

import java_cup.runtime.Symbol; // Importar la clase Symbol de CUP

%%
/*
*/

%class lexicoAnalizador
%public
%unicode
%line
%column
%eofval{
    return new Symbol(sym.EOF, yyline, yycolumn); // Devuelve el token EOF al final del archivo con línea y columna
%eofval}

%{
%}

%cup

%%

// Palabras reservadas
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

"INT"             { return new Symbol(sym.TYPE_INT, yyline, yycolumn); }
"BOOLEAN"         { return new Symbol(sym.TYPE_BOOLEAN, yyline, yycolumn); }
"FLOAT"           { return new Symbol(sym.TYPE_FLOAT, yyline, yycolumn); }
"STRING"          { return new Symbol(sym.TYPE_STRING, yyline, yycolumn); }


// Literales booleanos
"TRUE"            { return new Symbol(sym.TRUE, yyline, yycolumn); }
"FALSE"           { return new Symbol(sym.FALSE, yyline, yycolumn); }


// Operadores aritméticos
"+"               { return new Symbol(sym.PLUS, yyline, yycolumn); }
"-"               { return new Symbol(sym.MINUS, yyline, yycolumn); }
"*"               { return new Symbol(sym.MULT, yyline, yycolumn); }
"/"               { return new Symbol(sym.DIV, yyline, yycolumn); }

// Operadores de comparación
"=="              { return new Symbol(sym.EQEQ, yyline, yycolumn); }
"!="              { return new Symbol(sym.NEQ, yyline, yycolumn); }
">="              { return new Symbol(sym.GTE, yyline, yycolumn); }
"<="              { return new Symbol(sym.LTE, yyline, yycolumn); }
">"               { return new Symbol(sym.GT, yyline, yycolumn); }
"<"               { return new Symbol(sym.LT, yyline, yycolumn); }

// Operadores lógicos
"&&"              { return new Symbol(sym.AND, yyline, yycolumn); }
"||"              { return new Symbol(sym.OR, yyline, yycolumn); }
"!"               { return new Symbol(sym.NOT, yyline, yycolumn); }

// Asignación
"="               { return new Symbol(sym.ASSIGN, yyline, yycolumn); }

// Símbolos
"("               { return new Symbol(sym.LPAREN, yyline, yycolumn); }
")"               { return new Symbol(sym.RPAREN, yyline, yycolumn); }
"{"               { return new Symbol(sym.LBRACE, yyline, yycolumn); }
"}"               { return new Symbol(sym.RBRACE, yyline, yycolumn); }
";"               { return new Symbol(sym.SEMICOLON, yyline, yycolumn); }
","               { return new Symbol(sym.COMMA, yyline, yycolumn); }
"THEN"            { return new Symbol(sym.THEN, yyline, yycolumn); }
"DO"              { return new Symbol(sym.DO, yyline, yycolumn); }


// Identificadores y literales
[0-9]+            { return new Symbol(sym.NUMERO, yyline, yycolumn, new Integer(yytext())); }
[0-9]+"."[0-9]+   { return new Symbol(sym.FLOTANTE, yyline, yycolumn, new Float(yytext())); }
\".*\"            { return new Symbol(sym.CADENA, yyline, yycolumn, yytext().substring(1, yytext().length()-1)); }
[a-zA-Z_][a-zA-Z0-9_]* { return new Symbol(sym.IDENTIFICADOR, yyline, yycolumn, yytext()); }

// Espacios y saltos de línea
[ \t\r\n]+        { /* ignorar espacios */ }

// Manejo de errores
.                 { System.err.println("Carácter no reconocido: '" + yytext() + "' en línea " + (yyline + 1) + ", columna " + (yycolumn + 1)); }