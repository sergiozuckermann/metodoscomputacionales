# Implementación de Metodos Computacionales
### Sergio Zuckermannn A0
### Santiago Tena Zozaya A017181293

## Resaltador de sintaxis en Elixir

El código se basa en funciones de tipo Regex para poder identificar los diferentes tipos de tokens que podemos identifcar en Python. Para poder correr el código se requieren correr los siguientes comandos en la terminal:

    iex PythonTokenizer.ex

Una vez dentro del ambiente de Elixir se debe llamar al módulo y la función que llama al programa principal:

    PythonTokenizer.read_write(in_filename, out_filename)

En _in\_filename_ se debe especificar el nombre del archivo a leer y el path en donde su ubica. De igual manera para _out\_filename_ se debe dar el nombre deseado del archivo que se va a generar y en dónde se desea guardar.

# Notación Big-O
El tiempo de ejecución del programa dependerá del número de tokens identificados, sin embargo no significa que la complejidad aumenta. Esto quiere decir que la notación para las funciones es de 
    
    O = (n * n)
