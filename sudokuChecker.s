/********************************************************************************
*																				*
*	Programme qui lit, affiche et vérifie un sudoku.                          	*
*																				*
*	Auteur: Marc-Olivier Lacoste            									*
*																				*
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
        bl      LireSudoku			//Appelle le sous-programme de lecture

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku		//Appelle le sous-programme d'affichage

		mov		x0, x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku		//Appelle le sous-programme de vérification

		mov		x0, #0				//0: tous les tampons
		bl		fflush				//Vidange des tampons

		mov		x0, #0				//0: aucune erreur
		bl      exit				//Fin du programme

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
*  Sous-programme qui affiche le sudoku en vecteur de taille 81 entiers         *
*  x0: addresse du sudoku                                                       *
********************************************************************************/
AfficherSudoku:
		SAVE						// Sauvegarde l'environnement de l'appelant

		RESTORE					//Ramène l'environnement de l'appelant
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

scfmt1:     .asciz  "%d"
ptfmt1:     .asciz	"|---------|---------|---------|\n"
barreVert:	.asciz	"|"
sautLigne:	.asciz	"\n"
fmtCellule:	.asciz	" %1u "
fmtErreur:	.asciz	"Le sudoku contient une erreur dans %s %d\n"
fmtErreur1:	.asciz	"Le sudoku contient une erreur dans "
fmtErreur2:	.asciz	"%s "
fmtErreur3:	.asciz	"%d\n"
fmtLigne:	.asciz	"la ligne"
fmtColonne:	.asciz	"la colonne"
fmtBloc:	.asciz	"le bloc"
espace:		.asciz	" "

/* Espace réservé pour recevoir le résultat de scanf. */
.section ".bss"
.align	4

tampon:			.skip 4
Sudoku: 		.skip 81
dimensions:		.skip 8
dataMatrice: 	.skip NBLIGNES * NBCOLS * 4	// Espace requis pour matrice 81 octets
