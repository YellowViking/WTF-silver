#include "Runtime.h"

int main() {
 Matrix<Float> m(10,10);
for(int i = 0; i < 10; i++) {
 for(int j = 0; j < 10; j++) {
  m[Index2D(i,j)] = (i * j);
 }
}
Integer i; 
Integer j; 
for(int i = 0;i <= 9;i += 1){
for(int j = 0;j <= 9;j += 1){
print (m[Index2D(i,j)]); 
print ((String)"  "); 
}
print ((String)"\n"); 
}
for(int i = 0;i <= 9;i += 1){
for(int j = 0;j <= 9;j += 1){
m[Index2D(i, j)] = (m[Index2D(i,j)] + 100);
}
}
for(int i = 0;i <= 9;i += 1){
for(int j = 0;j <= 9;j += 1){
print (m[Index2D(i,j)]); 
print ((String)"  "); 
}
print ((String)"\n"); 
}

return 0;
}

