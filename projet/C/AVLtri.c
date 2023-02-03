#include <stdio.h>
#include <stdlib.h>

struct Arbre {
    int val;
    int hauteur;
    struct Arbre *gauche;
    struct Arbre *droite;
};

// Fonction pour obtenir la hauteur d'un noeud
int hauteur(struct Arbre *arb) {
    if (arb == NULL)
        return 0;
    return arb->hauteur;
}

// Fonction pour obtenir le maximum entre deux nombres
int max(int a, int b) {
    return (a > b) ? a : b;
}

// Fonction pour créer un nouveau noeud
struct Arbre* newarb(int val) {
    struct Arbre* arb = (struct Arbre*) malloc(sizeof(struct Arbre));
    arb->val = val;
    arb->gauche = NULL;
    arb->droite = NULL;
    arb->hauteur = 1;
    return(arb);
}

// Fonction pour effectuer une rotation droite sur un noeud
struct Arbre *droiteRotate(struct Arbre *y) {
    struct Arbre *x = y->gauche;
    struct Arbre *T2 = x->droite;

    // Effectuer la rotation
    x->droite = y;
    y->gauche = T2;

    // Mettre à jour les hauteurs
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;

    // Retourner le nouveau noeud racine
    return x;
}

// Fonction pour effectuer une rotation gauche sur un noeud
struct Arbre *gaucheRotate(struct Arbre *x) {
    struct Arbre *y = x->droite;
    struct Arbre *T2 = y->gauche;

    // Effectuer la rotation
    y->gauche = x;
    x->droite = T2;

    // Mettre à jour les hauteurs
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;

    // Retourner le nouveau noeud racine
    return y;
}

// Fonction pour obtenir le facteur d'équilibre d'un noeud
int getBalance(struct Arbre *arb) {
    if (arb == NULL)
        return 0;
    return hauteur(arb->gauche) - hauteur(arb->droite);
}

// Fonction pour insérer un nouvel élément dans l'arbre AVL
struct Arbre* insert(struct Arbre* arb, int val) {
    /* 1. Effectuer une insertion standard dans un arbre binaire de recherche */
    if (arb == NULL)
        return(newarb(val));

    if (val < arb->val)
        arb->gauche = insert(arb->gauche, val);
        else if (val > arb->val)
        arb->droite = insert(arb->droite, val);
    else // val est déjà présent dans l'arbre, pas d'insertion nécessaire
        return arb;

    /* 2. Mettre à jour la hauteur de ce noeud */
    arb->hauteur = 1 + max(hauteur(arb->gauche), hauteur(arb->droite));

    /* 3. Obtenir le facteur d'équilibre de ce noeud pour vérifier s'il est déséquilibré */
    int balance = getBalance(arb);

    // Si le noeud est déséquilibré, il y a 4 cas différents
    // Cas gauche gauche
    if (balance > 1 && val < arb->gauche->val)
        return droiteRotate(arb);

    // Cas droite droite
    if (balance < -1 && val > arb->droite->val)
        return gaucheRotate(arb);

    // Cas gauche droite
    if (balance > 1 && val > arb->gauche->val) {
        arb->gauche = gaucheRotate(arb->gauche);
        return droiteRotate(arb);
    }

    // Cas droite gauche
    if (balance < -1 && val < arb->droite->val) {
        arb->droite = droiteRotate(arb->droite);
        return gaucheRotate(arb);
    }

    /* Retourner le noeud (non modifié) */
    return arb;
}

// Fonction pour afficher l'arbre en parcours infixe
void inOrder(struct Arbre *racine) {
  if (racine == NULL) return;

  inOrder(racine->gauche);
  printf("%d ", racine->val);
  inOrder(racine->droite);
}

//Fonction pour afficher l'abre en parcours préfixe
void preOrder(struct Arbre *racine) {
    if(racine != NULL) {
        printf("%d ", racine->val);
        preOrder(racine->gauche);
        preOrder(racine->droite);
    }
}

//Fonction pour afficher l'abre en parcours suffixe
void postOrder(struct Arbre *racine) {
    if(racine != NULL) {
        postOrder(racine->gauche);
        postOrder(racine->droite);
        printf("%d ", racine->val);
    }
}



int main() {
    struct Arbre *racine = NULL;

    /* Insérer des éléments */
    racine = insert(meteo.csv, 10);
   
    
    printf("Arbre AVL après les insertions : \n\n");
    printf("Parcours infixe : ");
    inOrder(meteo.csv);
    

    return 0;
}

