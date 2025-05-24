package org.example;

import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java_cup.runtime.Symbol; // Import Symbol

public class Main {
    public static void main(String[] args) {
        try {
            // Asegúrate de que la ruta al archivo sea correcta
            String filePath = "C:\\Users\\Pablo\\IdeaProjects\\proyecto_compiladores\\src\\main\\resources\\prueba.txt"; // Ruta relativa para proyectos Maven

            FileReader r = new FileReader(filePath);
            lexicoAnalizador lexer = new lexicoAnalizador(r);
            parser parser = new parser(lexer); // Crear una instancia del parser con el lexer

            // Iniciar el análisis sintáctico
            Symbol result = parser.parse();

            if (result != null) {
                System.out.println("Análisis completado con éxito.");
                // Puedes acceder al valor del resultado si tu gramática lo genera
                // System.out.println("Resultado del programa: " + result.value);
            } else {
                System.out.println("Análisis fallido.");
            }

        } catch (FileNotFoundException ex) {
            System.err.println("Error: El archivo de entrada no se encontró en la ruta especificada.");
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) { // Capturar la excepción general del parser
            System.err.println("Error durante el análisis: " + ex.getMessage());
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}