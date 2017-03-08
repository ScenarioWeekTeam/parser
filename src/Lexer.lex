import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();

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

Int = (-)?[0-9]+
Rat = (-)?([0-9]+_)?[0-9]+\/[0-9]+
Float = (-)?[0-9]+.[0-9]+
Bool = "T"|"F"
Char = '[A-Z|a-z|0-9|!|\"|#|$|%|&|\'|\(|\)|\*|\+|,|\.|/|:|;|<|=|>|\?|@|\[|\\|\]|\^|_|`|\{|\¦|\}|\~]'

%state STRING

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
    "null" { return symbol(sym.NULL); }
    {Bool} { return symbol(sym.BOOL, new Character(yytext().charAt(0))); }
    {Identifier} { return symbol(sym.IDENTIFIER, yytext()); }
    {Char} { return symbol(sym.CHAR, new Character(yytext().charAt(1))); }
    {Float} { return symbol(sym.FLOAT, new Double(yytext())); }
    {Rat} { return symbol(sym.RAT, new Rational(yytext())); }
    {Int} { return symbol(sym.INT, new Integer(yytext())); }
    \" { string.setLength(0); yybegin(STRING); }

    {Comment} { /* Ignore */ }
    {WhiteSpace} { /* Ignore */ }

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
    "::" { return symbol(sym.CONCAT); }

    /* Symbols */
    "(" { return symbol(sym.LPARENS); }
    ")" { return symbol(sym.RPARENS); }
    "{" { return symbol(sym.LBRACE); }
    "}" { return symbol(sym.RBRACE); }
    ":" { return symbol(sym.COLON); }
    "[" { return symbol(sym.LBRACKET); }
    "]" { return symbol(sym.RBRACKET); }
    ";" { return symbol(sym.SEMICOLON); }
    ">" { return symbol(sym.GREATERTHAN); }
    "," { return symbol(sym.COMMA); }
    "?" { return symbol(sym.QUESTION); }
}

<STRING> {
    \" { yybegin(YYINITIAL);
         return symbol(sym.STRING, string.toString()); }
    [^\n\r\"\\]+ { string.append(yytext()); }
    \\t { string.append('\t'); }
    \\n { string.append('\n'); }

    \\r { string.append('\r'); }
    \\\" { string.append('\"'); }
    \\ { string.append('\\'); }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }
