%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include "y.tab.h"
	
	int yylex(void);
	int yyerror(const char* s);
	
	/*Folosim acest contor pentru a tine cont cand a fost terminat corpul unei clase sau al unei metode*/
	int counter = 0;
%}
/*Declaram tokenii care sunt returnati din fisierul lex*/
%token  USING PRIMITIVE_DATA_TYPE VALOARE VALOARE_FLOTANTA DACA ALTFEL PENTRU CAT_TIMP RETURNEAZA FUNCTIE_PRINCIPALA EOL COMPARATORI NAMESPACE CLASA CONSTRUCTOR CONSTRUCTOR2 EXCEPTIE AFISARE ASIGNARE FUNCTIE FUNCTIE2 ASIG RETURNT

%%
	/*Daca este declarat un pachet, urmat de EOL, adica ";", se urmareste daca in continuare are loc includerea unor biblioteci*/
	check_includere: | USING EOL {;} check_includere
					   | check_namespace ;

	/*Daca este o linie care contine import-ul unei biblioteci, urmat de ";", se continua sa se verifice daca si pe urmatoarea linie exista un import, sau declararea antetului unei clase*/
	check_namespace: 
			| NAMESPACE EOL {;} check_namespace
			| check_clasa check_namespace
			;

	/*Daca linia curenta contine antetul unei clase, se verifica in continuare daca urmatoarea linie contine un constructor sau declarari de field-uri*/		
	check_clasa:
			| CLASA {;} check_body
			| check_constructor
			| initialize_variabile
			;

    /*Daca linia curenta este un constructor se va verifica daca pe linia urmatoare urmeaza o declarare de variabila, */
	check_constructor:
			| CONSTRUCTOR {printf("):\n");} check_body_constructor
			| CONSTRUCTOR2 '(' lista_param ')' {printf("):\n");} check_body_constructor
			| initialize_variabile
			| check_functie
			| check_main
			| check_constructor
			;	

	/*Se verifica daca antetul unei metode este de forma: un singur parametru urmat de paranteza care inchide lista de parametrii, o lsta de parametrii si paranteza care marcheaza inchiderea listei de parametrii
	  sau daca metoda arunca si o exceptie */
	check_functie:
			| PRIMITIVE_DATA_TYPE ')' {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE lista_param ')' {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE ')' EXCEPTIE {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE lista_param ')' EXCEPTIE {printf("):\n");} check_body
			| check_main
			;

	/*Se verifica daca o variabila este singulara, sau aceasta face parte dintr-o lista(este urmata de o virgula), 
	iar in acest caz se va atasa o virgula dupa aceasta(in cazul listelor de paraametrii pentru metode si constructori)*/
	lista_param:
			| PRIMITIVE_DATA_TYPE {;}
			| PRIMITIVE_DATA_TYPE',' {printf(", ");} lista_param 
			;

	/*Se verifica daca incepe metoda principala: main-ul si scrie in fisierul de iesire sintaxa de definire a functiei main in Python si continua pentru linia urmatoare cu checka continutului acestei metode*/
	check_main: 
			| FUNCTIE_PRINCIPALA {printf("def main() :");} check_body_main
			;

	/*Se verifica daca s-a intalnit in cod o asignare sau o initializare/declarare a unei variabile, daca am ajuns la un return, se arunca o exceptie, daca se face o afisare, daca exista un corp de try catch sau 
	daca este invocata o functie */
	initialize_variabile:  
			| ASIG {printf("\n");} 
			| PRIMITIVE_DATA_TYPE EOL {printf("\n");}
			| RETURNT EOL {printf("\n");}
			| AFISARE EOL {printf("\n");}
			| FUNCTIE {printf("\n");} 
			| initialize_variabile EOL {;}
			| check_constructor {;}
			;

	/*Se verifica daca s-a intalnit in cod o asignare sau o initializare/declarare a unei variabile*/			
	initialize_variabile_op:  
			| ASIG {printf("\n");} initialize_variabile_op
			| PRIMITIVE_DATA_TYPE EOL {printf("\n");} initialize_variabile_op
			| check_body_operations
			;

	/*Se verifica daca a fost intalnita o structura speciala: alternativa, repetitiva:for, while sau o structura de tip try-catch*/		
	check_operations:
			| DACA {printf("\n");} check_body_operations
			| ALTFEL {printf("\n");} check_body_operations
			| CAT_TIMP {printf(":");} check_body_operations
			| PENTRU {printf(":\n");} check_body_operations
			;

	/*Se verifica daca pe linia curenta incepe corpul unei metode/clase, daca au loc structuri alternative sau secventiale, declarari/initializari de variabile sau sfarsitul unui corp de cod*/		
	check_body:
			| '{\n' {counter++;} check_body
			| check_operations check_body
			| initialize_variabile check_body
			| '}\n' {counter--; if(counter == 1) {printf("\n");}} check_functie
			;

	/*Se verifica corpul unui constructor: "{" - inceputul acestuia, checka operationslor care ar putea face parte din corpul constructorului, initializarea diverselor field-uri ale unei obiect nou creat,
	  "}" - finalul constructorului*/
	check_body_constructor:
			| '{\n' {counter++;} check_body_constructor
			| check_operations check_body_constructor
			| initialize_variabile check_body_constructor
			| '}\n' {counter--; if(counter == 1) {printf("\n");}} check_constructor;
			;

	/*Se verifica corpul unei metode/structuri: inceputul acesteia marcat de "}", finalul acesteia "{", initializarea/declararea unor variabile sau o stuctura alternativa, repetitiva sau de tip try-catch */		
	check_body_operations:
			| '{\n' {counter++;} check_body_operations
			| initialize_variabile check_body_operations
			| check_operations check_body_operations
			| '}\n' {counter--;} check_operations
			;	

	/*Se verifica continutul metodei principale "main" si se verifica daca linia curenta este "{", care marcheaza inceputul metodei, o stuctura alternativa, repetitiva sau de tip try-catch, o declarare/initializare 
	  de variabile sau "}" care marcheaza finalul acestei metode, caz in care se va returna 0 pentru a opri si programul curent, marcand astfel finalul programului*/
	check_body_main:
			| '{\n' {counter++; printf("\n");} check_body_main
			| check_operations check_body_main
			| initialize_variabile check_body_main
			| '}\n' {counter--; if(counter == 1) {printf("\n"); return 0;}} check_main
			;		

%%

int main()
{
	yyparse();
}

int yyerror(const char* s)
{
	/*In cazul in care sitaxa din fisierul de intrare nu este corespunzatoare, atunci se va scrie in fisierul de iesire la ce linie a aparut eroarea*/
	extern int yylineno;
	printf("Eroare la linia %d\n", yylineno);
	return 0;
}