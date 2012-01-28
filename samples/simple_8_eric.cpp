#include <iostream>
#include "Matrix.h"
#include <math.h>
using namespace std; 
int main ( ) { 
Matrix m ( Matrix::readMatrix ("../samples/simple_8.data") ) ; 

cout << m ;


}

