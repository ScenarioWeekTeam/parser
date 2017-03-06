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
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Comment = {SingleLineComment} | {MultiLineComment}

SingleLineComment = "#" {InputCharacter}* {LineTerminator}?
MultiLineComment  = "/#" [^#] ~"#/" | "/#" "#"+ "/"

Identifier = [:jletter:] [:jletterdigit:]*

Int = (-)?[0-9]*
Rat = (-)?[0-9]*(_)?[0-9]*/[0-9]*
Float = (-)?[0-9]*.[0-9]*

Bool = (T|F)

Char = ['(A-Z|a-z|0-9|!|"|#|$|%|&|'|\(|\)|\*|\+|,|\.|/|:|;|<|=|>|\?|@|\[|\\|\]|\^|_|`|{|\||}|~)']

%%

/* Keywords */
<YYINITIAL> "loop" { return symbol(sym.LOOP); }
<YYINITIAL> "pool" { return symbol(sym.POOL); }
<YYINITIAL> "if" { return symbol(sym.IF); }
<YYINITIAL> "then" { return symbol(sym.THEN); }
<YYINITIAL> "else" { return symbol(sym.ELSE); }
<YYINITIAL> "fi" { return symbol(sym.FI); }
<YYINITIAL> "break" { return symbol(sym.BREAK); }
<YYINITIAL> "fdef" { return symbol(sym.FDEF); }
<YYINITIAL> "tdef" { return symbol(sym.TDEF); }
<YYINITIAL> "in" { return symbol(sym.IN); }
<YYINITIAL> "alias" { return symbol(sym.ALIAS); }
<YYINITIAL> "read" { return symbol(sym.READ); }
<YYINITIAL> "print" { return symbol(sym.PRINT); }
<YYINITIAL> "main" { return symbol(sym.MAIN); }

/* Types */
<YYINITIAL> "char" { return symbol(sym.CHAR_TYPE); }
<YYINITIAL> "bool" { return symbol(sym.BOOL_TYPE); }
<YYINITIAL> "int" { return symbol(sym.INT_TYPE); }
<YYINITIAL> "rat" { return symbol(sym.RAT_TYPE); }
<YYINITIAL> "float" { return symbol(sym.FLOAT_TYPE); }
<YYINITIAL> "dict" { return symbol(sym.DICT_TYPE); }
<YYINITIAL> "seq" { return symbol(sym.SEQ_TYPE); }
<YYINITIAL> "top" { return symbol(sym.TOP_TYPE); }


<YYINITIAL> {
    {Identifier} { return symbol(sym.IDENTIFIER); }
    {Char} { return symbol(sym.CHAR); }
    {Bool} { return symbol(sym.BOOL); }
    {Int} { return symbol(sym.INT); }
    {Rat} { return symbol(sym.RAT); }
    {Float} { return symbol(sym.FLOAT); }
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
}
