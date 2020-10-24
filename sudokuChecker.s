/********************************************************************************
*	Programme qui lit, affiche et vérifie un sudoku.                         	*
*	Auteur: Marc-Olivier Lacoste            									*
********************************************************************************/

.include "/root/SOURCES/ift209/tools/ift209.as"

.global Main
.section ".text"

NBLIGNES = 9
NBCOLS = 9
NBBLOCS = 9

/* Début du programme */
Main:
		adr		x20, Sudoku			//x20 contient l'adresse de base du sudoku

       	mov		x0, x20				//Paramètre: adresse du sudoku
        bl     	LireSudoku			//Appelle le sous-programme de lecture

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku		//Appelle le sous-programme d'affichage

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku		//Appelle le sous-programme d'affichage

		mov		x0, #0				//0: tous les tampons
		bl		fflush				//Vidange des tampons

		mov		x0, #0				//0: aucune erreur
		bl     	exit				//Fin du programme

/********************************************************************************
*  Sous-programme qui lit le sudoku en vecteur de taille 81 entiers             *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
LireSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant

		mov		x19, x0				// Conserve l'adresse du sudoku dans x19

		mov		x27, NBLIGNES		// x27 = # lignes
		mov		x28, NBCOLS			// x28 = # colonnes

		mul		x20, x27, x28		// Nombre d'éléments = lignes * colonnes (81)
		mov		x21, 0				// Index dans la matrice

LireSudoku10:
		adr		x0, scfmt1			// Param1: format de lecture
		add		x1, x19, x21		// Param2: adresse de l'element a lire
		bl		scanf				// Lit l'element courant

		add		x21, x21, 4			// Avance l'index d'un element (4 octets)
		subs	x20, x20, 1			// Decremente le nombre d'ekements a lire
		b.gt	LireSudoku10		// Si le nombre est > 0, alors on lit encore

		RESTORE						// Ramene l'environnment de l'appelant
		br		x30					// Retour a l'appelant

/********************************************************************************
*  Sous-programme qui affiche le sudoku colonne par colonne		  			    *
*																				*
*  i = no de ligne, j = no de colonne											*
*  Position de l'element courant: adr.base + [i * (nb.colonnes)+j]*4			*
*																				*
*  x0: addresse du sudoku                                                       *
********************************************************************************/
AfficherSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant

		mov		x19, x0				// Conserve l'adresse du sudoku dans x19
		mov		x27, NBLIGNES		// x27 = # lignes
		mov		x28, NBCOLS			// x28 = # colonnes
		mov		x23, 4				// Constante 4 dans x23
		mov		x21, 0				// Compteur j = 0

		/* S'occupe d'afficher les splitters pour serparer les blocs */
AfficherSudoku05:

		mov		x26, 3
		udiv	x25, x21, x26
		mul		x26, x26, x25
		subs	x25, x21, x26
		cbz		x25, AfficherSudokuSplitter

		/* Boucle externe: controle le no de colonne (x21 = j) */
AfficherSudoku10:
		mov		x20, 0				// Compteur i = 0

		/* S'occupe d'afficher les barres verte pour serparer les blocs */
AfficherSudoku15:
		mov		x26, 3
		udiv	x25, x20, x26
		mul		x26, x26, x25
		subs	x25, x20, x26
		cbz		x25, AfficherSudokuBarreVert

		/* Boucle interne: controle le no de ligne (x20 = i) */
AfficherSudoku20:
		mul		x22, x21, x28		// Debut de la rangee = i * nb.colonnes
		add		x22, x22, x20		// Position de l'element = debut.rangee + j
		mul 	x22, x22, x23		// Index = position.elmt * 4 octets par elmt

		adr		x0, ptfmt4			// Param1: adresse du format
		ldr		w1, [x19,x22]		// Param2: valeur de l'element (base + index)
		bl		printf				// Affichage de l'element courant

		add		x20, x20, 1			// Passe a la ligne suivante
		cmp		x20, x27			// As-t-on depasse la derniere ligne?
		b.lt	AfficherSudoku15	// Sinon, traite la ligne suivante

		/* Fin boucle interne */

		/* Affichage de la derniere barre verticale avec saut de ligne */
		adr		x0, barreVS
		bl 		printf

		add		x21, x21, 1			// Passe a la colonne suivante
		cmp		x21, x28			// As-t-on depasse la derniere colonne?
		b.lt	AfficherSudoku05	// Sinon, traite la colonne suivante

		/* Affichage de la derniere barre verticale avec saut de ligne */
		adr		x0, splitter
		bl 		printf

		b.al 	AfficherSudoku30

		/* Fin boucle externe */

AfficherSudokuBarreVert:
		adr		x0, barreVert
		bl 		printf
		b.al	AfficherSudoku20

AfficherSudokuSplitter:
		adr		x0, splitter
		bl 		printf
		b.al	AfficherSudoku10

AfficherSudoku30:
		RESTORE						//Ramène l'environnement de l'appelant
		br		x30					//Retour à l'appelant

/********************************************************************************
*  Sous-programme qui "dispatch" les etapes de verification du sudoku	        *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
VerifierSudoku:
		SAVE

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierR			//Appelle le sous-programme de vérification

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierC			//Appelle le sous-programme de vérification

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierB			//Appelle le sous-programme de vérification

		RESTORE
		br		x30

/********************************************************************************
* 	Sous-programme qui s'occupe de la verification des rangees					*
*	x0: adresse du Sudoku														*
********************************************************************************/
VerifierR:
		SAVE

		mov		x19, x0				// Conserve l'adresse du tableau dans x19
		mov		x20, NBCOLS			// Nombre de colonnes a verifier
		mov		x24, 10				// Valeur de 10 dans x24

VerifierRr:
		cbz		x20, VerifierRrr	// Si on a fini d'evaluer les rangees, branche a VerifierC

		sub		x23, x24, x20		// Obtenir le numero de ligne courante

		mov		x0, x19				// Param1: l'adresse de l'element courant
		mov		x1, x23				// Param2: le numero de ligne courant (message d'erreur)
		bl		VerifierRangee		// Branche au sous-programme verifiant les rangees

		sub		x20, x20, 1			// Decremente le nombre de rangees a verifier
		add		x19, x19, 36		// Passe a l'adresse de base de la prochaine ligne (adr += 4*9)
		b.al	VerifierRr			// Revient a la boucle pour prochaine evaluation

VerifierRrr:
		RESTORE
		br		x30

/********************************************************************************
* 	Sous-programme qui s'occupe de la verification des colonnes					*
*	x0: adresse du Sudoku														*
********************************************************************************/
VerifierC:
		SAVE

		mov		x19, x0				// Conserve l'adresse du tableau dans x19
		mov		x21, NBCOLS			// Nombre de colonnes a verifier
		mov		x24, 10				// Valeur de 10 dans x24

VerifierCc:
		cbz		x21, VerifierCcc	// Si on a fini d'evaluer les colonnes, branche a VerifierB

		sub		x23, x24, x21		// Obtenir le numero de ligne courante

		mov		x0, x19				// Param1: l'adresse de l'element courant
		mov		x1, x23				// Param2: le numero de ligne courant (message d'erreur)
		bl		VerifierColonne		// Branche au sous-programme verifiant les colonnes

		sub		x21, x21, 1			// Decrement le nombre de colonnes a verifier
		add		x19, x19, 4			// Passe l'adresse de base de la prochaine colonne (adr += 4)
		b.al	VerifierCc			// Revient a la boucle pour prochaine evalutation

VerifierCcc:
		RESTORE
		br		x30

/********************************************************************************
* 	Sous-programme qui s'occupe de la verification des blocs					*
*	x0: adresse du Sudoku														*
********************************************************************************/
VerifierB:
		SAVE

		mov		x19, x0				// Conserve l'adresse du tableau dans x19
		mov		x22, NBBLOCS		// Nombre de blocs a verifier
		mov		x24, 10				// Valeur de 10 dans x24
		mov		x20, 1				// Compteur pour skips

VerifierBb:
		cbz		x22, VerifierBbb	// Si on a fini d'evaluer les blocs, branche a VerifierF

		sub		x23, x24, x22		// Obtenir le numero de ligne courante

		mov		x0, x19				// Param1: l'adresse de l'element courant
		mov		x1, x23				// Param2: le numero du bloc courant (message d'erreur)
		bl		VerifierBloc		// Branche au sous-programme verifiant les blocs

		mov		x0, x20				// Param1: n
		mov		x1, 3				// Param2: d
		bl		Modulo				// Appel de la fonction Modulo
		cmp		x0, 99				// Regarde si on a un reste = 0
		b.ne	VerifierBbNoSkip	// Si reste != 0, alors on doit seulement avancer de 12
		b.eq	VerifierBbSkip		// Si reste == 0, alors on doit avancer de 84

VerifierBbSkip:
		sub		x22, x22, 1			// Decremente le nombre de blocs a verifier
		add		x19, x19, 84		// Passe a l'adresse de base du prochain bloc (adr += 4*21)
		add		x20, x20, 1			// Incremente le compteur de skips
		b.al	VerifierBb			// Revient a la boucle pour prochaine evaluation

VerifierBbNoSkip:
		sub		x22, x22, 1			// Decremente le nombre de blocs a verifier
		add		x19, x19, 12		// Passe a l'adresse de base du prochain bloc (adr += 4*3)
		add		x20, x20, 1			// Incremente le compteur de skips
		b.al	VerifierBb			// Revient a la boucle pour prochaine evaluation

VerifierBbb:
		RESTORE
		br		x30					//Retour à l'appelant

/********************************************************************************
*  Sous-programme qui verifie l'integralite d'une rangee du sudoku	            *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
VerifierRangee:
		SAVE							// Sauvegarde l'environnement de l'appelant

		mov		x19, x0					// Conserve l'adresse de base du sudoku
		mov		x23, x1					// Conserve le # de ligne courante dans x23
		mov		x28, 9					// Nombre d'element dans une rangee a tenir compte
		mov		x25, 0					// Bits pour verification init. a 0
		mov		x26, 1					// Bit pour faire verification avec eor

VerifierRangee10:
		cbz		x28, VerifierRangee20	// Comparaison pour savoir si on a fini la rangee

		ldrb	w20, [x19]				// Load la valeur de l'element courant
		lsl		x27, x26, x20			// Shift a gauche des bits de la valeur recupere
		eor		x25, x27, x25			// OU exclusif, 1 si 0, 0 si 1

		add		x19, x19, 4				// Incremente l'adresse de la prochaine cellule
		sub		x28, x28, 1				// Decremente le nombre d'element restant a evaluer
		b.al	VerifierRangee10		// Retourne dans la boucle

VerifierRangee20:
		cmp		x25, 0x3FE				// Compare avec "11111111"
		b.eq	VerifierRangeeFin		// Si = on branche a VerifierRangeeFin

VRerror:
		adr		x0, textErrror			// Commencement du message d'erreur
		bl 		printf

		adr		x0, lineError			// Continuation du message d'erreur
		bl 		printf

		adr		x0, ptfmt5				// Fin du message d'erreur
		mov		x1, x23					// # de ligne courant
		bl 		printf

VerifierRangeeFin:
		RESTORE
		br		x30						// Retour a l'appelant

/********************************************************************************
*  Sous-programme qui verifie l'integralite d'une colonne du sudoku	            *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
VerifierColonne:
		SAVE							// Sauvegarde l'environnement de l'appelant

		mov		x19, x0					// Conserve l'adresse de base du sudoku
		mov		x23, x1					// Conserve le # de colonne courante dans x23
		mov		x28, 9					// Nombre d'element dans une colonne a tenir compte
		mov		x25, 0					// Bits pour verification init. a 0
		mov		x26, 1					// Bit pour faire verification avec eor

VerifierColonne10:
		cbz		x28, VerifierColonne20	// Comparaison pour savoir si on a fini la rangee

		ldrb	w20, [x19]				// Load la valeur de l'element courant
		lsl		x27, x26, x20			// Shift a gauche des bits de la valeur recupere
		eor		x25, x27, x25			// OU exclusif, 1 si 0, 0 si 1

		add		x19, x19, 36			// Incremente l'adresse de la prochaine cellule
		sub		x28, x28, 1				// Decremente le nombre d'element restant a evaluer
		b.al	VerifierColonne10		// Retourne dans la boucle

VerifierColonne20:
		cmp		x25, 0x3FE				// Compare avec "11111111"
		b.eq	VerifierColonneFin		// Si = on branche a VerifierColonneFin

VCerror:
		adr		x0, textErrror			// Commencement du message d'erreur
		bl 		printf

		adr		x0, colError			// Continuation du message d'erreur
		bl 		printf

		adr		x0, ptfmt5				// Fin du message d'erreur
		mov		x1, x23					// # de colonne courant
		bl 		printf

VerifierColonneFin:
		RESTORE
		br		x30						// Retour a l'appelant

/********************************************************************************
*  Sous-programme qui verifie l'integralite d'un bloc du sudoku	             	*
*  x0: addresse du sudoku                                                       *
********************************************************************************/
VerifierBloc:
		SAVE							// Sauvegarde l'environnement de l'appelant

		mov		x19, x0					// Conserve l'adresse de base du sudoku
		mov		x23, x1					// Conserve le # de bloc courant dans x23
		mov		x28, 9					// Nombre d'element dans un bloc a tenir compte
		mov 	x25, 0					// Bits pour verification init. a 0
		mov		x26, 1					// Bit pour faire verification avec eor

VerifierBloc10:
		cbz		x28, VerifierBloc20		// Si on a fini d'evaluer, on branche a VerifierBloc20

		ldrb	w20, [x19]				// Load la valeur de l'element courant
		lsl		x27, x26, x20			// Shift a gauche des bits de la valeur recupere
		eor		x25, x27, x25			// OU exclusif, 1 si 0, 0 si 1

		cmp		x28, 7					// Compare si on est rendu a la fin de la 1iere ligne
		b.eq	VerifierBlocSkip		// Si oui, on branche a VerifierBlocSkip
		cmp		x28, 4					// Compare si on est rendu a la fin de la 2ieme ligne
		b.eq	VerifierBlocSkip		// Si oui, on branche a VerifierBlocSkip

		b.al	VerifierBlocNoSkip		// Sinon, on branche a VerifierBlocNoSkip

VerifierBlocNoSkip:
		sub		x28, x28, 1				// Decremente le nombre d'element restant a evaluer
		add		x19, x19, 4				// Incremente l'adresse du prochain element
		b.al	VerifierBloc10			// Revient dans la boucle d'evalution

VerifierBlocSkip:
		sub		x28, x28, 1				// Decremente le nombre d'element restant a evaluer
		add		x19, x19, 28			// Incremente l'adresse du prochain element
		b.al	VerifierBloc10			// Revient dans la boucle d'evalution

VerifierBloc20:
		cmp		x25, 0x3FE				// Compare avec "1111111110"
		b.eq	VerifierBlocFin			// Si = on branche a VerifierColonneFin

VBerror:
		adr		x0, textErrror			// Commencement du message d'erreur
		bl 		printf

		adr		x0, blocError			// Continuation du message d'erreur
		bl 		printf

		adr		x0, ptfmt5				// Fin du message d'erreur
		mov		x1, x23					// # de colonne courant
		bl 		printf

VerifierBlocFin:
		RESTORE
		br		x30						// Retour a l'appelant

/********************************************************************************
* Sous-programme qui fait le modulo d'un entier -> n/d							*
* x0: n																			*
* x1: d																			*
* Retourne 1 s'il y a un reste, 0 sion											*
********************************************************************************/
Modulo:
		SAVE

		mov		x19, x0					// Recupere la valeur de "n"
		mov		x20, x1					// Recupere la valeur de "d"
		mov		x21, 99					// x21 = 1
		mov		x22, 45

		udiv	x26, x19, x20			// n MOD d
		mul		x26, x26, x20
		subs	x26, x19, x26

		cmp		x26, 0					// Regarde si reste = 0
		csel	x0, x21, x22, eq		// Si oui x0 = 99, sinon x0 = 45

		RESTORE
		br		x30

/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

scfmt1:     .asciz  "%d"
splitter:   .asciz	"|-------|-------|-------|\n"
barreVert:	.asciz	"| "
barreVS:	.asciz  "|\n"
sautLigne:	.asciz	"\n"
ptfmt4:		.asciz 	"%d "
ptfmt5:		.asciz	"%d.\n"
textErrror:	.asciz	"Le sudoku contient une erreur dans "
lineError:	.asciz	"la ligne #"
colError:	.asciz	"la colonne #"
blocError:	.asciz	"le bloc #"

/* Espace réservé pour recevoir le résultat de scanf. */
.section ".bss"
.align	4

tampon:		.skip 4
Sudoku: 	.skip 81
dimensions:	.skip 8
dataMatrice: .skip NBLIGNES * NBCOLS * 4	// Espace requis pour matrice 81 octets
