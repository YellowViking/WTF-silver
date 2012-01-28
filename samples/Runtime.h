/* 
 * File:   Runtime.h
 * Author: cby1990
 *
 * Created on December 3, 2011, 6:57 PM
 */

#ifndef RUNTIME_H
#define	RUNTIME_H

#include <string>
#include <iostream>
#include <ostream>
#include <fstream>
#include <math.h>
#include <string.h>
// mapping primitive types
typedef std::string String;
typedef int Integer;
typedef float Float;
typedef bool Boolean;

// Matrix 

struct Index2D {
    int i, j;

    Index2D(int _i, int _j) : i(_i), j(_j) {

    }
};

class RuntimeError : public std::exception {
    std::string msg;
public:

    ~RuntimeError() throw () {

    }

    RuntimeError(std::string desc) {
        msg = desc;
    }

    virtual const char* what() const throw () {
        return this->msg.c_str();
    }
};

template <class T>
class Matrix {
public:
    Matrix() : rows(0), cols(0) {
        data = NULL;
    }

    Matrix(int i, int j) : rows(i), cols(j) {
        data = new T[dataSize()];
    }

    size_t dataSize() const {
        return rows * cols;
    }

    Matrix(const Matrix& m) {
        data = new T[m.dataSize()];
        rows = m.rows;
        cols = m.cols;
        memcpy(data, m.data, sizeof (T) * m.dataSize());
    }
//    Matrix(Matrix m) {
//    }

//    Matrix operator=(Matrix m) {
//        data = new T[m.dataSize()];
//        memcpy(data, m.data, sizeof (T) * m.dataSize());
//        return *this;
//    }

    int numRows() {
        return rows;
    }

    int numCols() {
        return cols;
    }

    T & operator[] (int index) {
        return data[index];
    }

    T & operator[] (Index2D index) {
        if (index.j >= cols) {
            throw new RuntimeError("Index Access Out of Bound");
        }
        return data[index.i * cols + index.j];
    }

    friend std::ostream& operator<<(std::ostream &os, Matrix<T> &m) {
        os << m.numRows() << " " << m.numCols() << std::endl;
        for (int i = 0; i < m.numRows(); i++) {
            for (int j = 0; j < m.numCols(); j++) {
                os << m[Index2D(i, j)] << "  ";
            }
            os << std::endl;
        }
        return os;
    }
    ~Matrix() {
        rows = 0; cols = 0;
        if(data != NULL) delete[] data;
        data = NULL;
    }
private:


    int rows;
    int cols;

    T *data;
};

// Function Calls

Matrix<Float> readMatrix(std::string filename) {
    std::ifstream f(filename.c_str());
    if(f.fail()) std::cout << "error reading file" << filename << std::endl;
    int i;
    int j;
    f >> i;
    f >> j;
    Matrix<Float> m(i, j);
    for (int index = 0; index < m.dataSize(); index++) {
        Integer aNum;
        f >> aNum;
        (m)[index] = aNum;
    }
    return m;
}
template <class T>
Integer numRows(T m) {
    return m.numRows();
}
template <class T>
Integer numCols(T m) {
    return m.numCols();
}
// ceil -> math.h :: ceil

template <class T>
void print(T t) {
    std::cout << t;
}

String operator*(String s, Integer num) {
    String result = "";
    for (int i = 0; i < num; i++) {
        result += s;
    }
    return result;
}
#endif	/* RUNTIME_H */

