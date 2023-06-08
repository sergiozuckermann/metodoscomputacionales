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
El tiempo de ejecución del programa dependerá del número de tokens identificados, o en otras palabras, del tamaño del archivo. Sin embargo no significa que la complejidad aumenta. Esto quiere decir que la notación para las funciones es de
O = (n * m)


1. Leer el archivo: se utiliza la función 'File.stream/1' la cual lee el archivo linea por linea. La complejidad de leer el archivo es O(n).


2. Volver token cada línea: 'do_tokeni/2' aplica diferentes expresiones regulares de manera secuencial. La complejidad de tiempo de aplicar una expresión regular a un string es generalmente de O(m)


3. Concatenar strings resultantes: 'Enum.join/2' se usa para juntar las strings resultantes. La complejidad de esta función es de O(m + n).


4. Generar el archivo: 'File.write!/2' que se usa para generar el archivo HTML tiene una complejidad que generalmente se considera O(m), la cual igual depende del tamaño del archivo original.
