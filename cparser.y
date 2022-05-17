%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include "cparser.tab.h"
	
	int yylex(void);
	int yyerror(const char* s);
	
	/*Folosim acest contor pentru a tine cont cand a fost terminat corpul unei clase sau al unei metode*/
	int contor_paranteze = 0;
%}
/*Declaram tokenii care sunt returnati din fisierul lex*/
%token  USING TIP_PRIMITIV VALOARE VALOARE_FLOTANTA DACA ALTFEL PENTRU CAT_TIMP RETURNEAZA FUNCTIE_PRINCIPALA EOL COMPARATORI NAMESPACE CLASA CONSTRUCTOR CONSTRUCTOR2 EXCEPTIE EXCEPTIET AFISARE TRY CATCH ASIGNARE FUNCTIE FUNCTIE2 ASIG RETURNT

%%
	/*Daca este declarat un pachet, urmat de EOL, adica ";", se urmareste daca in continuare are loc includerea unor biblioteci*/
	verificare_includere: | USING EOL {;} verificare_includere
					   | verificare_namespace ;

	/*Daca este o linie care contine import-ul unei biblioteci, urmat de ";", se continua sa se verifice daca si pe urmatoarea linie exista un import, sau declararea antetului unei clase*/
	verificare_namespace: 
			| NAMESPACE EOL {;} verificare_namespace
			| verificare_clasa verificare_namespace
			;

	/*Daca linia curenta contine antetul unei clase, se verifica in continuare daca urmatoarea linie contine un constructor sau declarari de field-uri*/		
	verificare_clasa:
			| CLASA {;} verificare_body
			| verificare_constructor
			| init_variabile
			;

    /*Daca linia curenta este un constructor se va verifica daca pe linia urmatoare urmeaza o declarare de variabila, */
	verificare_constructor:
			| CONSTRUCTOR {printf("):\n");} verificare_body_constructor
			| CONSTRUCTOR2 '(' lista_param ')' {printf("):\n");} verificare_body_constructor
			| init_variabile
			| verificare_functie
			| verificare_main
			| verificare_constructor
			;	

	/*Se verifica daca antetul unei metode este de forma: un singur parametru urmat de paranteza care inchide lista de parametrii, o lsta de parametrii si paranteza care marcheaza inchiderea listei de parametrii
	  sau daca metoda arunca si o exceptie */
	verificare_functie:
			| TIP_PRIMITIV ')' {printf("):\n");} verificare_body
			| TIP_PRIMITIV lista_param ')' {printf("):\n");} verificare_body
			| TIP_PRIMITIV ')' EXCEPTIE {printf("):\n");} verificare_body
			| TIP_PRIMITIV lista_param ')' EXCEPTIE {printf("):\n");} verificare_body
			| verificare_main
			;

	/*Se verifica daca o variabila este singulara, sau aceasta face parte dintr-o lista(este urmata de o virgula), 
	iar in acest caz se va atasa o virgula dupa aceasta(in cazul listelor de paraametrii pentru metode si constructori)*/
	lista_param:
			| TIP_PRIMITIV {;}
			| TIP_PRIMITIV',' {printf(", ");} lista_param 
			;

	/*Se verifica daca incepe metoda principala: main-ul si scrie in fisierul de iesire sintaxa de definire a functiei main in Python si continua pentru linia urmatoare cu verificarea continutului acestei metode*/
	verificare_main: 
			| FUNCTIE_PRINCIPALA {printf("def main() :");} verificare_body_main
			;

	/*Se verifica daca s-a intalnit in cod o asignare sau o initializare/declarare a unei variabile, daca am ajuns la un return, se arunca o exceptie, daca se face o afisare, daca exista un corp de try catch sau 
	daca este invocata o functie */
	init_variabile:  
			| ASIG {printf("\n");} 
			| TIP_PRIMITIV EOL {printf("\n");}
			| RETURNT EOL {printf("\n");}
			| AFISARE EOL {printf("\n");}
			| FUNCTIE {printf("\n");} 
			| init_variabile EOL {;}
			| verificare_constructor {;}
			;

	/*Se verifica daca s-a intalnit in cod o asignare sau o initializare/declarare a unei variabile*/			
	init_variabile_op:  
			| ASIG {printf("\n");} init_variabile_op
			| TIP_PRIMITIV EOL {printf("\n");} init_variabile_op
			| verificare_body_operatii
			;

	/*Se verifica daca a fost intalnita o structura speciala: alternativa, repetitiva:for, while sau o structura de tip try-catch*/		
	verificare_operatii:
			| DACA {printf("\n");} verificare_body_operatii
			| ALTFEL {printf("\n");} verificare_body_operatii
			| CAT_TIMP {printf(":");} verificare_body_operatii
			| PENTRU {printf(":\n");} verificare_body_operatii
			| CATCH {printf("\n");} verificare_body_operatii
			;

	/*Se verifica daca pe linia curenta incepe corpul unei metode/clase, daca au loc structuri alternative sau secventiale, declarari/initializari de variabile sau sfarsitul unui corp de cod*/		
	verificare_body:
			| '{\n' {contor_paranteze++;} verificare_body
			| verificare_operatii verificare_body
			| init_variabile verificare_body
			| '}\n' {contor_paranteze--; if(contor_paranteze == 1) {printf("\n");}} verificare_functie
			;

	/*Se verifica corpul unui constructor: "{" - inceputul acestuia, verificarea operatiilor care ar putea face parte din corpul constructorului, initializarea diverselor field-uri ale unei obiect nou creat,
	  "}" - finalul constructorului*/
	verificare_body_constructor:
			| '{\n' {contor_paranteze++;} verificare_body_constructor
			| verificare_operatii verificare_body_constructor
			| init_variabile verificare_body_constructor
			| '}\n' {contor_paranteze--; if(contor_paranteze == 1) {printf("\n");}} verificare_constructor;
			;

	/*Se verifica corpul unei metode/structuri: inceputul acesteia marcat de "}", finalul acesteia "{", initializarea/declararea unor variabile sau o stuctura alternativa, repetitiva sau de tip try-catch */		
	verificare_body_operatii:
			| '{\n' {contor_paranteze++;} verificare_body_operatii
			| init_variabile verificare_body_operatii
			| verificare_operatii verificare_body_operatii
			| '}\n' {contor_paranteze--;} verificare_operatii
			;	

	/*Se verifica continutul metodei principale "main" si se verifica daca linia curenta este "{", care marcheaza inceputul metodei, o stuctura alternativa, repetitiva sau de tip try-catch, o declarare/initializare 
	  de variabile sau "}" care marcheaza finalul acestei metode, caz in care se va returna 0 pentru a opri si programul curent, marcand astfel finalul programului*/
	verificare_body_main:
			| '{\n' {contor_paranteze++; printf("\n");} verificare_body_main
			| verificare_operatii verificare_body_main
			| init_variabile verificare_body_main
			| '}\n' {contor_paranteze--; if(contor_paranteze == 1) {printf("\n"); return 0;}} verificare_main
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
