/* This program is just a copy of simple_4.dsl.  You should write an somewhat
   interesting program and place it in this file. */

main () { 
 print("Generating Multiplication table -> \n\n");
 Integer i; 
 Integer j;
 for(i = 1 to 9) {
  for(j = 1 to 9) {
    print(i);
    print(" * "); 
    print(j); 
    print(" = "); 
    print(i * j);
    print("\n");
  }
 }
}



