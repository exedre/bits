#include "tsload.hpp"

#include <tsmat.h>

/**
 * Riferimento globale alla classe Connection (rappresenta la connessione al DB)
 */
mysqlpp::Connection conn (false);

void 
showUsage ()
{
  mexPrintf ("Usage:\n");
  mexPrintf
    ("%s(tsdbInstance, [tseriesName|tseriesCellArray], [releases])\n",
     mexFunctionName ());
  mexPrintf ("%s(tsdbInstance, [tseriesName|tseriesCellArray])\n",
	     mexFunctionName ());
  mexPrintf ("\twhere: \n");
  mexPrintf
    ("\t\ttsdbInstance                  : is an istance of the tsdb matlab object\n");
  mexPrintf
    ("\t\t                                (used to connecto to the db)\n");
  mexPrintf
    ("\t\t[tseriesName|tseriesCellArray]: is a char (eg: 'TETSZ0AC') with the\n");
  mexPrintf
    ("\t\t                                name of the series to be loaded,\n");
  mexPrintf
    ("\t\t                                or a cell array of names\n");
  mexPrintf
    ("\t\trelease                       : a single date or a cell array of dates (having the\n");
  mexPrintf
    ("\t\t                                same dimensions of tseriesCellArray)\n");
}

/**
 * Questa routine controlla gli argomenti d'input della mexFunction
 * Si hanno due casi: 2 o 3 argomenti.
 * 2 Argomenti: il primo e' un tsdb, il secondo e' un nome di una time series o un cellarray di nomi di dimensione finita N
 * 3 Argomenti: come sopra, ma con l'aggiunta di una data che contraddistingue la release: la data puo' essere una (valida 
 *              per la singola serie o la lista, o una cella di dimensione N (rigorosamente), le cui singole release sono 
 *              accoppiate 1-by-1 con le serie storiche.
 *			
 */

// Evvai con lo spaghetti code...

vector < RequestInfo * >*
checkInputArguments (const mxArray * prhs[],
		     int nrhs)
{
  vector< RequestInfo * >* infos = new vector < RequestInfo * >();

  if (nrhs < 2) {
    showUsage ();
    mexErrMsgTxt ("ntsloadmeta need at least 2 arguments");
    return NULL;
  }

  
  /**
   * First must be a tsdb?
   */
  if (!mxIsClass (prhs[0], "tsdb")) 
    {
      showUsage ();
      mexErrMsgTxt ("first argument has to be a tsdb");
      return NULL;
    }

  /** 
   * Second must be a string or a cell-array
   */
  if (!mxIsChar (prhs[1]) && !mxIsCell (prhs[1]) && ! mxIsClass(prhs[1],"tsmat"))
    {
      showUsage ();
      mexErrMsgTxt ("second argument has to be a char or a cell array or a tsmat");
      return NULL;
    }

  /*** 2nd Parameter Management (series definition) ***/

  if (DEBUG) {
      mexPrintf("\nDEBUG----\nnrhs=%d\n2nd->string %d\n2nd->len %d\n",
		nrhs,mxIsChar(prhs[1]), (mxIsCell(prhs[1]) ? mxGetN(prhs[1]) : 0)
		);

    }


  /* Se la specifica della serie è una semplice stringa */
  if ( mxIsChar (prhs[1])) {
    /* prende la stringa e la infila in una requestinfo */
    int length = mxGetN (prhs[1]);
    char *nome = (char *) malloc (length * sizeof (char) + 1);
    mxGetString (prhs[1], nome, length + 1);
    RequestInfo *tmp = new RequestInfo (nome);
    infos->push_back (tmp);

  } else if ( mxIsCell (prhs[1])) { /* Se la specifica delle serie è un cell-array */
    unsigned int size = (unsigned int) mxGetN(prhs[1]);
    
    if (0 == size) {
      showUsage ();
      mexErrMsgTxt ("second argument must have at least one  element");
      return NULL;
    }

    for (unsigned int i = 0; i < size; i++) 
      {
	const mxArray *cell = mxGetCell (prhs[1], i);
	int length = mxGetN (cell);
	char *nome = (char *) malloc (length * sizeof (char) + 1);
	mxGetString (cell, nome, length + 1);
	RequestInfo *tmp = new RequestInfo (nome);
	infos->push_back (tmp);
      }
  } else {
    showUsage ();
    mexErrMsgTxt ("class tsmat not managed yet");
    return NULL; 
  }

  return infos;

}


/**
 * Questa funzione costruisce un oggetto ConnectionParams (specifica dei parametri di connessione a MySQL)
 * 
 * Rif: (dall'help di Matlab)
 *   mwSize
 *   mxArray
 *   mxGetField
 *   mxGetString
 *   mexErrMsgTxt
 */
ConnectionParams*
getConnectionParameters (const mxArray * tsdb)
{
  mxArray *tmp;
  char *username;
  char *password;
  char *host;
  char *dbname;
  mwSize strlen;
  tmp = mxGetField (tsdb, 0, TSDB_USERNAME_FIELD_NAME);
  if (NULL == tmp) {
    mexErrMsgTxt ("Can't find field username in tsdb\n");
  }
  strlen = mxGetN (tmp);
  username = (char *) malloc (strlen * sizeof (char) + 1);
  if (mxGetString (tmp, username, strlen + 1)) {
    mexErrMsgTxt ("Error getting the username from the tsdb\n");
  }
  tmp = mxGetField (tsdb, 0, TSDB_DBNAME_FIELD_NAME);
  if (NULL == tmp) {
    mexErrMsgTxt ("Can't find dbname in tsdb\n");
  }
  strlen = mxGetN (tmp);
  dbname = (char *) malloc (strlen * sizeof (char) + 1);
  if (mxGetString (tmp, dbname, strlen + 1)) {
    mexErrMsgTxt ("Error getting the dbname from the tsdb\n");
  }
  tmp = mxGetField (tsdb, 0, TSDB_HOST_FIELD_NAME);
  if (NULL == tmp) {
    mexErrMsgTxt ("Can't find field host in tsdb\n");
  }
  strlen = mxGetN (tmp);
  host = (char *) malloc (strlen * sizeof (char) + 1);
  if (mxGetString (tmp, host, strlen + 1)) {
    mexErrMsgTxt ("Error getting the host from the tsdb\n");
  }
  tmp = mxGetField (tsdb, 0, TSDB_PASSWORD_FIELD_NAME);
  if (NULL == tmp) {
    mexErrMsgTxt ("Can't find field password in tsdb\n");
  }
  strlen = mxGetN (tmp);
  password = (char *) malloc (strlen * sizeof (char) + 1);
  if (mxGetString (tmp, password, strlen + 1)) {
    mexErrMsgTxt ("Error getting the password from the tsdb\n");
  }
  ConnectionParams *info =
    new ConnectionParams (username, password, host, dbname);
  return info;
}

void
mexFunction (int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
  const mxArray *tsdb;
  char *name;
  mwSize buflen;
  

  /* Checking Input Arguments */
  vector<RequestInfo*>* argsinfo = checkInputArguments(prhs, nrhs);


  if (DEBUG) {
    for (unsigned int i = 0; i < argsinfo->size (); i++) {    
      RequestInfo *requestInfo = argsinfo->at (i);
      mexPrintf("RequestInfo at %d name:%15s  release: %d\n", i, requestInfo->getName(), requestInfo->getDate());
    }       
  }

  /* tsdb is the first argument */
  tsdb = prhs[0];


  /* Setting db connection */
  ConnectionParams *params = NULL;

  if (!conn.connected ()) {
    /* se non sono connesso mi connetto */
    params = getConnectionParameters(tsdb);
    if (!conn.connect (params->dbname, 
		       params->host, 
		       params->username,
		       params->password)) {
      mexPrintf ("Connection ERROR: %s\n", conn.error ());
      return;
    } else {
      /* dico a Matlab che funzione caricare quando questo 
	 Mex viene eliminato dalla memoria */
      mexAtExit (disconnect);
    }
  }


  RequestInfo *requestInfo = NULL;
  TsInfo *info = NULL;
  ReleaseInfo *rinfo = NULL;
  mxArray* meta_cols = NULL;
  
  for (unsigned int i = 0; i < argsinfo->size (); i++) {

    requestInfo = argsinfo->at (i);

    if (DEBUG) 
      {
	mexPrintf("Requesting %d series %s\n", i, requestInfo->getName());
      }



    info = GetInfo (string (requestInfo->getName ()));    
    if (!info) {
      delete params;
      stringstream msg;
      msg << "No informations available for the requested series: ";
      msg << requestInfo->getName();
      mexErrMsgTxt (msg.str().c_str());
      return;
    }


    rinfo = GetLastRelease (info->id);   
    if (!rinfo) {
      delete params;
      delete info;
      stringstream msg;
      msg << "No release informations available for requested series: ";
      msg << " id : " << info->id << " Name: " << requestInfo->getName();
      mexErrMsgTxt(msg.str().c_str());
      return;
    }

    meta_cols = GetMetaData (i,argsinfo->size(),meta_cols,rinfo->vid, info->id);

  }
      
  plhs[0] = meta_cols;

  free (info);
  free (rinfo);


  /**
   * Garbage Collection 
   */
  delete params;
  if (argsinfo->size ()) {
    for (unsigned int i = 0; i < argsinfo->size (); i++) {
      RequestInfo *tmp = argsinfo->at (i);
      delete tmp;
    }
  }
  delete argsinfo;
}
