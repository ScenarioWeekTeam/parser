import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Comment = {SingleLineComment} | {MultiLineComment}

SingleLineComment = "#" {InputCharacter}* {LineTerminator}?
MultiLineComment  = "/#" ~"#/"

Identifier = [:jletter:] [:jletterdigit:]*

Int = (-)?[0-9]*
Rat = (-)?[0-9]*(_)?[0-9]*/[0-9]*
Float = (-)?[0-9]*.[0-9]*
Bool = (T|F)
Char = ['(A-Z|a-z|0-9|!|\"|#|$|%|&|\\'|\(|\)|\*|\+|,|\.|/|:|;|<|=|>|\?|@|\[|\\|\]|\^|_|`|\{|\||\}|~)']

%%

<YYINITIAL> {
    /* Keywords */
    "loop" { return symbol(sym.LOOP); }
    "pool" { return symbol(sym.POOL); }
    "if" { return symbol(sym.IF); }
    "then" { return symbol(sym.THEN); }
    "else" { return symbol(sym.ELSE); }
    "fi" { return symbol(sym.FI); }
    "break" { return symbol(sym.BREAK); }
    "fdef" { return symbol(sym.FDEF); }
    "tdef" { return symbol(sym.TDEF); }
    "in" { return symbol(sym.IN); }
    "alias" { return symbol(sym.ALIAS); }
    "read" { return symbol(sym.READ); }
    "print" { return symbol(sym.PRINT); }
    "main" { return symbol(sym.MAIN); }

    /* Types */
    "char" { return symbol(sym.CHAR_TYPE); }
    "bool" { return symbol(sym.BOOL_TYPE); }
    "int" { return symbol(sym.INT_TYPE); }
    "rat" { return symbol(sym.RAT_TYPE); }
    "float" { return symbol(sym.FLOAT_TYPE); }
    "dict" { return symbol(sym.DICT_TYPE); }
    "seq" { return symbol(sym.SEQ_TYPE); }
    "top" { return symbol(sym.TOP_TYPE); }
    
    /* Literals */
    {Identifier} { return symbol(sym.IDENTIFIER, yytext()); }
    {Char} { return symbol(sym.CHAR, new Character(yytext().charAt(1))); }
    {Bool} { return symbol(sym.BOOL, yytext()); }
    {Int} { return symbol(sym.INT, new Integer(yytext())); }
    {Rat} { return symbol(sym.RAT, new Rational(yytext())); }
    {Float} { return symbol(sym.FLOAT, new Double(yytext())); }
    "null" { return symbol(sym.NULL); }

    {Comment} { /* Ignore */ }
    {Whitespace} { /* Ignore */ }
    
    /* Operators */
    "!" { return symbol(sym.NOT); }
    "&&" { return symbol(sym.AND); }
    "\|\|" { return symbol(sym.OR); }
    "=>" { return symbol(sym.IMPLICATION); }
    "\+" { return symbol(sym.ADD); }
    "-" { return symbol(sym.MINUS); }
    "\*" { return symbol(sym.TIMES); }
    "/" { return symbol(sym.DIVIDE); }
    "^" { return symbol(sym.POWER); }
    "<" { return symbol(sym.LESSTHAN); }
    "<=" { return symbol(sym.LESSTHANEQUAL); }
    "=" { return symbol(sym.EQUAL); }
    "!=" { return symbol(sym.NOTEQUAL); }
    ":=" { return symbol(sym.ASSIGN); }
}
