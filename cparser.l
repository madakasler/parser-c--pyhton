%option yylineno

%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <math.h>
    char className[100];
%}
%option noyywrap
DIGIT [0-9]
NUMBER {DIGIT}+
float [+-]?[0-9]+(\.)[0-9]+

/*Declararea regex-urilor pentru detectarea diferitelor pattern-uri caracteristice (antetul unei clase, o structura repetitiva, o asignare, o instanta a unui obiect, etc.)*/

USING "using"[ A-Za-z_.]+
CLASS "class"[ A-Za-z_]+
RETURN "return "[ 0-9A-Za-z_]+
NAMESPACE "namespace"[ A-Za-z_.]+
PUBLIC "public"
PRIVATE "private"
PROTECTED "protected"
STATIC "static"
MAIN "public static void main(String[] args)"
MAINTHROWS "public static void main(String[] args) throws"[ A-Za-z_,]+
VOID "void"[ A-Za-z_0-9]+
STRINGVALUE "String"[ A-Za-z_0-9]+
INTEGERVALUE "Integer"[ A-Za-z_0-9]+
FLOATVALUE "Float"[ A-Za-z_0-9]+
DOUBLEVALUE "Double"[ A-Za-z_0-9]+
BOOLEANVALUE "Boolean"[ A-Za-z_0-9]+
STRINGTYPE "String"[ A-Za-z_="]+{NUMBER}
INTEGERTYPE "Integer"[ A-Za-z_=]+{NUMBER}
FLOATTYPE "Float"[ A-Za-z_=]+{float}
DOUBLETYPE "Double"[ A-Za-z_=]+{float}
BOOLEANTYPE "Boolean"[ A-Za-z_=]+{NUMBER}
CONSTRUCT [A-Za-z_]+"()"
CONSTRUCT2 [A-Za-z_]+
FUNCWITOUTPARAM [A-Za-z_]+"."[A-Za-z_]+"()"
FUNCWITHPARAM [A-Za-z_]+"."[A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
STATICFUNCWITHOUTPARAM [A-Za-z_]+"()"
STATICFUNCWITHPARAM [A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
INSTANCE [ 0-9A-Za-z_]+"="[ 0-9A-Za-z_()+."]+[;]
IF "if ("[A-Za-z_> <=!.()]+
WHILE "while ("[A-Za-z_> <=!.0-9]+")"
FOR "for("[0-9 A-Za-z_><=!;+-]+")"
THROWS " throws"[ A-Za-z,]+

PRINT "System.out.print("[ .()A-Za-z" 0-9+-=]+")"



%%


{NAMESPACE} { /*Token pentru gasirea pachetului din c#*/
            return NAMESPACE;}

{USING} {	/*Token pentru a se returna folosirea unei alte clase sau a unei librarii*/
            printf("%s\n", yytext);
			return USING;}

{CLASS}  {	/*Token pentru antetu unei clase*/
            /*Se va printa toata linia gasita, dar mai putin "{", care va fi inlocuita de ":", acest lucru specific sintaxei Python*/
            int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(":\n");

			strcpy(className, yytext + 6);
			return CLASS; }

{PUBLIC}" " {
                /*Daca se intalnesc modificatori de acces se verifica ce este in continuare*/
            }
{PRIVATE}" " {}
{PROTECTED}" " {}

{STATIC}" " { /*Daca se intalneste proprietatea de static la o metoda sau variabila, continua*/ }

{RETURN} { /*Daca se intalneste tokenu de return, se scrie linia pe care e*/
			int contor = 0;
			while(contor < strlen(yytext)){
				printf("%c", yytext[contor]);
				contor++;
			}
			return RETURNT;
		}
{INSTANCE} { 	/*Daca se face match cu regex pentru a instanta un obiect de clasa se va afisa in fisierul de iesire doar numele noului obiect creat si numle clasei*/
                int rez = checkSpace(yytext);
              if (rez == 1) {
                int contor = 0;
                while (yytext[contor] == ' ')
                  printf("%c", yytext[contor++]);
                while (yytext[contor] != ' ')
                  contor++;
                contor++;
                while(yytext[contor] != '=') 
                  printf("%c", yytext[contor++]);
                
                printf("= ");
                contor += 2;

                if (yytext[contor] == 'n' && yytext[contor + 1] == 'e' && yytext[contor + 2] == 'w')
                  contor += 4;

                while (contor < strlen(yytext) - 1)
                  printf("%c", yytext[contor++]);
              } else {
				  	int contor = 0;
					while(contor < strlen(yytext) - 1){
						printf("%c", yytext[contor]);
						contor++;
					}
			  }
			  return ASSIGN;
			}

{VOID}\( {  /*Verifica daca aceasta metoda este un void*/
            int contor = 5;
			printf("def ");	
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{STRINGVALUE} {  /*Verifica daca este o variabila definita ca si tipul de data String */
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": str");
			return PRIMITIVE_DATA_TYPE;}
{INTEGERVALUE} { /*Verifica daca este o variabila definita ca si tipul de data Integer */
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": int");
			return PRIMITIVE_DATA_TYPE;}
{FLOATVALUE} {   /*VVerifica daca este o variabila definita ca si tipul de data Float  */
            int contor = 6;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": float");
			return PRIMITIVE_DATA_TYPE;}
{DOUBLEVALUE} {  /*Verifica daca este o variabila definita ca si tipul de data Double */
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": float");
			return PRIMITIVE_DATA_TYPE;}		
{BOOLEANVALUE} { 
            /*Verifica daca este o variabila definita ca si tipul de data Boolean  */
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": bool");
			return PRIMITIVE_DATA_TYPE;}

{STRINGTYPE} { /*Verifica daca se intializeaza o variabila ca si un String*/
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{INTEGERTYPE} {/*VVerifica daca se intializeaza o variabila ca si un Integer*/ 
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{FLOATTYPE} {  /*Verifica daca se intializeaza o variabila ca si un Float*/ 
            int contor = 6;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{DOUBLETYPE} { /*Verifica daca se intializeaza o variabila ca si un Double*/ 
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}		
{BOOLEANTYPE} {/*Verifica daca se intializeaza o variabila ca si un Boolean*/ 
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}			
	
{STRINGVALUE}\( {/*Verifica daca aceasta metoda va intoarce un String*/ 
            int contor = 7;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			
			return PRIMITIVE_DATA_TYPE;}
{INTEGERVALUE}\( {/*Verifica daca aceasta metoda va intoarce un Integer */  
            int contor = 8;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{FLOATVALUE}\( { /*Verifica daca aceasta metoda va intoarce un Float */   
            int contor = 6;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}
{DOUBLEVALUE}\( {/*Verifica daca aceasta metoda va intoarce un Double */   
            int contor = 7;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}		
{BOOLEANVALUE}\( {/*Verifica daca aceasta metoda va intoarce un Boolean */  
            int contor = 8;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return PRIMITIVE_DATA_TYPE;}	

"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" {return yytext[0];}

[0-9]+ {	/*Verificare numar natural*/
            printf("%s", yytext);
			return VALUE;}

[0-9]+"."+[0-9]+ {/*Verificare numar flotant*/
                    return FLOTANT_VALUE;}

{IF}\) {/*Verificare pentru sturctura if*/	
        printf("%s:", yytext);
		return IF;}

{MAIN} {/*Verificare functie main*/
            return MAIN;}




{THROWS} {  /*Se verifica dac ase arunca o exceptie*/
            return EXCEPTION;}



{PRINT} { /*Se verifica daca se va face printarea in cod a unei variabile sa a unui text*/
            printf("print(");
		  int contor = 17;
			while(contor < strlen(yytext)) {
				printf("%c", yytext[contor]);
                contor++;
			}
			return PRINT;
		}

{WHILE} {	/*Verifica daca este o instructiune de tip while*/
            int contor = 0;
			while ( yytext[contor] != '(') {
				printf("%c", yytext[contor]);
				contor++;
			}
			contor++;
			while ( yytext[contor] != ')') {
				printf("%c", yytext[contor]);
				contor++;
			}
			contor++;
			return WHILE;
		}


"else" { /*Verifica daca am ajuns pe ramura de else a blocului if*/ 
         printf("%s:", yytext);
		 return ELSE;}

{FOR} { /*Verifica daca este o intructiune for*/
		printf("for ");
		int contor = 4;
		while (yytext[contor] != ' ') {
			printf("%c", yytext[contor]);
            contor++;
		}
		contor+=3;
		printf(" in range(");
		while (yytext[contor + 1] != ' ') {
			printf("%c", yytext[contor]);
            contor++;
		}
		printf(", ");
 		contor++;
		while (yytext[contor] != '<' && yytext[contor] != '>') {
            contor++;
		}
		contor++;
		if (yytext[contor] == '=')
			contor++;
		contor++;
		while (yytext[contor + 1] != ' ') {
			printf("%c", yytext[contor]);
            contor++;
		}
		printf(")");
		return FOR;}

"returneaza" {return RETURNEAZA;}
";" {return EOL;}


{FUNCWITOUTPARAM}\; {  /*Verifica daca se invoca o metoda fara parametrii de catre o instanta*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			
			return FUNCTION;		
		}

{FUNCWITHPARAM}\; { /*Verifica daca se invoca o metoda cu parametrii de catre o instanta*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTION;
		}

{STATICFUNCWITHOUTPARAM}\; { /*Verifica daca se invoca o metoda statica fara parametrii*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTION;		
		}

{STATICFUNCWITHPARAM}\; { /*Verifica daca se invoca o metoda statica cu parametrii*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTION;
		}

"\n" {}

%%
/*Aceasta functie verifica daca exista doua cuvinte inainte si dupa egal*/
int checkSpace(char *s){
    int contor = 0;
    int word = 0;
    while (s[contor] == ' ')
      contor++;
    while (s[contor] != '=') {
        while (s[contor] != ' ' && s[contor] != '=') {
            contor++;
        }
        word++;
        contor++;
    }
    if (word == 2)
        return 1;
    else
        return 0;
}