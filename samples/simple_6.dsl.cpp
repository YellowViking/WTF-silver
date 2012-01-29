#include "Runtime.h"

int main() {
  Integer w; 
  w = 4; 
  Integer h; 
  h = 5; 
  Integer d; 
  d = 6; 
  Integer volume; 
  volume = ({
    Integer area; 
    area = (w * h); 
    (area * d);
  }); 
  print (volume); 
  print ((String)"\n"); 

  return 0;
}

