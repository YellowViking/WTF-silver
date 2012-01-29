#include "Runtime.h"

int main() {
  Matrix<Float> m = readMatrix ((String)"../samples/simple_8.data"); 
  print (m); 

  return 0;
}

