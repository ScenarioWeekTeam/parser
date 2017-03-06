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

Int = (-)?[1-9][0-9]*
Rat = 

Char = ['(A-Z|a-z|0-9|!|"|#|$|%|&|'|\(|\)|\*|\+|,|\.|/|:|;|<|=|>|\?|@|\[|\\|\]|\^|_|`|{|\||}|~)']

%%

<YYINITIAL> "loop" { return symbol(sym.LOOP); }
<YYINITIAL> "pool" { return symbol(sym.POOL); }
<YYINITIAL> "if" { return symbol(sym.IF); }
<YYINITIAL> "fi" { return symbol(sym.FI); }
<YYINITIAL> "break" { return symbol(sym.BREAK); }
<YYINITIAL> "fdef" { return symbol(sym.FDEF); }

<YYINITIAL> {
    {Comment} { /* Ignore */ }
    {Whitespace} { /* Ignore */ }
}
