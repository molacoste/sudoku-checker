/********************************************************************************
*																				*
*	Ensemble de sous-programmes qui simulent le décodage et plusieurs          	*
*	instructions pour une machine à pile.										*
*															                    *
*	Auteur: Marc-Olivier Lacoste (18 127 037)									*
*																				*
********************************************************************************/

.include "/root/SOURCES/ift209/tools/ift209.as"

.global Decode
.global EmuPush
.global EmuWrite
.global EmuPop
.global EmuRead
.global EmuAdd
.global EmuSub
.global EmuMul
.global EmuDiv
.global EmuBz
.global EmuBn
.global EmuJmp
.global EmuJmpl
.global EmuRet

.section ".text"

/*******************************************************************************
	Fonction qui décode une instruction.

	Paramètres
		x0: Adresse de la structure instruction (pour écrire le résultat)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x0->mode: type d'instruction
		x0->operation: champ oper (identifie l'opération spécifique)
		x0->operand: opérande (pour PUSH, POP, JMP, READ, WRITE)
		x0->cc: utilisation ou non des codes conditions
		x0->size: taille en octets de l'instruction décodée
*******************************************************************************/
Decode:
    SAVE					//Sauvegarde l'environnement de l'appelant

	mov		x19,x0
	mov		x20,x1
	ldr		w21,[x1]		//Obtention du compteur ordinal
	ldr		x22,[x1,16]		//Obtention du pointeur sur la memoire de la machine virtuelle
	ldrb	w23,[x22,x21]	//Lecture du premier octet de l'instruction courante
	cmp		x23,0			//Est-ce l'instruction HALT? (0x00)
	b.ne 	decodeError		//sinon, le reste n'est pas encore supporte: Erreur.

	str		xzr,[x19]		//type d'instruction: systeme (0)
	str		xzr,[x19,4]		//numero d'operation: 0 (HALT)

	mov		x0,0			//code d'erreur 0: decodage reussi

	RESTORE					//Ramène l'environnement de l'appelant
	ret

decodeError:
	mov	x0,1				//code d'erreur 1: instruction indécodable.

	RESTORE					//Ramène l'environnement de l'appelant
	ret

/*******************************************************************************
	Fonction qui empile 2 ou 4 octets sur la pile.

	Paramètres
		x0: Adresse de la structure Machine (état actuel du simulateur)
		x1:	Le nombre d'octets à empiler (2 ou 4).
		x2: La valeur à empiler

	Résultats
		x1->SP : modifie le pointeur de pile (avance de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (empile une valeur int16 ou float)
*******************************************************************************/
Empile:
	SAVE					//Sauvegarde l'environnement de l'appelant

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui dépile 2 ou 4 octets de la pile.

	Paramètres
		x0: Adresse de la structure Machine (état actuel du simulateur)
		x1:	Le nombre d'octets à dépiler (2 ou 4).

	Résultats
		x0->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x0->memory[SP]: modifie la pile (dépile une valeur int16 ou float)
		x0: La valeur dépilée
*******************************************************************************/
Depile:
	SAVE					//Sauvegarde l'environnement de l'appelant

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui simule PUSH: empile une valeur immédiate de 16 bits (entier) ou
	32 bits (float) en mode immédiat.

	Overdrive 120%.
	Empile une valeur de 16 bits (entier) ou 32 bits (float) se trouvant en
	mémoire à l'adresse dans le champ adresse16	en mode direct.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (avance de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (empile une valeur int16 ou float)
*******************************************************************************/
EmuPush:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant
/*******************************************************************************
	Fonction qui simule WRITE: affiche une valeur sur la console

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile une valeur int16 ou float)
*******************************************************************************/
EmuWrite:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Overdrive 120%
	Fonction qui simule POP: dépile une valeur et la stocke en mémoire

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile une valeur int16 ou float)
		x1->memory[adresse16]: modifie la mémoire à l'adresse adresse16.
*******************************************************************************/
EmuPop:
	SAVE					//Sauvegarde l'environnement de l'appelant


	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui simule READ: lecture d'une valeur sur la console

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (avance de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (empile une valeur int16 ou float)
*******************************************************************************/
EmuRead:
	SAVE					//Sauvegarde l'environnement de l'appelant


	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui simule ADD: addition de deux entiers sur le dessus de la pile,
	dépôt du résultat sur le dessus de la pile.

	Overdrive 125%: modifie les codes condition (machine->PS)

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile deux valeurs int16 ou float), puis empile le résultat du calcul.
*******************************************************************************/
EmuAdd:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui simule SUB: soustraction de deux entiers sur le dessus de la
	pile, dépôt du résultat sur le dessus de la pile.

	Overdrive 125%: modifie les codes condition (machine->PS)

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile deux valeurs int16 ou float),
						puis empile le résultat du calcul.
		x1->PS : modifie les codes condition (Overdrive 125%)
*******************************************************************************/
EmuSub:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant
/*******************************************************************************
	Fonction qui simule MUL: multiplaction de deux entiers sur le dessus de la
	pile, dépôt du résultat sur le dessus de la pile.

	Overdrive 125%: modifie les codes condition (machine->PS)

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile deux valeurs int16 ou float), puis empile le résultat du calcul.
		x1->PS : modifie les codes condition (Overdrive 125%)
*******************************************************************************/
EmuMul:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Fonction qui simule DIV: division de deux entiers sur le dessus de la
	pile, dépôt du résultat sur le dessus de la pile.

	Overdrive 125%: modifie les codes condition (machine->PS)

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->SP : modifie le pointeur de pile (recule de 2 ou 4 octets)
		x1->memory[SP]: modifie la pile (dépile deux valeurs int16 ou float),
						puis empile le résultat du calcul.
		x1->PS : modifie les codes condition (Overdrive 125%)
*******************************************************************************/
EmuDiv:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Overdrive 125%
	Fonction qui simule BZ: branchement si zéro.
	Additionne le contenu du champ Depl13 au compteur ordinal (machine->PC) si
	le bit Z des codes conditions (machine->PS) est allumé.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->PC : modifie compteur ordinal
*******************************************************************************/
EmuBz:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Overdrive 125%
	Fonction qui simule BN: branchement si négatif.
	Additionne le contenu du champ Depl13 au compteur ordinal (machine->PC) si
	le bit N des codes conditions (machine->PS) est allumé.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->PC : modifie compteur ordinal
*******************************************************************************/
EmuBn:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant


/*******************************************************************************
	Overdrive 125%
	Fonction qui simule JMP: saut inconditionnel.
	Remplace la valeur du compteur ordinal(machine->PC) par celle qui se trouve
	dans le champ immediat16.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->PC : modifie compteur ordinal
*******************************************************************************/
EmuJmp:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Overdrive 130%
	Fonction qui simule JMPL: saut inconditionnel avec lien.
	Empile la valeur actuelle du compteur ordinal (sur 16 bits), puis
	additionne le contenu du champ immediat16 au compteur ordinal.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->PC : modifie compteur ordinal
		x1->SP : modifie le pointeur de pile (avance de 2 octets)
		x1->memory[SP]: modifie la pile (empile une adresse de 16 bits)
*******************************************************************************/
EmuJmpl:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant

/*******************************************************************************
	Overdrive 130%
	Fonction qui simule RET: retour de sous-programme
	Dépile une adresse de sur la pile (sur 16 bits), la copie dans le compteur
	ordinal.

	Paramètres
		x0: Adresse de la structure instruction (instruction décodée)
		x1: Adresse de la structure Machine (état actuel du simulateur)

	Résultats
		x1->PC : modifie compteur ordinal
		x1->SP : modifie le pointeur de pile (recule de 2 octets)
		x1->memory[SP]: modifie la pile (dépile une adresse de 16 bits)
*******************************************************************************/
EmuRet:
	SAVE					//Sauvegarde l'environnement de l'appelant

	mov	x0,1				//code d'erreur 1: instruction non implantée.

	RESTORE					//Ramène l'environnement de l'appelant
	ret						//Retour à l'appelant
