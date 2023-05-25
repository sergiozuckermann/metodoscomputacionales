#|
Implementation of a Deterministic Finite Automaton (DFA)

A function will receive the definition of a DFA and a string,
and return whether the string belongs in the language

A DFA is defined as a state machine, with 3 elements:
- Transition function
- Initial state
- List of acceptable states

The DFA in this file is used to identify valid arithmetic expressions

Examples:
> (evaluate-dfa (dfa delta-arithmetic 'start '(int float exp)) "-234.56")
'(float exp)

> (arithmetic-lexer "45.3 - +34 / none")
'(var spa)

Sergio Zuckermann
Santiago Tena
2023-04-21

  Transition function to validate numbers
  Initial state: start
  Accept states: int float exp spa comment
|#

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
displayTokens)


; In this line we will define the instance of the DFA to be used
(define dfa-instance (dfa transition-fn 'start '(int float exp var spa cpar)))

; This is the definition of the lexer that will be used
(define (arithmetic-lexer str)
  (evaluate-dfa dfa-instance str))
