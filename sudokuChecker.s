/********************************************************************************
*	Programme qui lit, affiche et vérifie un sudoku.                       	*
*	Auteur: Marc-Olivier Lacoste            				*
********************************************************************************/

.include "/root/SOURCES/ift209/tools/ift209.as"

.global Main
.section ".text"

NBLIGNES = 9
NBCOLS = 9

/* Début du programme */
Main:
		adr		x20, Sudoku			//x20 contient l'adresse de base du sudoku

        	mov		x0, x20				//Paramètre: adresse du sudoku
        	bl      	LireSudoku			//Appelle le sous-programme de lecture

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku			//Appelle le sous-programme d'affichage

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku			//Appelle le sous-programme de vérification

		mov		x0, #0				//0: tous les tampons
		bl		fflush				//Vidange des tampons

		mov		x0, #0				//0: aucune erreur
		bl      	exit				//Fin du programme

/********************************************************************************
*  Sous-programme qui lit le sudoku en vecteur de taille 81 entiers             *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
LireSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant

		mov		x19, x0				// Conserve l'adresse du sudoku dans x19

		mov		x27, NBLIGNES			// x27 = # lignes
		mov		x28, NBCOLS			// x28 = # colonnes

		mul		x20, x27, x28			// Nombre d'éléments = lignes * colonnes (81)
		mov		x21, 0				// Index dans la matrice

LireSudoku10:
		adr		x0, scfmt1			// Param1: format de lecture
		add		x1, x19, x21			// Param2: adresse de l'element a lire
		bl		scanf				// Lit l'element courant

		add		x21, x21, 4			// Avance l'index d'un element (4 octets)
		subs		x20, x20, 1			// Decremente le nombre d'ekements a lire
		b.gt		LireSudoku10			// Si le nombre est > 0, alors on lit encore

		RESTORE						// Ramene l'environnment de l'appelant
		br		x30				// Retour a l'appelant

/********************************************************************************
*  Sous-programme qui affiche le sudoku colonne par colonne		        *
*										*
*  i = no de ligne, j = no de colonne						*
*  Position de l'element courant: adr.base + [i * (nb.colonnes)+j]*4		*
*										*
*  x0: addresse du sudoku                                                       *
********************************************************************************/
AfficherSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant

		mov		x19, x0				// Conserve l'adresse du sudoku dans x19
		mov		x27, NBLIGNES			// x27 = # lignes
		mov		x28, NBCOLS			// x28 = # colonnes
		mov		x23, 4				// Constante 4 dans x23
		mov		x21, 0				// Compteur j = 0

		/* S'occupe d'afficher les splitters pour serparer les blocs */
AfficherSudoku05:

		mov		x26, 3
		udiv		x25, x21, x26
		mul		x26, x26, x25
		subs		x25, x21, x26
		cbz		x25, AfficherSudokuSplitter

		/* Boucle externe: controle le no de colonne (x21 = j) */
AfficherSudoku10:
		mov		x20, 0				// Compteur i = 0

		/* S'occupe d'afficher les barres verte pour serparer les blocs */
AfficherSudoku15:
		mov		x26, 3
		udiv		x25, x20, x26
		mul		x26, x26, x25
		subs		x25, x20, x26
		cbz		x25, AfficherSudokuBarreVert

		/* Boucle interne: controle le no de ligne (x20 = i) */
AfficherSudoku20:
		mul		x22, x20, x28			// Debut de la rangee = i * nb.colonnes
		add		x22, x22, x21			// Position de l'element = debut.rangee + j
		mul 		x22, x22, x23			// Index = position.elmt * 4 octets par elmt

		adr		x0, ptfmt4			// Param1: adresse du format
		ldr		w1, [x19,x22]			// Param2: valeur de l'element (base + index)
		bl		printf				// Affichage de l'element courant

		add		x20, x20, 1			// Passe a la ligne suivante
		cmp		x20, x27			// As-t-on depasse la derniere ligne?
		b.lt		AfficherSudoku15		// Sinon, traite la ligne suivante

		/* Fin boucle interne */

		/* Affichage de la derniere barre verticale avec saut de ligne */
		adr		x0, barreVS
		bl 		printf

		add		x21, x21, 1			// Passe a la colonne suivante
		cmp		x21, x28			// As-t-on depasse la derniere colonne?
		b.lt		AfficherSudoku05		// Sinon, traite la colonne suivante

		/* Affichage de la derniere barre verticale avec saut de ligne */
		adr		x0, splitter
		bl 		printf

		b.al 		AfficherSudoku30

		/* Fin boucle externe */

AfficherSudokuBarreVert:
		adr		x0, barreVert
		bl 		printf
		b.al		AfficherSudoku20

AfficherSudokuSplitter:
		adr		x0, splitter
		bl 		printf
		b.al		AfficherSudoku10

AfficherSudoku30:
		RESTORE						//Ramène l'environnement de l'appelant
		br		x30				//Retour à l'appelant

/********************************************************************************
*  Sous-programme qui verifie le sudoku en vecteur de taille 81 entiers         *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
VerifierSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant


		RESTORE
		br		x30				//Retour à l'appelant

/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

scfmt1:     	.asciz  "%d"
splitter:   	.asciz	"|-------|-------|-------|\n"
barreVert:	.asciz	"| "
barreVS:	.asciz  "|\n"
sautLigne:	.asciz	"\n"
ptfmt4:		.asciz 	"%d "

/* Espace réservé pour recevoir le résultat de scanf. */
.section ".bss"
.align	4

tampon:		.skip 4
Sudoku: 	.skip 81
dimensions:	.skip 8
dataMatrice: 	.skip NBLIGNES * NBCOLS * 4	// Espace requis pour matrice 81 octets
