%option yylineno

%{
	#include <stdio.h>
	#include "cparser.tab.h"
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
DOUBLE "Double"[ A-Za-z_0-9]+
BOOLEAN "Boolean"[ A-Za-z_0-9]+
STRINGE "String"[ A-Za-z_="]+{NUMBER}
INTEGERE "Integer"[ A-Za-z_=]+{NUMBER}
FLOATE "Float"[ A-Za-z_=]+{float}
DOUBLEE "Double"[ A-Za-z_=]+{float}
BOOLEANE "Boolean"[ A-Za-z_=]+{NUMBER}
CONSTRUCT [A-Za-z_]+"()"
CONSTRUCT2 [A-Za-z_]+
FUNC [A-Za-z_]+"."[A-Za-z_]+"()"
FUNC2 [A-Za-z_]+"."[A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
FUNC3 [A-Za-z_]+"()"
FUNC4 [A-Za-z_]+"("[ 0-9A-Za-z_,]+")"
INSTANCE [ 0-9A-Za-z_]+"="[ 0-9A-Za-z_()+."]+[;]
IF "if ("[A-Za-z_> <=!.()]+
WHILE "while ("[A-Za-z_> <=!.0-9]+")"
FOR "for("[0-9 A-Za-z_><=!;+-]+")"
THROWS " throws"[ A-Za-z,]+
THROW "throw new "[A-Za-z()" ]+
PRINT "System.out.print("[ .()A-Za-z" 0-9+-=]+")"
CATCH "} catch ("[A-Za-z()" ]+")"


%%


{NAMESPACE} { /*Token-ul returnat in cazul in care se face match pe regex-ul pentru declararea pachetului*/
            return NAMESPACE;}

{USING} {	/*Returnarea token-ului pentru liniile de cod in care se face match cu regex-ul de importare a unor biblioteci*/
            printf("%s\n", yytext);
			return USING;}

{CLASS}  {	/*Returnarea token-ului pentru liniile in care se face match cu regex-ul de declarare a antetului unei clase*/
            /*Se printeaza toata linia, mai putin "{", care va fi inlocuita de ":", caracteristica specifica sintaxei Python*/
            int index = 0;
            while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(":\n");

			strcpy(className, yytext + 6);
			return CLASA; }

{INTERFACE} { /*Returneaza token-ul pentru liniile de cod in care se face match cu regex-ul de declarare a antetului unei interfete
                Se va returna si in acest caz token-ul CLASA, deoarece in Python nu exista interfete, doar clase*/
              int index = 9;
              printf("class");
              while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
              printf(":\n");
			  return CLASA;
            }

{PUBLIC}" " {
                /*Cand intalneste modificatorii de acces ii ignora si verifica ce este in continuare*/
            }
{PRIVATE}" " {}
{PROTECTED}" " {}

{STATIC}" " { /*Cand intalneste proprietatea de "static" a unui field sau a unei metode o ignora si continua*/ }

{RETURN} { /*Cand se face match cu regex-ul pentru "return" in cadrul unei metode se va transmite token-ul corespunzator si se va printa linia de cod care returneaza rezultatul metodei respective*/
			int index = 0;
			while(index < strlen(yytext)){
				printf("%c", yytext[index]);
				index++;
			}
			return RETURNT;
		}
{INSTANCE} { 	/*Cand se face match cu regex-ul de instanta a unui obiect se va afisa in fisierul de iesire doar numele noului obiect creat si numle clasei urmat de doua paranteze si se returneaza token-ul corespunzator*/
                int rez = checkTwoWords(yytext);
              if (rez == 1) {
                int index = 0;
                while (yytext[index] == ' ')
                  printf("%c", yytext[index++]);
                while (yytext[index] != ' ')
                  index++;
                index++;
                while(yytext[index] != '=') 
                  printf("%c", yytext[index++]);
                
                printf("= ");
                index += 2;

                if (yytext[index] == 'n' && yytext[index + 1] == 'e' && yytext[index + 2] == 'w')
                  index += 4;

                while (index < strlen(yytext) - 1)
                  printf("%c", yytext[index++]);
              } else {
				  	int index = 0;
					while(index < strlen(yytext) - 1){
						printf("%c", yytext[index]);
						index++;
					}
			  }
			  return ASIG;
			}

{VOID}\( {  /*Verifica daca este o metoda definita ca si void */
            int index = 5;
			printf("def ");	
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{STRING} {  /*Verifica daca este o variabila definita ca si String */
            int index = 7;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(": str");
			return TIP_PRIMITIV;}
{INTEGER} { /*Verifica daca este o variabila definita ca si Integer */
            int index = 8;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(": int");
			return TIP_PRIMITIV;}
{FLOAT} {   /*Verifica daca este o variabila definita ca si Float */
            int index = 6;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(": float");
			return TIP_PRIMITIV;}
{DOUBLE} {  /*Verifica daca este o variabila definita ca si Double */
            int index = 7;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(": float");
			return TIP_PRIMITIV;}		
{BOOLEAN} { 
            /*Verifica daca este o variabila definita ca si Boolean */
            int index = 8;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
            printf(": bool");
			return TIP_PRIMITIV;}

{STRINGE} { /*Verifica daca este o variabila definita ca si String care este initializata la o valoare*/
            int index = 7;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{INTEGERE} {/*Verifica daca este o variabila definita ca si Integer care este initializata la o valoare*/ 
            int index = 8;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{FLOATE} {  /*Verifica daca este o variabila definita ca si Float care este initializata la o valoare*/ 
            int index = 6;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{DOUBLEE} { /*Verifica daca este o variabila definita ca si Double care este initializata la o valoare*/ 
            int index = 7;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}		
{BOOLEANE} {/*Verifica daca este o variabila definita ca si Boolean care este initializata la o valoare*/ 
            int index = 8;
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}			
	
{STRING}\( {/*Verifica daca este o metoda care va intoarce un String */ 
            int index = 7;
			printf("def ");
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			
			return TIP_PRIMITIV;}
{INTEGER}\( {/*Verifica daca este o metoda care va intoarce un Integer */  
            int index = 8;
			printf("def ");
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{FLOAT}\( { /*Verifica daca este o metoda care va intoarce un Float */   
            int index = 6;
			printf("def ");
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}
{DOUBLE}\( {/*Verifica daca este o metoda care va intoarce un Double */   
            int index = 7;
			printf("def ");
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return TIP_PRIMITIV;}		
{BOOLEAN}\( {/*Verifica daca este o metoda care va intoarce un Boolean */  
            int index = 8;
			printf("def ");
            while (index < strlen(yytext)) {
                  printf("%c", yytext[index]);
                  index++;
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

{THROW} {    /*Face throw unei noi exceptii*/
			printf("raise ");
			int index = 10;
			while(index < strlen(yytext)) {
				printf("%c", yytext[index]);
                index++;
			}
			return EXCEPTIET;
		}

{PRINT} { /*Cand se face match cu regex-ul de printare corespunzatror modului de apelare a metodei corespunzatoare din limbajul java, se va scrie in fisierul de iesire numele metodei corespunzatoare din Python (print)
  urmat de aceeasi parametrii pe care ii primeste si metoda din limbajul Java*/
            printf("print(");
		  int index = 17;
			while(index < strlen(yytext)) {
				printf("%c", yytext[index]);
                index++;
			}
			return AFISARE;
		}

{WHILE} {	/*Verifica daca este o instructiune de tip while*/
            int index = 0;
			while ( yytext[index] != '(') {
				printf("%c", yytext[index]);
				index++;
			}
			index++;
			while ( yytext[index] != ')') {
				printf("%c", yytext[index]);
				index++;
			}
			index++;
			return CAT_TIMP;
		}

"try {" { 	/*Cand se face match cu inceperea unei structuri de tip try-catch se va scrie in fisierul sursa exact aceeasi linei de cod, inlocuind "{" cu ":" asa cum este specific limbajului Python*/
            printf("try:\n"); 
			return TRY;
		}

{CATCH} {  /*Cand se face match cu partea de catch din structura de tip try-catch se va scrie in fisierul sursa exact aceeasi linei de cod, inlocuind "{" cu ":" asa cum este specific limbajului Python*/
			printf("except ");
			int index = 9;
			while(index < strlen(yytext) - 3 && yytext[index] != ' ') {
				printf("%c", yytext[index]);
                index++;
			}
			printf(":");
			return CATCH;
		}

"else" { /*Verifica daca am ajuns pe ramura de else*/ 
         printf("%s:", yytext);
		 return ALTFEL;}

{FOR} { /*Verifica daca este o intructiune for*/
		printf("for ");
		int index = 4;
		while (yytext[index] != ' ') {
			printf("%c", yytext[index]);
            index++;
		}
		index+=3;
		printf(" in range(");
		while (yytext[index + 1] != ' ') {
			printf("%c", yytext[index]);
            index++;
		}
		printf(", ");
 		index++;
		while (yytext[index] != '<' && yytext[index] != '>') {
            index++;
		}
		index++;
		if (yytext[index] == '=')
			index++;
		index++;
		while (yytext[index + 1] != ' ') {
			printf("%c", yytext[index]);
            index++;
		}
		printf(")");
		return PENTRU;}

"returneaza" {return RETURNEAZA;}
";" {return EOL;}

{CONSTRUCT} {   /*Verifica daca este un constructor fara parametrii*/
				if (yytext[0] != 'c' && yytext[0] >= 'A' && yytext[0] <= 'Z') {
					printf("def __init__(self");
					return CONSTRUCTOR;
				} 
			}

{CONSTRUCT2} { /*Verifica daca este un constructor cu parametrii*/
				if (yytext[0] != 'c' && yytext[0] >= 'A' && yytext[0] <= 'Z') {
					printf("def __init__(self, ");
					return CONSTRUCTOR2;
				} 
			}

{FUNC}\; {  /*Verifica daca se invoca o metoda fara parametrii de catre o instanta*/
			int index = 0;
            while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
			
			return FUNCTIE;		
		}

{FUNC2}\; { /*Verifica daca se invoca o metoda cu parametrii de catre o instanta*/
			int index = 0;
            while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return FUNCTIE;
		}

{FUNC3}\; { /*Verifica daca se invoca o metoda statica fara parametrii*/
			int index = 0;
            while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return FUNCTIE;		
		}

{FUNC4}\; { /*Verifica daca se invoca o metoda statica cu parametrii*/
			int index = 0;
            while (index < strlen(yytext) - 1) {
                  printf("%c", yytext[index]);
                  index++;
              }
			return FUNCTIE;
		}

"\n" {}

%%
/*Aceasta functie verifica daca exista doua cuvinte inainte si dupa egal*/
int checkTwoWords(char *s){
    int index = 0;
    int word = 0;
    while (s[index] == ' ')
      index++;
    while (s[index] != '=') {
        while (s[index] != ' ' && s[index] != '=') {
            index++;
        }
        word++;
        index++;
    }
    if (word == 2)
        return 1;
    else
        return 0;
}