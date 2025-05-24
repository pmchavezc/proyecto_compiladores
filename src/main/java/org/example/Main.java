package org.example;

import java_cup.runtime.Symbol;
import java.io.FileReader;
import java.io.StringReader; // Para probar con un String directamente

public class Main {
    public static void main(String[] args) {
        try {
            // Example 1: Using a StringReader for quick testing
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

            // Reset the lexer for parsing
            lexer = new lexicoAnalizador(new StringReader(codeToTest));
            parser = new parser(lexer);

            System.out.println("--- Inicia Análisis Sintáctico ---");
            parser.parse(); // Esto iniciará el análisis sintáctico
            System.out.println("--- Finaliza Análisis Sintáctico ---");

            // Example 2: Reading from a file (uncomment to use)
            /*
            System.out.println("\n--- Analizando archivo de entrada ---");
            FileReader fileReader = new FileReader("input.txt"); // Asegúrate de tener un input.txt
            lexicoAnalizador fileLexer = new lexicoAnalizador(fileReader);
            parser fileParser = new parser(fileLexer);
            fileParser.parse();
            fileReader.close();
            */

        } catch (Exception e) {
            System.err.println("Error durante el análisis: " + e.getMessage());
            e.printStackTrace();
        }
    }
}