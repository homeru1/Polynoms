#include<stdio.h>
#include <string.h>

typedef struct polynom{
char Name;
int Coeficients;
char Type;
int MaxPower;
struct polynom* Next;
}polynom;

struct polynom *head;

void init(struct polynom* poly) 
{
  poly->Name = (struct polynom*)calloc(1,sizeof(polynom)*strlen(poly->Name));
  poly->Coeficients = (struct polynom*)calloc(1,sizeof(polynom)*1000);
  
  
  poly->Next = head;
  return;
}
struct polynom *add()
{
   struct polynom *poly;
   poly = (struct polynom*)calloc(1,sizeof(polynom));
   init(poly);
   return poly;
}

void printpoly() {
   struct polynom *elem = head;
   while(elem != NULL) {
      printf("(%s %d  %s %d)",elem->Name,elem->Coeficients,elem->Type,elem->MaxPower);
      elem = elem->Next;
   }
}

int main() {
    head = add();
    init(head);
    printpoly();
}