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
/*Se declara tokenii care provin din fisierul lex*/
%token  USING PRIMITIVE_DATA_TYPE VALUE FLOTANT_VALUE IF ELSE FOR WHILE RETURNEAZA MAIN EOL NAMESPACE CLASS  EXCEPTION PRINT ASIGNARE FUNCTION ASSIGN RETURNT

%%
	/*Daca este declarat un using, urmat ";", adica daca se foloseste o alta clasa sau o librarie*/
	check_using: | USING EOL {;} check_using
					   | check_namespace ;

/*Daca este o linie care contine namespace, adica numele pachetului din care face parte clasa*/
	check_namespace: 
			| NAMESPACE EOL {;} check_namespace
			| check_class check_namespace
			;

	/*Daca linia curenta contine antetul unei clase, se verifica in continuare daca urmatoarea linie contine un constructor sau declarari de field-uri*/
	check_class:
			| CLASS {;} check_body
			| check_constructor
			| initialize_variabile
			;

    /*Daca linia curenta este un constructor se va verifica daca pe linia urmatoare urmeaza o declarare de variabila, */
	check_constructor:
			| initialize_variabile
			| check_functie
			| check_main
			| check_constructor
			;	

	/* Aici se verifica tiul functiei, daca are parametrii sau nu , daca se arunca vreo exceptie */
	check_functie:
			| PRIMITIVE_DATA_TYPE ')' {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE lista_param ')' {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE ')' EXCEPTION {printf("):\n");} check_body
			| PRIMITIVE_DATA_TYPE lista_param ')' EXCEPTION {printf("):\n");} check_body
			| check_main
			;

/* Se verifica un atribut sau o variabila daca este singulara sau nu, iar daca nu inseamna ca e o lista de parametri folosita pt metode*/
	lista_param:
			| PRIMITIVE_DATA_TYPE {;}
			| PRIMITIVE_DATA_TYPE',' {printf(", ");} lista_param 
			;

	/*Se verifica daca incepe metoda principala: main-ul si scrie in fisierul de iesire sintaxa de definire a functiei main in Python*/
	check_main: 
			| MAIN {printf("def main() :");} check_body_main
			;

	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut,daca se face vreun return, sau daca se apeleaza o functie */
	initialize_variabile:  
			| ASSIGN {printf("\n");} 
			| PRIMITIVE_DATA_TYPE EOL {printf("\n");}
			| RETURNT EOL {printf("\n");}
			| PRINT EOL {printf("\n");}
			| FUNCTION {printf("\n");} 
			| initialize_variabile EOL {;}
			| check_constructor {;}
			;

	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut*/		
	initialize_variabile_op:  
			| ASSIGN {printf("\n");} initialize_variabile_op
			| PRIMITIVE_DATA_TYPE EOL {printf("\n");} initialize_variabile_op
			| check_body_operations
			;

/*Aici se face verificarea pentru un block de if else, while si for*/			
	check_operations:
			| IF {printf("\n");} check_body_operations
			| ELSE {printf("\n");} check_body_operations
			| WHILE {printf(":");} check_body_operations
			| FOR {printf(":\n");} check_body_operations
			;

/*Aici se verifica daca incepe o clasa sau o metoda sau sfarsitul unei bucati de cod*/	
	check_body:
			| '{\n' {counter++;} check_body
			| check_operations check_body
			| initialize_variabile check_body
			| '}\n' {counter--; if(counter == 1) {printf("\n");}} check_functie
			;

	/* Aici se face verificarea pentru corupul unei metode care incepe cu { si se termina cu } */	
	check_body_operations:
			| '{\n' {counter++;} check_body_operations
			| initialize_variabile check_body_operations
			| check_operations check_body_operations
			| '}\n' {counter--;} check_operations
			;	
/* Se face verificarea pentru metoda main care  incepe cu { si se termina cu }*/
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