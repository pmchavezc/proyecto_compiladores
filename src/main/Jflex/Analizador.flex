package org.example;

import java_cup.runtime.Symbol;
import java.io.PrintWriter; // Asegúrate de que esta importación está fuera del %{ %}

%%
/*
*/

%class lexicoAnalizador
%public
%unicode
%line
%column
%eofval{
    return new Symbol(sym.EOF, yyline, yycolumn);
%eofval}

%{
private PrintWriter errorPrintWriter;

    // Constructor para JFlex que permite pasar un PrintWriter
    public lexicoAnalizador(java.io.Reader in, PrintWriter errorWriter) {
        this(in); // Llama al constructor por defecto de JFlex
        this.errorPrintWriter = errorWriter;
    }

    // Método para reportar errores léxicos
    public void reportLexicalError(String message) {
        if (errorPrintWriter != null) {
            errorPrintWriter.println("Error léxico: " + message + " en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
        } else {
            System.err.println("Error léxico: " + message + " en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
        }
    }
%}

%cup


LETTER = [a-zA-Z\u00C0-\u017F_] // Letras latinas con y sin tilde, ñ, etc. (ajusta el rango si necesitas más)
DIGIT = [0-9]
IDENTIFIER_CHAR = {LETTER} | {DIGIT}

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
{DIGIT}+                   { return new Symbol(sym.NUMERO, yyline, yycolumn, new Integer(yytext())); }
{DIGIT}+"."{DIGIT}+        { return new Symbol(sym.FLOTANTE, yyline, yycolumn, new Float(yytext())); }
\" ([^\"\n\r\\] | \\. )* \" { return new Symbol(sym.CADENA, yyline, yycolumn, yytext().substring(1, yytext().length()-1)); }
// La definición de IDENTIFICADOR ahora usa {LETTER} para incluir acentos y ñ
{LETTER}({IDENTIFIER_CHAR})* { return new Symbol(sym.IDENTIFICADOR, yyline, yycolumn, yytext()); }


// Comentarios de una sola línea (ignorar)
"//"[^\r\n]* { /* ignorar */ }

// Espacios y saltos de línea
[ \t\r\n]+          { /* ignorar espacios */ }

// Manejo de errores
.                   { reportLexicalError("Carácter no reconocido: '" + yytext() + "'"); }