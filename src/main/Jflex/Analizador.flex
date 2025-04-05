// codigo del usuario
package org.example;

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

%{
  // Código que sera utilizado
  public String lexema;
%}

%%

// Palabras reservadas
"IF"            { System.out.println("Reservada IF"); }
"ELSE"          { System.out.println("Reservada ELSE"); }
"ELSEIF"        { System.out.println("Reservada ELSEIF"); }
"WHILE"         { System.out.println("Reservada WHILE"); }
"LOOP"          { System.out.println("Reservada LOOP"); }
"END"           { System.out.println("Reservada END"); }
"DEFINE"        { System.out.println("Reservada DEFINE"); }
"PRINT"         { System.out.println("Reservada PRINT"); }
"RETURN"        { System.out.println("Reservada RETURN"); }
"FUNCTION"      { System.out.println("Reservada FUNCTION"); }

"INT"           { System.out.println("Tipo de dato INT"); }
"BOOLEAN"       { System.out.println("Tipo de dato BOOLEAN"); }
"FLOAT"         { System.out.println("Tipo de dato FLOAT"); }
"STRING"        { System.out.println("Tipo de dato STRING"); }

// Operadores aritméticos
"+"             { System.out.println("Operador +"); }
"-"             { System.out.println("Operador -"); }
"*"             { System.out.println("Operador *"); }
"/"             { System.out.println("Operador /"); }

// Operadores de comparación
"=="            { System.out.println("Operador =="); }
"!="            { System.out.println("Operador !="); }
">="            { System.out.println("Operador >="); }
"<="            { System.out.println("Operador <="); }
">"             { System.out.println("Operador >"); }
"<"             { System.out.println("Operador <"); }

// Operadores lógicos
"&&"            { System.out.println("Operador &&"); }
"||"            { System.out.println("Operador ||"); }
"!"             { System.out.println("Operador !"); }

// Asignación
"="             { System.out.println("Asignación ="); }

// Identificadores y literales
[0-9]+          { System.out.println("Número entero: " + yytext()); }
[0-9]+"."[0-9]+ { System.out.println("Número flotante: " + yytext()); }
\".*\"          { System.out.println("Cadena: " + yytext()); }
[a-zA-Z_][a-zA-Z0-9_]* { System.out.println("Identificador: " + yytext()); }

// Símbolos
"("             { System.out.println("Símbolo ("); }
")"             { System.out.println("Símbolo )"); }
"{"             { System.out.println("Símbolo {"); }
"}"             { System.out.println("Símbolo }"); }
";"             { System.out.println("Punto y coma"); }

// Espacios y saltos de línea
[ \t\r\n]+      { /* ignorar espacios */ }

// Manejo de errores
.               { System.out.println("Carácter no reconocido: " + yytext()); }
