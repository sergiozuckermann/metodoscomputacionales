defmodule PythonTokenizer do
  def read_write(in_filename, out_filename) do
    data = in_filename
           |> File.stream!()
           |> Enum.map(&tokeni/1)
           |> Enum.join("")
    File.write!(out_filename, data)
  end

  def tokeni(code) do
    res=""
    do_tokeni(code, res)
  end

  def do_tokeni("", res) do
    Enum.reverse(res)
  end

  def do_tokeni(code, res) do

    comments = Regex.scan(~r/^#.*$/, code)
    reserved_words = Regex.scan(~r/^\b^(and|as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield)\b/, code)
    whitespace = Regex.scan(~r/^\s+/, code)
    numbers = Regex.scan(~r/^\b\d+(\.\d+)?\b/, code)
    strings = Regex.scan(~r/^("[^"]"|'[^']')/, code)
    identifier = Regex.scan(~r/^\b[a-zA-Z_][a-zA-Z0-9_]*\b/, code)
    punctuation = Regex.scan(~r/^[\w\s]/, code)
    operator = Regex.scan(~r/^(\+|-|\|\/|\/\/|%|<<|>>|&|\||\^||<|>|<=|>=|==|!=|<>|\+=|-=|\=|\/=|\/\/=|%=|&=|\|=|\^=|>>=|<<=)/, code)

    cond do
      Regex.match?(reserved_words, token) ->
        "<span class=\"reserved_words\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(identifier, token) ->
        "<span class=\"identifier\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(strings, token) ->
        "<span class=\"strings\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(numbers, token) ->
        "<span class=\"numbers\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(comments, token) ->
        "<span class=\"comments\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(punctuation, token) ->
        "<span class=\"punctuation\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      Regex.match?(operator, token) ->
        "<span class=\"operator\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail, resu)

      true ->
        "<span class=\"unknown\">#{token}</span>"
        resu=Enum.join([res, token], "")
        tail=String.slice(code, String.length(token)..-1)
        do_tokeni(tail,resu)
    end
  end

  def generate_html(tokens) do
    html_file = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Python Syntax Highlighter</title>
      <link rel="stylesheet" href="colors.css">
    </head>
    <body>
      <pre>#{tokens}</pre>
    </body>
    </html>
    """
    html_file
  end
end

PythonTokenizer.read_write("python/input.py", "output.html")
