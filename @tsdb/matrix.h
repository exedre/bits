#ifndef _MATRIX_H
#define _MATRIX_H

#include <boost/operators.hpp>
using namespace boost;

#include <math.h>

#include <vector>
using namespace std;

namespace bits {

  /** @brief if X value is nan substitute it with Y 
   */
  template<class _T>
  struct subst_nan : binary_function<_T, _T, _T>
  { _T operator()(const _T& _X, const _T& _Y) const;  };

  class size_mismatch: public std::exception {}; ///< Exception: 

  /** @brief generate uniform double distribution 
	 
   */
  struct uniform { 
  uniform(double d) : D(d) {} 
	double D; 
	double operator()(double& d) { d+=D; return D; }
  };

  /** @brief generate linear double distribution
   */
  struct linear { 
  linear(double d) : D(d), acc(0.0) {} 
  linear(double i, double d) : D(d), acc(i) {} 
	double D; 
	double acc;
	double operator()() { acc+=D; return acc; }
  };


  /** @brief column class
   */
  class column : public vector<double>, 
	arithmetic<column, 
	arithmetic<column,double
	> >
  {
  public:
	column() {};	
	column(const int& sz);	
	column(const int& sz, const double& d);

	// extract values
	column& extract(column& c, const int b, const int e) const ;

	// COLUMN <op> COLUMN
	column& operator+=(const column&);
	column& operator-=(const column&);
	column& operator*=(const column&);
	column& operator/=(const column&);

	// COLUMN <op> DOUBLE
	column& operator=(const double&);

	column& operator+=(const double&);
	column& operator-=(const double&);
	column& operator*=(const double&);
	column& operator/=(const double&);

  };

  ostream& operator << (ostream& o, const column& m) ;

  /** @brief substitute nans in a column
   */
  template<>   
  struct subst_nan<column> : binary_function<column, column, column>
  {
	const int b; const int e;
	subst_nan<column>() : b(0),e(0) {}
	subst_nan<column>(const int _b, const int _e) : b(_b),e(_e) {cerr << "s\n";}
	column operator()(const column& _X, const column& _Y) const ;
  };



  /** @brief matrix class
   */
  class matrix 
	: public vector<column>,
	arithmetic<matrix,
	arithmetic<matrix,column,
	arithmetic<matrix,double
	> >	>
  {
  public:
	matrix& append_missing (const long nx);
	matrix& prepend_missing(const long nx);
	matrix& append(const matrix& m) ;
	matrix& prepend(const matrix& m) ;

	long nobs() const ;

	matrix& extract(matrix& m, const int b, const int e) const ;
	matrix& join   (matrix& m, const int b, const int e) const ;
	matrix& merge  (const matrix& m, const int b, const int e) ;
	matrix& operator<<(const matrix& m) ;
	matrix& operator>>(matrix& m) ;

	// MATRIX <op> MATRIX
	matrix& operator+=(const matrix&);
	matrix& operator-=(const matrix&);
	matrix& operator*=(const matrix&);
	matrix& operator/=(const matrix&);

	// MATRIX <op> COLUMN
	matrix& operator+=(const column&);
	matrix& operator-=(const column&);
	matrix& operator*=(const column&);
	matrix& operator/=(const column&);

	// MATRIX <op> DOUBLE
	matrix& operator+=(const double&);
	matrix& operator-=(const double&);
	matrix& operator*=(const double&);
	matrix& operator/=(const double&);

	matrix& operator=(const double&);

	matrix operator()(const unsigned int which) const;
	matrix operator()(const vector<unsigned int> which);
  };

  ostream& operator << (ostream& o, const matrix& m) ;

}

#include "matrix.cch"

#endif // _MATRIX_H
