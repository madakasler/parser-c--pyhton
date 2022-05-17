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
INTERFACE "interface"[ A-Za-z_]+
RETURN "return "[ 0-9A-Za-z_]+
NAMESPACE "namespace"[ A-Za-z_.]+
PUBLIC "public"
PRIVATE "private"
PROTECTED "protected"
STATIC "static"
MAIN "public static void main(String[] args)"
MAINTHROWS "public static void main(String[] args) throws"[ A-Za-z_,]+
VOID "void"[ A-Za-z_0-9]+
STRING "String"[ A-Za-z_0-9]+
INTEGER "Integer"[ A-Za-z_0-9]+
FLOAT "Float"[ A-Za-z_0-9]+
GETSET "{ get; set; }"
DOUBLE "Double"[ A-Za-z_0-9]+
BOOLEAN "Boolean"[ A-Za-z_0-9]+
STRINGE "String"[ A-Za-z_="]+{NUMBER}
INTEGERE "Integer"[ A-Za-z_=]+{NUMBER}
FLOATE "Float"[ A-Za-z_=]+{float}
DOUBLEE "Double"[ A-Za-z_=]+{float}
BOOLEANE "Boolean"[ A-Za-z_=]+{NUMBER}
FUNC [A-Za-z_]+"."[A-Za-z_]+"()"
FUNC2 [A-Za-z_]+"."[A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
FUNC3 [A-Za-z_]+"()"
FUNC4 [A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
INSTANCE [ 0-9A-Za-z_]+"="[ 0-9A-Za-z_()+."]+[;]
IF "if ("[A-Za-z_> <=!.()]+
WHILE "while ("[A-Za-z_> <=!.0-9]+")"
FOR "for("[0-9 A-Za-z_><=!;+-]+")"
THROWS " throws"[ A-Za-z,]+
PRINT "System.out.print("[ .()A-Za-z" 0-9+-=]+")"



%%


{NAMESPACE} { /*Token-ul returnat in cazul in care se face match pe regex-ul pentru declararea pachetului*/
            return NAMESPACE;}

{USING} {	/*Returnarea token-ului pentru liniile de cod in care se face match cu regex-ul de importare a unor biblioteci*/
            printf("%s\n", yytext);
			return USING;}

{CLASS}  {	/*Returnarea token-ului pentru liniile in care se face match cu regex-ul de declarare a antetului unei clase*/
            /*Se printeaza toata linia, mai putin "{", care va fi inlocuita de ":", caracteristica specifica sintaxei Python*/
            int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(":\n");

			strcpy(className, yytext + 6);
			return CLASA; }

{INTERFACE} { /*Returneaza token-ul pentru liniile de cod in care se face match cu regex-ul de declarare a antetului unei interfete
                Se va returna si in acest caz token-ul CLASA, deoarece in Python nu exista interfete, doar clase*/
              int contor = 9;
              printf("class");
              while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
              printf(":\n");
			  return CLASA;
            }

{PUBLIC}" " {
                /*Cand intalneste modificatorii de acces ii ignora si verifica ce este in continuare*/
            }
{PRIVATE}" " {}
{PROTECTED}" " {}


{GETSET} { return GETSET;}

{STATIC}" " { /*Cand intalneste proprietatea de "static" a unui field sau a unei metode o ignora si continua*/ }

{RETURN} { /*Cand se face match cu regex-ul pentru "return" in cadrul unei metode se va transmite token-ul corespunzator si se va printa linia de cod care returneaza rezultatul metodei respective*/
			int contor = 0;
			while(contor < strlen(yytext)){
				printf("%c", yytext[contor]);
				contor++;
			}
			return RETURNT;
		}
{INSTANCE} { 	/*Cand se face match cu regex-ul de instanta a unui obiect se va afisa in fisierul de iesire doar numele noului obiect creat si numle clasei urmat de doua paranteze si se returneaza token-ul corespunzator*/
                int rez = checkTwoWords(yytext);
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
			  return ASIG;
			}

{VOID}\( {  /*Verifica daca este o metoda definita ca si void */
            int contor = 5;
			printf("def ");	
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{STRING} {  /*Verifica daca este o variabila definita ca si String */
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": str");
			return TIP_PRIMITIV;}
{INTEGER} { /*Verifica daca este o variabila definita ca si Integer */
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": int");
			return TIP_PRIMITIV;}
{FLOAT} {   /*Verifica daca este o variabila definita ca si Float */
            int contor = 6;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": float");
			return TIP_PRIMITIV;}
{DOUBLE} {  /*Verifica daca este o variabila definita ca si Double */
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": float");
			return TIP_PRIMITIV;}		
{BOOLEAN} { 
            /*Verifica daca este o variabila definita ca si Boolean */
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
            printf(": bool");
			return TIP_PRIMITIV;}

{STRINGE} { /*Verifica daca este o variabila definita ca si String care este initializata la o valoare*/
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{INTEGERE} {/*Verifica daca este o variabila definita ca si Integer care este initializata la o valoare*/ 
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{FLOATE} {  /*Verifica daca este o variabila definita ca si Float care este initializata la o valoare*/ 
            int contor = 6;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{DOUBLEE} { /*Verifica daca este o variabila definita ca si Double care este initializata la o valoare*/ 
            int contor = 7;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}		
{BOOLEANE} {/*Verifica daca este o variabila definita ca si Boolean care este initializata la o valoare*/ 
            int contor = 8;
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}			
	
{STRING}\( {/*Verifica daca este o metoda care va intoarce un String */ 
            int contor = 7;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			
			return TIP_PRIMITIV;}
{INTEGER}\( {/*Verifica daca este o metoda care va intoarce un Integer */  
            int contor = 8;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{FLOAT}\( { /*Verifica daca este o metoda care va intoarce un Float */   
            int contor = 6;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}
{DOUBLE}\( {/*Verifica daca este o metoda care va intoarce un Double */   
            int contor = 7;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}		
{BOOLEAN}\( {/*Verifica daca este o metoda care va intoarce un Boolean */  
            int contor = 8;
			printf("def ");
            while (contor < strlen(yytext)) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return TIP_PRIMITIV;}	

"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" {return yytext[0];}

[0-9]+ {	/*Cand se face match pe un numar natural, valoarea acestuia este scrisa in fisierul de iesire asa cum este intalnita si in fisierul de intrare si se returneaza si un token corespunzator*/
            printf("%s", yytext);
			return VALOARE;}

[0-9]+"."+[0-9]+ {/*Cand se face match pe un numar flotant, valoarea acestuia este scrisa in fisierul de iesire asa cum este intalnita si in fisierul de intrare si se returneaza si un token corespunzator*/
                    return VALOARE_FLOTANTA;}

{IF}\) {/*Cand se face match cu regex-ul pentru inceperea structurii alternative if-else se scrie in fisierul de iesire conditia si se returneaza token-ul corespunztor*/	
        printf("%s:", yytext);
		return DACA;}

{MAIN} {/*Cand se face match cu regex-ul pentru definirea metodei principale a programului(main), se va returna token-ul corespunzator*/
            return FUNCTIE_PRINCIPALA;}

{MAINTHROWS} {  /*Vefica daca este metoda main si face throw la o exceptie sau mai multe*/
                return FUNCTIE_PRINCIPALA;}


{THROWS} {  /*Verfica daca se face throw unei exceptii in signaura metodei apelate*/
            return EXCEPTIE;}


{PRINT} { /*Cand se face match cu regex-ul de printare corespunzatror modului de apelare a metodei corespunzatoare din limbajul java, se va scrie in fisierul de iesire numele metodei corespunzatoare din Python (print)
  urmat de aceeasi parametrii pe care ii primeste si metoda din limbajul Java*/
            printf("print(");
		  int contor = 17;
			while(contor < strlen(yytext)) {
				printf("%c", yytext[contor]);
                contor++;
			}
			return AFISARE;
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
			return CAT_TIMP;
		}




"else" { /*Verifica daca am ajuns pe ramura de else*/ 
         printf("%s:", yytext);
		 return ALTFEL;}

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
		return PENTRU;}

"returneaza" {return RETURNEAZA;}
";" {return EOL;}



{FUNC}\; {  /*Verifica daca se invoca o metoda fara parametrii de catre o instanta*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			
			return FUNCTIE;		
		}

{FUNC2}\; { /*Verifica daca se invoca o metoda cu parametrii de catre o instanta*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTIE;
		}

{FUNC3}\; { /*Verifica daca se invoca o metoda statica fara parametrii*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTIE;		
		}

{FUNC4}\; { /*Verifica daca se invoca o metoda statica cu parametrii*/
			int contor = 0;
            while (contor < strlen(yytext) - 1) {
                  printf("%c", yytext[contor]);
                  contor++;
              }
			return FUNCTIE;
		}

"\n" {}

%%
/*Aceasta functie verifica daca exista doua cuvinte inainte si dupa egal*/
int checkTwoWords(char *s){
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