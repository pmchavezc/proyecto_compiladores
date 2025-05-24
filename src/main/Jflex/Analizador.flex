// codigo del usuario
package org.example;

import java_cup.runtime.Symbol; // Importar la clase Symbol de CUP

%%
/*
opciones y declaraciones
*/

%class lexicoAnalizador
%standalone
%public
%unicode
%line
%column
%eofval{
    return new Symbol(sym.EOF); // Devuelve el token EOF al final del archivo
%eofval}

%{
  // Código que sera utilizado
  // public String lexema; // No es necesario si estás retornando Symbol
%}

%cup

%%

// Palabras reservadas
"IF"              { return new Symbol(sym.IF); }
"ELSE"            { return new Symbol(sym.ELSE); }
"ELSEIF"          { return new Symbol(sym.ELSEIF); }
"WHILE"           { return new Symbol(sym.WHILE); }
"LOOP"            { return new Symbol(sym.LOOP); }
"END"             { return new Symbol(sym.END); }
"DEFINE"          { return new Symbol(sym.DEFINE); }
"PRINT"           { return new Symbol(sym.PRINT); }
"RETURN"          { return new Symbol(sym.RETURN); }
"FUNCTION"        { return new Symbol(sym.FUNCTION); }

"INT"             { return new Symbol(sym.TYPE_INT); } // Añadimos tipos de datos para ser más explícitos
"BOOLEAN"         { return new Symbol(sym.TYPE_BOOLEAN); }
"FLOAT"           { return new Symbol(sym.TYPE_FLOAT); }
"STRING"          { return new Symbol(sym.TYPE_STRING); }


// Literales booleanos
"TRUE"            { return new Symbol(sym.TRUE); }
"FALSE"           { return new Symbol(sym.FALSE); }


// Operadores aritméticos
"+"               { return new Symbol(sym.PLUS); }
"-"               { return new Symbol(sym.MINUS); }
"*"               { return new Symbol(sym.MULT); }
"/"               { return new Symbol(sym.DIV); }

// Operadores de comparación
"=="              { return new Symbol(sym.EQEQ); }
"!="              { return new Symbol(sym.NEQ); }
">="              { return new Symbol(sym.GTE); }
"<="              { return new Symbol(sym.LTE); }
">"               { return new Symbol(sym.GT); }
"<"               { return new Symbol(sym.LT); }

// Operadores lógicos
"&&"              { return new Symbol(sym.AND); }
"||"              { return new Symbol(sym.OR); }
"!"               { return new Symbol(sym.NOT); }

// Asignación
"="               { return new Symbol(sym.ASSIGN); }

// Símbolos
"("               { return new Symbol(sym.LPAREN); }
")"               { return new Symbol(sym.RPAREN); }
"{"               { return new Symbol(sym.LBRACE); } // Añadimos llaves si se van a usar en la gramática
"}"               { return new Symbol(sym.RBRACE); } // Añadimos llaves
";"               { return new Symbol(sym.SEMICOLON); }
","               { return new Symbol(sym.COMMA); }
"THEN"            { return new Symbol(sym.THEN); }
"DO"              { return new Symbol(sym.DO); }


// Identificadores y literales
[0-9]+            { return new Symbol(sym.NUMERO, new Integer(yytext())); }
[0-9]+"."[0-9]+   { return new Symbol(sym.FLOTANTE, new Float(yytext())); }
\".*\"            { return new Symbol(sym.CADENA, yytext().substring(1, yytext().length()-1)); } // Remueve las comillas
[a-zA-Z_][a-zA-Z0-9_]* { return new Symbol(sym.IDENTIFICADOR, yytext()); }

// Espacios y saltos de línea
[ \t\r\n]+        { /* ignorar espacios */ }

// Manejo de errores
.                 { System.err.println("Carácter no reconocido: " + yytext() + " en línea " + yyline + ", columna " + yycolumn); }