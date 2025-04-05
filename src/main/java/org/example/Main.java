package org.example;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.logging.Level;
import java.util.logging.Logger;



public class Main {
    public static void main(String[] args) throws FileNotFoundException, IOException {
 try {


            Reader r = new FileReader("C:\\Users\\Pablo\\IdeaProjects\\proyecto_compiladores\\src\\main\\resources\\probandoEntradaJflex.txt");
            lexicoAnalizador a = new lexicoAnalizador(r);
            a.yylex();
            
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}