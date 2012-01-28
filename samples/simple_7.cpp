#include "Runtime.h"



int main( ) { 
    Matrix<Integer> m (10 , 10);
    for (Integer i = 0;i < 10; i++ )
        for (Integer j = 0;j < 10; j++ )
            m[Index2D(i,j)] = (i  * j);
    Integer i;
    Integer j;
    for (Integer i = 0; i <= 9; i += 1) { 
        for (Integer j = 0; j <= 9; j += 1) { 
            print(m[Index2D(i,j)]);
            print((String)"  ");
        }
        print((String)"\n");
    }
    for (Integer i = 0; i <= 9; i += 1) { 
        for (Integer j = 0; j <= 9; j += 1) { 
            m[Index2D(i,j)] = (m[Index2D(i,j)]  + 100);
        }
    }
    for (Integer i = 0; i <= 9; i += 1) { 
        for (Integer j = 0; j <= 9; j += 1) { 
            print(m[Index2D(i,j)]);
            print((String)"  ");
        }
        print((String)"\n");
    }
} 

