# Activity 3.1 - Regular languages

## Names:
- Sergio Zuckermann
- Santiago Tena

## Documentation

## Language: Racket

Racket is a general-purpose programming language and software development environment. It is designed to be a platform for language creation, experimentation, and implementation. Racket is a dialect of Lisp, and it provides a rich set of tools for creating and manipulating languages.

## How to use it:

To install Racket, follow these steps:

Go to the Racket download page.
Choose the appropriate version for your operating system.
Download and run the installer.
Follow the instructions in the installer to complete the installation.
Usage
Once Racket is installed, you can start using it by launching the Racket REPL (Read-Eval-Print Loop), which is a command-line interface for interacting with the Racket language.


Now launch DrRacket and press run. Now type (arithmetic-lexer "Expression you would like to use") and press enter, this should get you an Output.

## Output

The output will show two column one with the current data and what token it belongs to for each one of the chracters, if the expression is invalid it will return false. Right now the program is limited and will not take comments.

## Anexo 1: Automata

#lang racket

(require racket/trace)

(provide arithmetic-lexer)


 ; Here the structure for the DFA is provided
(struct dfa (func initialstate accept))


; This will be the function to evaluate the DFA
(define (evaluate-dfa dfa-to-eval str) 
    (let loop ([chars (string->list str)]
             ;Here the state, the tokens and the value are passed as arguments
             [state (dfa-initialstate dfa-to-eval)]
             [tokens '()] 
             [value '()]) 
    (if (empty? chars)
        ;Here we can make a condition for an invalid state
        (if (member state (dfa-accept dfa-to-eval)) 
            ;This will manage the last space if it where a space in which case it will ignore it and also return a invalid if the expression doesnt apply
            (if (eq? state 'spa)
                (displayTokens (reverse tokens))  
                (displayTokens (reverse (cons (list (list->string (reverse value)) state) tokens)))
                )
            'invalid) 
        (let-values ([(new-state token-found) ((dfa-func dfa-to-eval) state (car chars))])
          (loop (cdr chars)
                new-state
                ;If the value is found it will do the following
                (if token-found 
                      (cons (list (list->string (reverse value)) token-found) tokens)                                
                      tokens)
                (if (not (char-whitespace? (car chars))) 
                    (if token-found
                    (cons (car chars) '()) 
                    (cons (car chars) value))
                    '()))))))

; This will be the determinator for the function to figure out if its a valid expression
(define (transition-fn state char)
  (case state

    ;Start state
    ['start (cond
              [(or (eq? char #\-)(eq? char #\+)) (values 'sign #f)]
              [(char-numeric? char) (values 'int #f)]
              [(or (char-alphabetic? char) (eq? char #\_)) (values 'var #f)]
              [(eq? char #\() (values 'opar #f)]
              [(char-whitespace? char) (values 'ispa #f)]
              [else (values 'inv #f)])]
    
    
    ;Sign
    ['sign (cond
             [(char-numeric? char) (values 'int #f)]
             [else (values 'inv #f)])]
    
    ;Variable
    ['var (cond
            [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op 'var)]
            [(or (char-alphabetic? char) (eq? char #\_) (char-numeric? char)) (values 'var #f)]
            [(char-whitespace? char) (values 'spa 'var)]
            [(eq? char #\)) (values 'cpar 'var)]
            [else (values 'inv #f)])]
    
    ;Integer
    ['int (cond
            [(char-numeric? char) (values 'int #f)]
            [(eq? char #\.) (values 'dot #f)]
            [(or (eq? char #\e) (eq? char #\E)) (values 'e #f)]
            [(char-whitespace? char) (values 'spa 'int)]
            [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op 'int)]
            [(eq? char #\)) (values 'cpar 'int)]
            [else (values 'inv #f)])]
    
    ;Dot
    ['dot (cond
            [(char-numeric? char) (values 'float #f)]
            [else (values 'inv #f)])]
    
    ;float
    ['float (cond
              [(char-numeric? char) (values 'float #f)]
              [(or (eq? char #\e) (eq? char #\E)) (values 'e #f)]
              [(char-whitespace? char) (values 'spa 'float)]
              [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op 'float)]
              [(eq? char #\)) (values 'cpar 'float)]
              [else (values 'inv #f)])]
    
    ; Operation 
    ['op (cond
           [(char-whitespace? char) (values 'ospa 'op)]
           [(or (char-alphabetic? char) (eq? char #\_)) (values 'var 'op)]
           [(char-numeric? char) (values 'int 'op)]
           [(or (eq? char #\+) (eq? char #\-)) (values 'sign 'op)]
           [(eq? char #\() (values 'opar 'op)]
           [else (values 'inv #f)])]
    
    ; Exponent 
    ['e (cond
          [(char-numeric? char) (values 'exp #f)]
          [(or (eq? char #\-)(eq? char #\+)) (values 'e_sign #f)]
          [else (values 'inv #f)])]
    
    ; Number in exponent
    ['exp (cond
            [(char-numeric? char) (values 'exp #f)]
            [(char-whitespace? char) (values 'spa 'exp)]
            [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op 'exp)]
            [(eq? char #\)) (values 'cpar 'exp)]
            [else (values 'inv #f)])]
    
    ; E sign (positive or negative)
    ['e_sign (cond
               [(char-numeric? char) (values 'exp #f)]
               [else (values 'inv #f)])]
    
    
    
    ; Space
    ['spa (cond
            [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op #f)]
            [(eq? char #\)) (values 'cpar #f)]
            [(char-whitespace? char) (values 'spa #f)]
            [else (values 'inv #f)])]
    
    ;Space at operation
    ['ospa (cond
               [(or (char-alphabetic? char) (eq? char #\_)) (values 'var #f)]
               [(char-numeric? char) (values 'int #f)]
               [(eq? char #\() (values 'opar #f)]
               [(char-whitespace? char) (values 'ospa #f)]
               [else (values 'inv #f)])]
    
    ;Space at parenthesis
    ['pspa (cond
                        [(char-numeric? char) (values 'int #f)]
                        [(or (char-alphabetic? char) (eq? char #\_)) (values 'var #f)]
                        [(or (eq? char #\+) (eq? char #\-)) (values 'sign #f)]
                        [(char-whitespace? char) (values 'pspa #f)]
                        [else (values 'inv #f)])]
    
    ; Space at beggining
    ['ispa (cond 
                [(eq? char #\() (values 'opar #f)] 
                [(or (char-alphabetic? char) (eq? char #\_)) (values 'var #f)]
                [(char-numeric? char) (values 'int #f)]
                [(char-whitespace? char) (values 'ispa #f)]
                [(or (eq? char #\+) (eq? char #\-)) (values 'sign #f)] 
                [else (values 'inv #f)])]
    
    ; Closed parenthesis
    ['cpar (cond
                  [(or (eq? char #\+) (eq? char #\-) (eq? char #\*) (eq? char #\/) (eq? char #\=) (eq? char #\^)) (values 'op 'cpar)]
                  [(char-whitespace? char) (values 'spa 'cpar)]
                  [else (values 'inv #f)])]
    
    ;Open parenthesis
    ['opar (cond
                 [(char-numeric? char) (values 'int 'opar)]
                 [(char-whitespace? char) (values 'pspa 'opar)]
                 [(or (char-alphabetic? char) (eq? char #\_)) (values 'var 'open_var)]
                 [(or (eq? char #\+) (eq? char #\-)) (values 'sign 'opar)]
                 [else (values 'inv #f)])]

    [else (values 'inv #f)]))


; This function will serve to show the results
(define (displayTokens lst)
  (let loop ([lst lst] [result (format "Current Data:            Result: ~n~n")])
    (if (empty? lst)
        (displayln result)
        (loop (cdr lst) (string-append result (format " ~a            ~a ~n ~n"
                                                      (first (car lst))
                                                      (second (car lst))))))))


; In this line we will define the instance of the DFA to be used
(define dfa-instance (dfa transition-fn 'start '(int float exp var spa cpar)))

; This is the definition of the lexer that will be used
(define (arithmetic-lexer str)
  (evaluate-dfa dfa-instance str))


