#ifdef WIN32
#include <windows.h>
#include <winsock.h>
#pragma warning (disable: 4514 4786)
#pragma warning( push, 3 )
#endif

#ifndef WIN32
#include <unistd.h>
#endif

//#define DEBUG 1

/*
#ifndef DEBUG
#define DEBUG	0
#else
#define DEBUG	1
#endif
*/


#include <mex.h>		//  Definitions for Matlab AP
#ifdef WIN32
#include "mclcppclass.h"
#endif

#include <mysql++.h>

#include <iostream>
#include <iomanip>
#include <string>
#include <cmath>
#include <vector>
#include <sstream>
#include <exception>
#include <matrix.h>


using namespace std;
using namespace bits;

// Costanti utili per reperire informazioni dal TSDB (sono i nomi dei campi)
#define TSDB_PASSWORD_FIELD_NAME	"passwd"
#define TSDB_USERNAME_FIELD_NAME	"username"
#define TSDB_DBNAME_FIELD_NAME		"name"
#define TSDB_HOST_FIELD_NAME		"host"




//costanti di definizione per i campi di tsmat
#define MATDATA			"matdata"
#define START_YEAR		"start_year"
#define START_PERIOD	        "start_period"
#define FREQ			"freq"
#define LAST_YEAR		"last_year"
#define LAST_PERIOD		"last_period"
#define META			"meta"
#define META_COLS		"meta_cols"

#define NUMBER_OF_FIELDS	8
/**
 * Struttura dati per la funzione GetInfo
 */
typedef struct _TsInfo
{
  long id;
  int freq;
} TsInfo;

/**
 * Struttura dati per la funzione GetRelease e GetLastRelease
 * 
 * Forse e' il caso di fare un unica struct/class alla ValueObject per trasportare queste info
 */
typedef struct _ReleaseInfo
{
  long vid;
  long release;
  int start_y;
  int start_p;
  int version;
  int resolution;
} ReleaseInfo;

/**
 * Questa e' la cosa peggiore che potessi fare: Dato che le coppie di valori per metadati devono essere memorizzati 
 * in un unica struttura ho pensato all'inizio ad una union, poi non sapendo di costruttori e distruttori e pensando 
 * strettamente ad oggetti ho deviato su una classetta.
 * 
 * IMHO si poteva fare con qualcosa di piu' leggero e leggibile
 */ 

class Pair
{
  char *stringValue;
  char *name;
  double doubleValue;
  bool charr;
public:
    Pair (char *name, char *stringValue)
  {
    this->name = name;
    this->stringValue = stringValue;
    this->charr = true;
  }

  Pair (char *name, double doubleValue)
  {
    this->name = name;
    this->doubleValue = doubleValue;
    this->charr = false;
    this->stringValue = NULL;
  }
  ~Pair ()
  {
    free(name);
    if (charr)
      {
	free(stringValue);
      }
  }

  bool isChar ()
  {
    return charr;
  }

  char *getName ()
  {
    return name;
  }

  char *getStringValue ()
  {
    return stringValue;
  }

  double getDoubleValue ()
  {
    return doubleValue;
  }
};


/**
 * Classe d'appoggio per contenere le informazioni di connessione al DB. 
 * Fa da DTO verso le classi di MySQL++
 */

class ConnectionParams
{
public:
  char *username;
  char *password;
  char *host;
  char *dbname;

  ConnectionParams (char *username,
		    char *password, 
                    char *host, 
                    char *dbname) 
  {
    this->username = username;
    this->password = password;
    this->host = host;
    this->dbname = dbname;
  }

  ~ConnectionParams () {
    delete username;
    delete password;
    delete host;
    delete dbname;
  }

};

/**
 * Classe per contenere le informazione di richiesta
 */

class RequestInfo
{
  char *name;
  long releaseDate;

public:
    RequestInfo (char *name)
  {
    this->name = name;
    releaseDate = 0;
  }

  RequestInfo (char *name, long releaseDate)
  {
    this->name = name;
    this->releaseDate = releaseDate;
  }

  ~RequestInfo ()
  {
    delete name;
  }

  bool hasReleaseDate ()
  {
    return (releaseDate == 0);
  }

  char *getName ()
  {
    return name;
  }

  long getDate ()
  {
    return releaseDate;
  }


  char *setDate (long date)
  {
    releaseDate = date;
  }
};

// propotipi di funzione
void showUsage ();
void disconnect ();

/**
 * Da un input che e' un puntatore alle strutture mxArray in ingresso, 
 * ritorna un array di RequestInfo per ogni nome di seri in input
 *
 */

vector < RequestInfo * >*checkInputArguments (const mxArray **, int);

/**
 * dal puntatore al tsdb proveniente da matlab estrae i parametri, incapsulati alla C++, 
 * per connettersi al DB via MySQL++
 * 
 * Questo perche' matlab usa una connessione Java verso i DB che non e' 
 * condivisibile con codice C++
 */

ConnectionParams *getConnectionParameters (const mxArray *);

/**
 * metodoi equivalenti di tsload.m
 */
ReleaseInfo *GetRelease (long, long);
ReleaseInfo *GetLastRelease (long);



/**
 * Dato un VID ed un ID di serie, ritorna i metadati, equivalente allo stesso metodo in tsload.m
 * 
 * TODO: da completare.
 */ 
mxArray *GetMetaData (int m, int imax, mxArray* meta_cols,long vid, long id);
TsInfo  *GetInfo (const string label);
column   GetData (long vid, long id);

/**
 * Generica struttura per rappresentare un periodo
 */

typedef struct period_ {
  int year;
  int period;
} Period;

/**
 * metodo equivalente di tsload.m: data frequenza, start_year, start_period e numero di osservazioni
 * trova l'ending period della serie storica
 */

Period start2end(int freq, int sy, int sp, int dist);

/**
 * Metodo prezioso come l'oro per convertire un vector di double in una struttura dati equivalente 
 * per Matlab.
 */
mxArray*  convertMatrix2mxArray(matrix vdata) ;

extern mysqlpp::Connection conn ;
int fillBack(int, int, int, int, int,int);

