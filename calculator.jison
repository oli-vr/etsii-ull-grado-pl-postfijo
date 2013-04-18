/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%


\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"if"                  return 'IF'
"then"                return 'THEN'
"else"                return 'ELSE'
"<="                  return '<='
">="                  return '>='
"<"                   return '<'
">"                   return '>'
"=="                  return '=='
"="                   return '=' 
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
";"                   return ';' 
[a-zA-Z][a-zA-Z0-9]*  return 'ID'
//<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex
%{
  var symbol_table = {}
%}  

/* operator associations and precedence */
%left ';'
%left THEN
%right ELSE
%left '='
%left '<=' '>=' '>' '<' '=='
%left '+' '-'  
%left '*' '/'
%right '^'
%left UMINUS

%start P

%% /* language grammar */

P   : S
          {
             return [ "<ul>\n<li> Postfijo<p> "+ $$ + "\n </ul>"];
          }
    ;

S
    : { $$ = ''; }
    | e 
    | e ';' S 
      { $$ += $3;} 
    
    ;

e
    : ID '=' e
        {$$ = "<dd>" + $3 + "</dd><dd>" + "&" + $1 + "</dd><dd> = </dd>";}
    | IF e THEN e
        {$$ = "" + $2 + "<dd> jmpz else </dd>" + $4 + "<dt> :endif </dt>"}      
    | IF e THEN e ELSE e
        {$$ = "" + $2 + "<dd> jmpz else </dd>" + $4 + "<dd> jmp endif </dd><dt> :else </dt>" + $6 + "<dt> :endif </dt>"}
    | e '>=' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> >= </dd>";}
    | e '<=' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> <= </dd>";}
    | e '<' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> < </dd>";}
    | e '>' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> > </dd>";}
    | e '==' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> == </dd>";}
    | e '+' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> + </dd>";}
    | e '-' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> - </dd>";}
    | e '*' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> * </dd>";}
    | e '/' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> / </dd>";}
    | e '^' e
        {$$ = "<dd>" + $1 + "</dd><dd>" + $3 + "</dd><dd> ^ </dd>";}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);} 
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID
        {$$ = "&" + $1}
    | PI '=' e
        {throw new Error("No puedes asignar valor a una constante");}
    | E '=' e
        {throw new Error("No puedes asignar valor a una constante");}
    ;