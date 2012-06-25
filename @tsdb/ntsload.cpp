#include "tsload.hpp"

#include <matrix.h>

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
    mexErrMsgTxt ("tsload need at least 2 arguments");
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
  if (!mxIsChar (prhs[1]) && !mxIsCell (prhs[1]))
    {
      showUsage ();
      mexErrMsgTxt ("second argument has to be a char or a cell array");
      return NULL;
    }

  /** 
   * Third (if exists) must be a numeric or a cell-array
   */
  if (nrhs==3)
    {
      if (!mxIsNumeric (prhs[2]) && !mxIsCell (prhs[2]))
	{
	  showUsage ();
	  mexErrMsgTxt ("third argument has to be a numeric or a cell array");
	  return NULL;
	}
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

  } else { /* Se la specifica delle serie è un cell-array */
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
  }


  /* If I got here I have a RequestInfo with at least 1 name */
  if (nrhs==2)
    return infos;

  if (mxIsEmpty(prhs[2]))
    return infos;

  if (DEBUG) {
      mexPrintf("\nDEBUG----\n3rd->Numeric %d\n3rd->len %d\n",
		mxIsNumeric(prhs[2]), (mxIsCell(prhs[2]) ? mxGetN(prhs[2]) : 0)
		);

    }

  /*** 3rd Parameter Management (date definition) ***/
  int nD ;

  if (mxIsNumeric (prhs[2])) nD=1;
  else nD = mxGetN (prhs[2]); 

  /**
   * Sono si richiedono le serie a release predefinite
   * Controllo anche le date
   */
  int nS = infos->size();


  /* Le uniche soluzioni compatibili sono:
     
     nS == nD 
     nS == 1, nD == n
     nS == n, nD == 1
  */


  mexPrintf("nS=%d, nD=%d\n",nS,nD);


  if (nS==nD) {
    /* Adds release to info */
    for (unsigned int i = 0; i < nD; i++) 
      {
	const mxArray *cell = mxGetCell (prhs[2], i);
	double& a = *(double*)mxGetPr(cell);
	infos->at(i)->setDate( (long) a );
      }      
    return infos;
  }


  if (nS==1 && nD > 1) {

    /* Copies requestinfo with new release */
    RequestInfo *r = infos->at(0);
    const mxArray *cell = mxGetCell (prhs[2], 0);
    double& a = *(double*)mxGetPr(cell);
    infos->at(0)->setDate( (long) a );
    for (unsigned int i = 1; i < nD; i++) 
      {
	char *nome = (char *) malloc (strlen(r->getName()) * sizeof (char) + 1);
	strcpy(nome,r->getName());
	RequestInfo *tmp = new RequestInfo (nome);
	const mxArray *cell = mxGetCell (prhs[2], i);
	double& a = *(double*)mxGetPr(cell);
	tmp->setDate( (long) a );
	infos->push_back (tmp);
	
      }      
    return infos;
  }

  if (nD==1 && nS > 1) {
    //    const mxArray *cell = mxGetCell (prhs[2], 0);
    double& a = *(double*)mxGetPr(prhs[2]);
    for (unsigned int i = 0; i < nS; i++) 
      {
	infos->at(i)->setDate( (long) a );
      }
    return infos;
  }

  showUsage ();
  mexErrMsgTxt ("second and third argument size mismatch");
  return NULL;

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


  matrix datamatrix;
  RequestInfo *requestInfo = NULL;
  TsInfo *info = NULL;
  ReleaseInfo *rinfo = NULL;
  mxArray* meta_cols = NULL;
  
  //  tsmat<matrix, double> ret;
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

    column col = GetData(rinfo->vid, info->id);    
    datamatrix.push_back(col);

    // meta_cols = GetMetaData (i,argsinfo->size(),meta_cols,rinfo->vid, info->id);

  }
  
  if(DEBUG) {
  
    mexPrintf("NAN value = %f \n", NAN );
    mexPrintf("Data matrix contents:\n");
    column c;
    for (int i=0; i<datamatrix.size() ; i++) {
      c = datamatrix[i];
      for (int j=0; j<c.size(); j++) {
         mexPrintf("%d  ", c.at(j)); 
      }
      mexPrintf("\n");
      mexPrintf("Column size=%d\n",c.size());
    }
    mexPrintf("DataMatrix size=%d\n",datamatrix.size());     
  }


  /*
  tsmat<matrix,double> ts = tsmat<matrix,double>(
			    rinfo->start_y, 
			    rinfo->start_p, 
			    info->freq, 
			    datamatrix);
  */

  mxArray* data = convertMatrix2mxArray(datamatrix);

  mxArray* start_year = mxCreateDoubleScalar(rinfo->start_y);
  mxArray* start_period = mxCreateDoubleScalar(rinfo->start_p);
  mxArray* freq = mxCreateDoubleScalar(info->freq);

  Period last = start2end(info->freq, rinfo->start_y, rinfo->start_p, mxGetM(data));
  mxArray* last_year = mxCreateDoubleScalar(last.year);
  mxArray* last_period = mxCreateDoubleScalar(last.period);

  const char *fieldnames[] = {MATDATA,
			      START_YEAR,
			      START_PERIOD,
			      FREQ,
			      LAST_YEAR,
			      LAST_PERIOD,
			      META,
			      META_COLS };
  const mwSize ndim = 2;
  const mwSize dims[2] = {1,1};
    
  plhs[0] = mxCreateStructArray(ndim, dims, NUMBER_OF_FIELDS, fieldnames);

  mxSetField(plhs[0],0, MATDATA, data);
  mxSetField(plhs[0],0, START_YEAR, start_year);
  mxSetField(plhs[0],0, START_PERIOD, start_period);
  mxSetField(plhs[0],0, FREQ, freq);
  mxSetField(plhs[0],0, LAST_YEAR, last_year);
  mxSetField(plhs[0],0, LAST_PERIOD, last_period );
  mxSetField(plhs[0],0, META, NULL);
  mxSetField(plhs[0],0, META_COLS, meta_cols);

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
