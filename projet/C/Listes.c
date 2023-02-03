#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node {
    char *data;
    struct node *next;
};

void insert(struct node **head, char *value) {
    struct node *new_node = (struct node *)malloc(sizeof(struct node));
    new_node->data = value;
    new_node->next = *head;
    *head = new_node;
}

void sort(struct node *head) {
    struct node *ptr1, *ptr2;
    char *temp;

    for (ptr1 = head; ptr1 != NULL; ptr1 = ptr1->next) {
        for (ptr2 = ptr1->next; ptr2 != NULL; ptr2 = ptr2->next) {
            if (strcmp(ptr1->data, ptr2->data) > 0) {
                temp = ptr1->data;
                ptr1->data = ptr2->data;
                ptr2->data = temp;
            }
        }
    }
}

void printList(struct node *head) {
    while (head != NULL) {
        printf("%s\n", head->data);
        head = head->next;
    }
}

int main() {
    char line[1024];
    char *token;
    const char *delimiter = ",";
    struct node *head = NULL;

    FILE *file = fopen("meteo.csv", "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    while (fgets(line, 1024, file)) {
        token = strtok(line, delimiter);
        insert(&head, strdup(token));
    }

    fclose(file);

    sort(head);
    printList(head);

    return 0;
}