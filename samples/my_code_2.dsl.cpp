#include "Runtime.h"

int main() {
  print ((String)"Generating Multiplication table -> \n\n"); 
  Integer i; 
  Integer j; 
  for(int i = 1; i <= 9; i += 1) {
    for(int j = 1; j <= 9; j += 1) {
      print (i); 
      print ((String)" * "); 
      print (j); 
      print ((String)" = "); 
      print ((i * j)); 
      print ((String)"\n"); 
    }
  }

  return 0;
}

