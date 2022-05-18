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
/*Se declara tokenii care provin din fisierul lex/
%token USING TIP_PRIMITIV VALOARE VALOARE_FLOTANTA DACA ALTFEL PENTRU CAT_TIMP RETURNEAZA FUNCTIE_PRINCIPALA EOL COMPARATORI NAMESPACE CLASA EXCEPTIE AFISARE ASIGNARE FUNCTIE FUNCTIE2 ASIG RETURNT GETSET

%%


	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut,daca se face vreun return, sau daca se apeleaza o functie */
	initialize_variables:  
			| ASIG {printf("\n");} 
			| GETSET {printf("\n");} 
			| TIP_PRIMITIV EOL {printf("\n");}
			| RETURNT EOL {printf("\n");}
			| AFISARE EOL {printf("\n");}
			| FUNCTIE {printf("\n");} 
			| initialize_variables EOL {;}
			| check_constructor {;}
			;

	/*Aici se face verificarea pentru o asignare sau o declarare a unui atribut*/			
	initialize_variables_operations:  
			| ASIG {printf("\n");} initialize_variables_operations
			| TIP_PRIMITIV EOL {printf("\n");} initialize_variables_operations
			| check_body_operations
			;

	/*Aici se face verificarea pentru un block de if else, while si for*/		
	check_operations:
			| DACA {printf("\n");} check_body_operations
			| ALTFEL {printf("\n");} check_body_operations
			| CAT_TIMP {printf(":");} check_body_operations
			| PENTRU {printf(":\n");} check_body_operations
			;

	/*Aici se verifica daca incepe o clasa sau o metoda sau sfarsitul unei bucati de cod*/		
	check_body:
			| '{\n' {counter++;} check_body
			| check_operations check_body
			| initialize_variables check_body
			| '}\n' {counter--; if(counter == 1) {printf("\n");}} check_functie
			;



	/* Aici se face verificarea pentru corupul unei metode care incepe cu { si se termina cu } */		
	check_body_operations:
			| '{\n' {counter++;} check_body_operations
			| initialize_variables check_body_operations
			| check_operations check_body_operations
			| '}\n' {counter--;} check_operations
			;	

	/* Se face verificarea pentru metoda main care  incepe cu { si se termina cu }*/
		check_body_main:
			| '{\n' {counter++; printf("\n");} check_body_main
			| check_operations check_body_main
			| initialize_variables check_body_main
			| '}\n' {counter--; if(counter == 1) {printf("\n"); return 0;}} check_main_function
			;		

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
			| CLASA {;} check_body
			| check_constructor
			| initialize_variables
			;

	

	/* Aici se verifica tiul functiei, daca are parametrii sau nu , daca se arunca vreo exceptie */
	check_functie:
			| TIP_PRIMITIV ')' {printf("):\n");} check_body
			| TIP_PRIMITIV parameters ')' {printf("):\n");} check_body
			| TIP_PRIMITIV ')' EXCEPTIE {printf("):\n");} check_body
			| TIP_PRIMITIV parameters ')' EXCEPTIE {printf("):\n");} check_body
			| check_main_function
			;

	/* Se verifica un atribut sau o variabila daca este singulara sau nu, iar daca nu inseamna ca e o lista de parametri folosita pt metode*/
	parameters:
			| TIP_PRIMITIV {;}
			| TIP_PRIMITIV',' {printf(", ");} parameters 
			;

	/*Se verifica daca incepe metoda principala: main-ul si scrie in fisierul de iesire sintaxa de definire a functiei main in Python*/
	check_main_function: 
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
