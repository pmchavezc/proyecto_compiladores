package org.example;

import java_cup.runtime.Symbol;
import java.io.FileReader;
import java.io.StringReader;

public class Main {
    public static void main(String[] args) {
        try {
            //se define un codigo de prueba que sera analizado lexica y sintacticamente
            String codeToTest = "DEFINE x = 10;\n" +
                                "IF x > 5 THEN PRINT \"x es mayor que 5\"; END\n" +
                                "FUNCTION myFunc (a, b) PRINT a + b; END";

            // Creamos el lexer (analizador léxico) utilizando el código de prueba como fuente.
            // StringReader simula la entrada de texto como si fuera un archivo.
            lexicoAnalizador lexer = new lexicoAnalizador(new StringReader(codeToTest));
            //creamos un parser (analizador sintáctico) que utiliza el lexer.
            parser parser = new parser(lexer);

            System.out.println("--- Inicia Análisis Léxico ---");

            //variable para almacenar el token actual
            Symbol token;
            // Ciclo para obtener tokens del lexer hasta que se alcance el final del archivo (EOF).
            do {
                token = lexer.next_token();
                System.out.println("Lexema: '" + (token.value != null ? token.value : lexer.yytext()) + // Imprime el lexema del token actual
                                   "', Tipo: " + sym.terminalNames[token.sym] + // Imprime el tipo de token
                                   ", Línea: " + (token.left + 1) + // Imprime la línea del token
                                   ", Columna: " + (token.right + 1)); // Imprime la columna del token
            } while (token.sym != sym.EOF);
            System.out.println("--- Finaliza Análisis Léxico ---\n");

            // Reiniciamos el lexer y parser para el análisis sintáctico
            lexer = new lexicoAnalizador(new StringReader(codeToTest));
            // Creamos un nuevo parser con el lexer reiniciado.
            parser = new parser(lexer);

            System.out.println("--- Inicia Análisis Sintáctico ---");
            parser.parse(); 
            System.out.println("--- Finaliza Análisis Sintáctico ---");

        } catch (Exception e) { // Captura cualquier excepción que ocurra durante el análisis
            System.err.println("Error durante el análisis: " + e.getMessage());
            e.printStackTrace();
        }
    }
}