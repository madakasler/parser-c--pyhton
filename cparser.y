%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include "y.tab.h"
	
	int yylex(void);
	int yyerror(const char* s);
	
	/*Acest contor este folosit pentru a numara parantezele pentru a vedea daca o metoda este scrisa corect*/
	int counter = 0;
%}
/*Declaram tokenii care sunt returnati din fisierul lex*/
%token USING TIP_PRIMITIV VALOARE VALOARE_FLOTANTA DACA ALTFEL PENTRU CAT_TIMP RETURNEAZA FUNCTIE_PRINCIPALA EOL COMPARATORI NAMESPACE CLASA EXCEPTIE AFISARE ASIGNARE FUNCTIE FUNCTIE2 ASIG RETURNT GETSET

%%


	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut,daca se face vreun return, sau daca se apeleaza o functie */
	init_variabile:  
			| ASIG {printf("\n");} 
			| GETSET {printf("\n");} 
			| TIP_PRIMITIV EOL {printf("\n");}
			| RETURNT EOL {printf("\n");}
			| AFISARE EOL {printf("\n");}
			| FUNCTIE {printf("\n");} 
			| init_variabile EOL {;}
			| check_constructor {;}
			;

	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut*/			
	init_variabile_op:  
			| ASIG {printf("\n");} init_variabile_op
			| TIP_PRIMITIV EOL {printf("\n");} init_variabile_op
			| check_body_operatii
			;

	/*Aici se face verificarea pentru un block de if else, while si for*/		
	check_operatii:
			| DACA {printf("\n");} check_body_operatii
			| ALTFEL {printf("\n");} check_body_operatii
			| CAT_TIMP {printf(":");} check_body_operatii
			| PENTRU {printf(":\n");} check_body_operatii
			;

	/*Aici se verifica daca incepe o clasa sau o metoda sau sfarsitul unei bucati de cod*/		
	check_body:
			| '{\n' {counter++;} check_body
			| check_operatii check_body
			| init_variabile check_body
			| '}\n' {counter--; if(counter == 1) {printf("\n");}} check_functie
			;



	/* Aici se face verificarea pentru corupul unei metode care incepe cu { si se termina cu } */		
	check_body_operatii:
			| '{\n' {counter++;} check_body_operatii
			| init_variabile check_body_operatii
			| check_operatii check_body_operatii
			| '}\n' {counter--;} check_operatii
			;	

	/* Se face verificarea pentru metoda main care  incepe cu { si se termina cu }*/
		check_body_main:
			| '{\n' {counter++; printf("\n");} check_body_main
			| check_operatii check_body_main
			| init_variabile check_body_main
			| '}\n' {counter--; if(counter == 1) {printf("\n"); return 0;}} check_main
			;		

	/*Daca este declarat un using, urmat ";", adica daca se foloseste o alta clasa sau o librarie*/
	check_includere: | USING EOL {;} check_includere
					   | check_namespace ;

	/*Daca este o linie care contine namespace, adica numele pachetului din care face parte clasa*/
	check_namespace: 
			| NAMESPACE EOL {;} check_namespace
			| check_clasa check_namespace
			;

	/*Daca linia curenta contine antetul unei clase, se verifica in continuare daca urmatoarea linie contine un constructor sau declarari de field-uri*/		
	check_clasa:
			| CLASA {;} check_body
			| check_constructor
			| init_variabile
			;

	

	/* Aici se verifica tiul functiei, daca are parametrii sau nu , daca se arunca vreo exceptie */
	check_functie:
			| TIP_PRIMITIV ')' {printf("):\n");} check_body
			| TIP_PRIMITIV lista_param ')' {printf("):\n");} check_body
			| TIP_PRIMITIV ')' EXCEPTIE {printf("):\n");} check_body
			| TIP_PRIMITIV lista_param ')' EXCEPTIE {printf("):\n");} check_body
			| check_main
			;

	/* Se verifica un atribut sau o variabila daca este singulara sau nu, iar daca nu inseamna ca e o lista de parametri folosita pt metode*/
	lista_param:
			| TIP_PRIMITIV {;}
			| TIP_PRIMITIV',' {printf(", ");} lista_param 
			;

	/*Se verifica daca incepe metoda principala: main-ul si scrie in fisierul de iesire sintaxa de definire a functiei main in Python*/
	check_main: 
			| FUNCTIE_PRINCIPALA {printf("def main() :");} check_body_main
			;

%%

int main()
{
	yyparse();
}

int yyerror(const char* s)
{
	/*Se arata linia la care apare eroarea de sintaxa*/
	extern int yylineno;
	printf("Error at line %d\n", yylineno);
	return 0;
}
