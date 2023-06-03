#Sergio Zuckermann and Santiago Tena SYNTAX HIGHLIGHTER#
#This program will take any Python file and output an HTML file with the syntax highlighted according to the category of the token.#

#The main module will take the data from the input file and send line to line to the Tokeni function.#
#After the Tokeni function has finished, it will join the resulting strings and generate an output html with the data.#
defmodule PythonTokenizer do
  def read_write(in_filename, out_filename) do
    data = in_filename
           |> File.stream!()
           |> Enum.map(&tokeni/1)
           |> Enum.join("")
    File.write!(out_filename, generate_html(data))
  end

  #Tokeni will initialize the string res and calls upon the two cases of do_tokeni.#
  def tokeni(code) do
    res=""
    do_tokeni(code, res)
  end

  #This case is for when the line has been completely scaned or empty and returns res.#
  def do_tokeni("", res) do
    res
  end

  #This case is for when the line has not been completely scaned and calls upon the different regex to find the token.#
  def do_tokeni(code, res) do
    #The regex are stored in variables to be called later.#
    comments = ~r/^#.*$/
    reserved_words = ~r/^\b^(and|as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield|False|None|True)\b/
    builtfunction = ~r/^\b^(abs|all|any|ascii|bin|bool|bytearray|bytes|callable|chr|classmethod|compile|complex|delattr|dict|dir|divmod|enumerate|eval|exec|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|isinstance|issubclass|iter|len|list|locals|map|max|memoryview|min|next|object|oct|open|ord|pow|print|property|range|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|vars|zip)\b/
    whitespace = ~r/^\s+/
    numbers = ~r/^\b\d+(\.\d+)?\b/
    strings = ~r/^(['"]).*\1/
    identifier = ~r/^\b[a-zA-Z_][a-zA-Z0-9_]*\b/
    punctuation = ~r/^[\w\s]/
    operator = ~r/^(\+|-|\|\/|\/\/|%|<<|>>|&|\|\^|<|>|<=|>=|==|!=|<>|\+=|-=|\=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=)/
    delimiter = ~r/^[\()[\]{},:.`=;]/

    #The function will check if the line matches any of the regex and if it does.#
    #Then it will separate the token from the rest of the string, add the token to the string res in the adequate format.#
    #Then it will call upon itself with the rest of the string and the new string res.#
    cond do

      Regex.match?(builtfunction, code) ->
        [token|_]= Regex.run(builtfunction, code)
        head="<span class=\"builtfunction\">#{token}</span>"
        resu=Enum.join([res, head], "")
        cut=String.length(token)
        tail=String.slice(code, cut..-1)
        do_tokeni(tail, resu)

      Regex.match?(reserved_words, code) ->
        [token|_]= Regex.run(reserved_words, code)
        head="<span class=\"reserved_words\">#{token}</span>"
        resu=Enum.join([res, head], "")
        cut=String.length(token)
        tail=String.slice(code, cut..-1)
        do_tokeni(tail, resu)

      Regex.match?(identifier, code) ->
        [token|_]= Regex.run(identifier, code)
        head="<span class=\"identifier\">#{token}</span>"
        resu=Enum.join([res, head], "")
        cut=String.length(token)
        tail=String.slice(code, cut..-1)
        do_tokeni(tail, resu)

        Regex.match?(delimiter, code) ->
          [token|_]= Regex.run(delimiter, code)
          head="<span class=\"delimiter\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(strings, code) ->
          [token|_]= Regex.run(strings, code)
          head="<span class=\"strings\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(numbers, code) ->
          [token|_]= Regex.run(numbers, code)
          head="<span class=\"numbers\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(comments, code) ->
          [token|_]= Regex.run(comments, code)
          head="<span class=\"comments\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(punctuation, code) ->
          [token|_]= Regex.run(punctuation, code)
          head="<span class=\"punctuation\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(operator, code) ->
          [token|_]= Regex.run(operator, code)
          head="<span class=\"operator\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        Regex.match?(whitespace, code) ->
          [token|_]= Regex.run(whitespace, code)
          head="<span class=\"operator\">#{token}</span>"
          resu=Enum.join([res, head], "")
          cut=String.length(token)
          tail=String.slice(code, cut..-1)
          do_tokeni(tail, resu)

        #If none of the regex match the line, then it will be considered unknown and will be added to the string res in the adequate format.#
        true ->
          head="<span class=\"unknown\">#{code}</span>"
          resu=Enum.join([res, head], "")
          do_tokeni("",resu)
    end
  end


  #This function will generate the html file with the string tokens which is the list of all tokens in all lines as the body.#
  def generate_html(tokens) do
    html_file = """
    <!DOCTYPE html>
    <html lang="en-US">
      <head>
        <meta charset="UTF-8" />
        <title>Python Syntax Highlighter</title>
        <link rel="stylesheet" href="colors.css">
      </head>
      <body>
        <pre>
          #{tokens}
        </pre>
      </body>
    </html>
    """
    html_file
  end
end

#This function will declare the file and the output.#
PythonTokenizer.read_write("python/Captone.py", "output.html")
