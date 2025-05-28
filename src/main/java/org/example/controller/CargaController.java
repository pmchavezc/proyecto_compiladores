package org.example.controller;

import java_cup.runtime.Symbol;
import org.example.lexicoAnalizador;
import org.example.parser;
import org.example.sym;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.*; // Necesitarás todas estas importaciones

@Controller
public class CargaController {

    // Este método es para cargar la página inicial (HTML)
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("analysisResult", "Esperando código o archivo para analizar...");
        return "Auth/carga"; // Devuelve el nombre de la plantilla HTML para que Thymeleaf la renderice
    }

    // Método auxiliar para obtener el stack trace de una excepción
    private String getStackTrace(Throwable e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    @PostMapping("/procesar")
    @ResponseBody
    public String procesarArchivo(@RequestParam("archivo") MultipartFile archivo) {
        // Usamos StringWriter para capturar toda la salida y errores
        StringWriter fullOutputWriter = new StringWriter();
        PrintWriter outputPrintWriter = new PrintWriter(fullOutputWriter); // Para mensajes generales y tokens

        StringWriter errorStringWriter = new StringWriter();
        PrintWriter errorPrintWriter = new PrintWriter(errorStringWriter); // Para errores léxicos y sintácticos

        // Redirección temporal de System.err (útil para errores inesperados o de CUP)
        PrintStream originalErr = System.err;
        ByteArrayOutputStream capturedSystemErrBytes = new ByteArrayOutputStream();
        PrintStream newSystemErr = new PrintStream(capturedSystemErrBytes);
        System.setErr(newSystemErr); // Redirigir System.err

        try {
            if (archivo == null || archivo.isEmpty()) {
                return "No se seleccionó ningún archivo para analizar.";
            }

            String fileContent = new String(archivo.getBytes());
            outputPrintWriter.println("--- Contenido del archivo recibido ---\n" + fileContent + "\n");

            // --- Análisis Léxico ---
            outputPrintWriter.println("--- Inicia Análisis Léxico ---");
            // Se pasa el errorPrintWriter al lexer para que reporte los errores léxicos allí
            lexicoAnalizador lexerLexical = new lexicoAnalizador(new StringReader(fileContent), errorPrintWriter);
            Symbol token;
            do {
                token = lexerLexical.next_token();
                if (token.sym != sym.EOF) {
                    outputPrintWriter.println("Lexema: '" +
                            (token.value != null ? token.value : lexerLexical.yytext()) +
                            "', Tipo: " + sym.terminalNames[token.sym] +
                            ", Línea: " + (token.left + 1) +
                            ", Columna: " + (token.right + 1));
                }
            } while (token.sym != sym.EOF);
            outputPrintWriter.println("--- Finaliza Análisis Léxico ---\n");

            lexicoAnalizador lexerSyntactic = new lexicoAnalizador(new StringReader(fileContent), errorPrintWriter);
            parser compilerParser = new parser(lexerSyntactic, outputPrintWriter, errorPrintWriter); // Order: lexer, output, error

            outputPrintWriter.println("--- Inicia Análisis Sintáctico ---");
            compilerParser.parse(); // Ejecuta el análisis sintáctico
            outputPrintWriter.println("--- Finaliza Análisis Sintáctico ---");

            // Asegurarse de vaciar los buffers de los PrintWriters antes de leer sus contenidos
            outputPrintWriter.flush();
            errorPrintWriter.flush();

            // Construir el resultado final
            StringBuilder finalResultBuilder = new StringBuilder();

            // 1. Errores específicos de JFlex/CUP (errores léxicos y sintácticos reportados por tus analizadores)
            String capturedParserErrors = errorStringWriter.toString();
            if (!capturedParserErrors.isEmpty()) {
                finalResultBuilder.append("--- Errores Detectados ---\n").append(capturedParserErrors).append("\n");
            } else {
                finalResultBuilder.append("--- No se detectaron errores léxicos o sintácticos --- \n\n");
            }

            // 2. Mensajes del parser (ej. "Programa reconocido correctamente.")
            String capturedParserOutput = fullOutputWriter.toString(); // Captura toda la salida, incluyendo tokens y mensajes
            if (!capturedParserOutput.isEmpty()) {
                finalResultBuilder.append("--- Mensajes y Tokens de Análisis ---\n").append(capturedParserOutput).append("\n");
            }

            // 3. Cualquier cosa que System.err haya capturado que no fue por los PrintWriters (residual)
            String residualSystemErr = capturedSystemErrBytes.toString();
            if (!residualSystemErr.isEmpty()) {
                finalResultBuilder.append("\n--- Errores Residuales de System.err (Depuración) ---\n").append(residualSystemErr);
            }

            return finalResultBuilder.toString();

        } catch (Exception e) {
            // Asegurarse de vaciar el errorWriter incluso si hay una excepción
            errorPrintWriter.flush();
            // También vaciar System.err redirigido
            newSystemErr.flush();

            // Construir el mensaje de error completo
            StringBuilder errorResultBuilder = new StringBuilder();
            errorResultBuilder.append("Error al procesar el archivo: ").append(e.getMessage()).append("\n");
            errorResultBuilder.append("Detalles del error (stack trace):\n").append(getStackTrace(e)).append("\n");

            String capturedParserErrors = errorStringWriter.toString();
            if (!capturedParserErrors.isEmpty()) {
                errorResultBuilder.append("\n--- Errores Detectados por Analizadores (JFlex/CUP) ---\n").append(capturedParserErrors);
            }

            String residualSystemErr = capturedSystemErrBytes.toString();
            if (!residualSystemErr.isEmpty()) {
                errorResultBuilder.append("\n--- Errores Residuales de System.err (Depuración) ---\n").append(residualSystemErr);
            }

            return errorResultBuilder.toString();

        } finally {
            // ¡MUY IMPORTANTE! Restaurar System.err a su estado original SIEMPRE
            System.setErr(originalErr);
            // Cerrar los PrintWriters para liberar recursos
            if (outputPrintWriter != null) outputPrintWriter.close();
            if (errorPrintWriter != null) errorPrintWriter.close();
            try {
                if (newSystemErr != null) newSystemErr.close();
                if (capturedSystemErrBytes != null) capturedSystemErrBytes.close();
            } catch (IOException ioE) {
                System.err.println("Error al cerrar streams de captura: " + ioE.getMessage());
            }
        }
    }

    // --- METODO 'procesardatos' CORREGIDO ---
    @PostMapping("/procesardatos")
    @ResponseBody
    public String procesarDatos(@RequestParam("mensaje") String mensaje) {
        // StringWriters para capturar toda la salida y errores
        StringWriter fullOutputWriter = new StringWriter();
        PrintWriter outputPrintWriter = new PrintWriter(fullOutputWriter); // Para mensajes generales y tokens

        StringWriter errorStringWriter = new StringWriter();
        PrintWriter errorPrintWriter = new PrintWriter(errorStringWriter); // Para errores léxicos y sintácticos

        // No redirigiremos System.err aquí a menos que sea estrictamente necesario para simplificar
        // Si tienes problemas para ver errores aquí, puedes aplicar la misma técnica de redirección de System.err

        try {
            if (mensaje == null || mensaje.trim().isEmpty()) {
                return "No se ingresó texto para analizar.";
            }

            outputPrintWriter.println("--- Contenido del mensaje recibido ---\n" + mensaje + "\n");

            // --- Análisis Léxico ---
            outputPrintWriter.println("--- Inicia Análisis Léxico ---");
            // Se pasa el errorPrintWriter al lexer para que reporte los errores léxicos allí
            lexicoAnalizador lexerLexical = new lexicoAnalizador(new StringReader(mensaje), errorPrintWriter);
            Symbol token;
            do {
                token = lexerLexical.next_token();
                if (token.sym != sym.EOF) {
                    outputPrintWriter.println("Lexema: '" +
                            (token.value != null ? token.value : lexerLexical.yytext()) +
                            "', Tipo: " + sym.terminalNames[token.sym] +
                            ", Línea: " + (token.left + 1) +
                            ", Columna: " + (token.right + 1));
                }
            } while (token.sym != sym.EOF);
            outputPrintWriter.println("--- Finaliza Análisis Léxico ---\n");

            // --- Análisis Sintáctico ---
            // IMPORTANTE: Crear un NUEVO lexer para el parser
            // Se pasa el errorPrintWriter y el outputPrintWriter al parser
            lexicoAnalizador lexerSyntactic = new lexicoAnalizador(new StringReader(mensaje), errorPrintWriter);
            parser compilerParser = new parser(lexerSyntactic, outputPrintWriter, errorPrintWriter); // Order: lexer, output, error

            outputPrintWriter.println("--- Inicia Análisis Sintáctico ---");
            compilerParser.parse(); // Ejecuta el análisis sintáctico
            outputPrintWriter.println("--- Finaliza Análisis Sintáctico ---");

            // Asegurarse de vaciar los buffers
            outputPrintWriter.flush();
            errorPrintWriter.flush();

            // Construir el resultado final
            StringBuilder finalResultBuilder = new StringBuilder();

            // 1. Errores específicos de JFlex/CUP
            String capturedParserErrors = errorStringWriter.toString();
            if (!capturedParserErrors.isEmpty()) {
                finalResultBuilder.append("--- Errores Detectados ---\n").append(capturedParserErrors).append("\n");
            } else {
                finalResultBuilder.append("--- No se detectaron errores léxicos o sintácticos --- \n\n");
            }

            // 2. Mensajes y tokens del análisis (toda la salida del outputPrintWriter)
            String capturedParserOutput = fullOutputWriter.toString();
            if (!capturedParserOutput.isEmpty()) {
                finalResultBuilder.append("--- Mensajes y Tokens de Análisis ---\n").append(capturedParserOutput).append("\n");
            }

            return finalResultBuilder.toString();

        } catch (Exception e) {
            // Asegurarse de vaciar el errorWriter incluso si hay una excepción
            errorPrintWriter.flush();

            // Construir el mensaje de error completo
            StringBuilder errorResultBuilder = new StringBuilder();
            errorResultBuilder.append("Error durante el análisis del texto: ").append(e.getMessage()).append("\n");
            errorResultBuilder.append("Detalles del error (stack trace):\n").append(getStackTrace(e)).append("\n");

            String capturedParserErrors = errorStringWriter.toString();
            if (!capturedParserErrors.isEmpty()) {
                errorResultBuilder.append("\n--- Errores Detectados por Analizadores (JFlex/CUP) ---\n").append(capturedParserErrors);
            }

            // e.printStackTrace() para depuración en la consola del servidor
            e.printStackTrace();
            return errorResultBuilder.toString();

        } finally {
            // Cerrar los PrintWriters
            if (outputPrintWriter != null) outputPrintWriter.close();
            if (errorPrintWriter != null) errorPrintWriter.close();
        }
    }
}