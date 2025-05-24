package org.example;

import java_cup.runtime.Symbol;
import java.io.FileReader;
import java.io.StringReader;

public class Main {
    public static void main(String[] args) {
        try {
            String codeToTest = "DEFINE x = 10;\n" +
                                "IF x > 5 THEN PRINT \"x es mayor que 5\"; END\n" +
                                "FUNCTION myFunc (a, b) PRINT a + b; END";

            lexicoAnalizador lexer = new lexicoAnalizador(new StringReader(codeToTest));
            parser parser = new parser(lexer);

            System.out.println("--- Inicia Análisis Léxico ---");
            Symbol token;
            do {
                token = lexer.next_token();
                System.out.println("Lexema: '" + (token.value != null ? token.value : lexer.yytext()) +
                                   "', Tipo: " + sym.terminalNames[token.sym] +
                                   ", Línea: " + (token.left + 1) +
                                   ", Columna: " + (token.right + 1));
            } while (token.sym != sym.EOF);
            System.out.println("--- Finaliza Análisis Léxico ---\n");

            lexer = new lexicoAnalizador(new StringReader(codeToTest));
            parser = new parser(lexer);

            System.out.println("--- Inicia Análisis Sintáctico ---");
            parser.parse(); 
            System.out.println("--- Finaliza Análisis Sintáctico ---");

        } catch (Exception e) {
            System.err.println("Error durante el análisis: " + e.getMessage());
            e.printStackTrace();
        }
    }
}