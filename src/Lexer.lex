import java_cup.runtime.*;

%%

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Comment = {SingleLineComment} | {MultiLineComment}

SingleLineComment = "#" {InputCharacter}* {LineTerminator}?
MultiLineComment  = "/#" [^#] ~"#/" | "/#" "#"+ "/"


