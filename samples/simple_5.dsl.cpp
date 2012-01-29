#include "Runtime.h"

int main() {
  Integer x; 
  x = 0; 
  Integer y; 
  for(int y = 1; y <= 10; y += 1) {
    print (y); 
    print ((String)"\n"); 
    x = (x + y); 
  }
  print (x); 
  print ((String)"\n"); 

  return 0;
}

