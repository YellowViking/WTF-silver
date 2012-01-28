#include "Runtime.h"



int main( ) { 
    Matrix<Integer> data = readMatrix((String)"../samples/myData.dat");
    Integer rows;
    rows = numRows(data);
    Integer cols;
    cols = numCols(data);
    Integer season_length;
    season_length = 7;
    Integer years;
    years = ceil(((cols  * 1.0)  / season_length));
    Matrix<Float> avgScore (rows , 1);
    for (Integer row = 0;row < rows; row++ )
        for (Integer irrelevant = 0;irrelevant < 1; irrelevant++ )
            avgScore[Index2D(row,irrelevant)] = ({
                Matrix<Float> pt (years , season_length);
                for (Integer i = 0;i < years; i++ )
                    for (Integer j = 0;j < season_length; j++ )
                        pt[Index2D(i,j)] = ({
                            Integer k;
                            k = ((i  * season_length)  + j);
                            (k  >= cols) ? (0.0  - 25) : data[Index2D(row,k)];
                        });
                Matrix<Float> comparisonMatrix (years , years);
                for (Integer i = 0;i < years; i++ )
                    for (Integer j = 0;j < years; j++ )
                        comparisonMatrix[Index2D(i,j)] = (j  <= i) ? 0.0 : ({
                            Float diff;
                            diff = 0;
                            Integer k;
                            for (Integer k = 0; k <= (season_length  - 1); k += 1) { 
                                diff = ((diff  + pt[Index2D(i,k)])  - pt[Index2D(j,k)]);
                            }
                            (diff  / season_length);
                        });
                Matrix<Float> modelAvgScore (years , 1);
                for (Integer yr = 0;yr < years; yr++ )
                    for (Integer dontcare = 0;dontcare < 1; dontcare++ )
                        modelAvgScore[Index2D(yr,dontcare)] = ({
                            Integer x;
                            Integer y;
                            Float score1;
                            score1 = 0.0;
                            for (Integer x = 0; x <= yr; x += 1) { 
                                for (Integer y = (yr  + 1); y <= (years  - 1); y += 1) { 
                                    score1 = (score1  + comparisonMatrix[Index2D(x,y)]);
                                }
                            }
                            score1 = ((score1  * 2)  / (yr  * (years  - yr)));
                            Float score2;
                            score2 = 0.0;
                            for (Integer x = 0; x <= yr; x += 1) { 
                                for (Integer y = 0; y <= yr; y += 1) { 
                                    score2 = (score2  + comparisonMatrix[Index2D(x,y)]);
                                }
                            }
                            score2 = (score2  / (((yr  - 1)  * yr)  / 2));
                            Float score3;
                            score3 = 0.0;
                            for (Integer x = (yr  + 1); x <= (years  - 1); x += 1) { 
                                for (Integer y = (yr  + 1); y <= (years  - 1); y += 1) { 
                                    score3 = (score3  + comparisonMatrix[Index2D(x,y)]);
                                }
                            }
                            score3 = (score3  / (((years  - yr)  * ((years  - yr)  - 1))  / 2));
                            ((score1  - score2)  - score3);
                        });
                Float maximum;
                maximum = (0.0  - 25);
                Integer k;
                k = 0;
                for (Integer k = 0; k <= (years  - 1); k += 1) { 
                    if ((modelAvgScore[Index2D(k,0)]  > maximum)) { 
                        maximum = modelAvgScore[Index2D(k,0)];
                    }
                }
                maximum;
            });
    Integer j;
    for (Integer j = 0; j <= (rows  - 1); j += 1) { 
        print(avgScore[Index2D(j,0)]);
        print((String)"\n");
    }
} 

