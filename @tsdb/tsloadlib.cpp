#include "tsload.hpp"

#include <matrix.h>




/**
 * Date due periodi, espressi come starty,startp e freq ritorna 
 * il numero di osservazioni da fillare all'indietro
 */

int fillBack(int starty1, int startp1, int freq1,
             int starty2, int startp2, int freq2) {
  if(freq1 != freq2) {
    return -1;
  }

  double start1 = ((double) starty1) + ((double) startp1/freq1);
  double start2 = ((double) starty2) + ((double) startp2/freq2);
  double diff;
  if(start1>start2) {
     diff = (start1-start2) * ((double)freq1);
  } else {
     diff = (start2-start1) * ((double)freq1);
  }
  return (int) diff;
}


/**
 * funzione di appoggio per sign : non mi andava di cercare header files o 
 * nomi analoghi per una funzione cosi' scema: l'ho riscritta da zero
 * 
 * serve a start2end, copiato pedissequamente da matlab.
 */

int sign(int x) 
{
  return ( 0==x ? 0 : ( x > 0 ? 1 : -1 ));
}

Period start2end(int freq, Period s, int dist)  {
  return start2end(freq, s.year, s.period, dist);
}

Period start2end(int freq, int sy, int sp, int d) 
{
  Period px;
  int dist = d-1;
  int mod = ((sp+dist) % freq) ;
  px.period = mod * (mod != 0) + freq * (mod == 0);

  int ny = int(floor((sp+dist) / freq));
  int resto  = sign(sp+dist) * mod;
  if(dist < 0) {
    if( resto <= 0 ) { 
      ny--;
    } else {
      ny=0;
    }
  } else {
    if  ( 0 == mod) {
      ny--;
    }
  }

  px.year = sy + ny;
  return px;
}


mxArray *
GetMetaData (int m, int imax, mxArray* meta_cols,long vid, long id)
{
  stringstream numsql;
  stringstream strsql;
  vector < Pair * >pairs;;

  // mexPrintf (">>GetMetaData: %d %x %d/%d \n", m,meta_cols,vid,id);	

  /* Estrai le stringhe */
  numsql << "SELECT N.Name, s.value FROM meta M, metaname N, metastr s WHERE N.MID = M.MID AND M.VID =";
  numsql << vid << " AND M.ID =" << id << " AND s.XID = M.XID";
  mysqlpp::Query query = conn.query (numsql.str());

  if (mysqlpp::UseQueryResult res = query.use()) {
    while (mysqlpp::Row row = res.fetch_row()) {
      if (conn.errnum ()) {
	mexPrintf ("Error received in fetching a row: %s\n", conn.error ());
	return NULL;
      }
      char *name = (char *) malloc (strlen (row[0]) * sizeof (char) + 1);
      char *stringValue =
	(char *) malloc (strlen (row[1]) * sizeof (char) + 1);
      strcpy (name, row[0]);
      strcpy (stringValue, row[1]);
      pairs.push_back (new Pair (name, stringValue));
    }
  } else {
    mexPrintf ("Failed to get item list: %s \n", query.error ());
    return NULL;
  }


  /* Estrai i numeri */
  strsql <<
    "SELECT N.Name, s.value FROM meta M, metaname N, metanum s WHERE N.MID = M.MID AND M.VID =";
  strsql << vid << " AND M.ID =" << id << " AND s.XID = M.XID";
  mysqlpp::Query strquery = conn.query (strsql.str ());
  if (mysqlpp::UseQueryResult res = strquery.use ()) {
    while (mysqlpp::Row row = res.fetch_row ()) {
      if (conn.errnum ()) {
	mexPrintf ("Error received in fetching a row: %s\n", conn.error ());
	return NULL;
      }
      char *name = (char *) malloc (strlen (row[0]) * sizeof (char) + 1);
      strcpy (name, row[0]);
      pairs.push_back (new Pair (name, atof (row[1])));
    }
  } else {
    mexPrintf ("Failed to get item list: %s \n", strquery.error ());
    return NULL;
  }


  int i = 0;

  /* If meta_cols is Empty create meta_cols contents fields */

  if (NULL==meta_cols) 
    {
      int number_of_fields = pairs.size ();
      unsigned int i;
      char **field_names = (char **) malloc (number_of_fields * sizeof (char *));

      // creo i nomi dei campi cosi' come li ho presi dal DB

      for (i = 0; i < pairs.size (); i++) {
	field_names[i] =
	  (char *) malloc (strlen (pairs[i]->getName ()) * sizeof (char));
	strcpy (field_names[i], pairs[i]->getName ());
      }
      const mwSize ndim = 2;
      const mwSize dims[2] = { 1, 1 };
      // creo la struttura dati per matlab  
      meta_cols = mxCreateStructArray (ndim, dims, number_of_fields,
				       (const char **) field_names);
      //mexPrintf (">>making meta_cols: %x %d \n",meta_cols,imax);

      for (i = 0; i < pairs.size (); i++) {
	mxArray *cell = mxCreateCellMatrix(1,imax);
	mxSetField (meta_cols, 0, field_names[i], cell);
	//mexPrintf (">>making cell: %d %x \n",i, cell);		
      }
    }


  /* */
  for (i = 0; i < pairs.size (); i++) {
    mxArray* cell = mxGetField(meta_cols, 0, pairs[i]->getName ());
    //mexPrintf (">>getting cell: %d %x \n", i,cell);
    if (NULL==cell) {
      // mexPrintf (">>cannot get cell for name %s in series %d \n", pairs[i]->getName(),m);
      continue;
    }
    if (pairs[i]->isChar ()) {
      //mexPrintf (">>putting value: %s\n", pairs[i]->getStringValue () );
      mxSetCell (cell, m, mxCreateString (pairs[i]->getStringValue ()));
    } else {
      //mexPrintf (">>putting value: %f\n", pairs[i]->getDoubleValue () );
      mxArray *field_value;
      field_value = mxCreateDoubleMatrix (1, 1, mxREAL);
      *mxGetPr (field_value) = pairs[i]->getDoubleValue ();
      mxSetCell (cell, m, field_value);
    }
    delete pairs[i];
  }
  return meta_cols;
}

ReleaseInfo *
GetRelease (long id, long release)
{
  ReleaseInfo *info = NULL;
  stringstream sql;
  sql <<
    "select VID, Start_year, Start_period, version, resolution from version where id = ";
  sql << id << " and Rel=" << release;
  mysqlpp::Query query = conn.query (sql.str ());
  if (mysqlpp::UseQueryResult res = query.use ()) {
    info = (ReleaseInfo *) malloc (sizeof (ReleaseInfo));
    while (mysqlpp::Row row = res.fetch_row ()) {
      info->vid = atol (row[0]);
      info->start_y = atoi (row[1]);
      info->start_p = atoi (row[2]);
      info->version = atoi (row[3]);
      info->resolution = atoi (row[4]);
      info->release = release;
    }
  }
  return info;
}

ReleaseInfo *
GetLastRelease (long id)
{
  ReleaseInfo *info = NULL;
  stringstream sql;
  sql <<
    "select VID, Start_year, Start_period, version, resolution, rel from version where id = ";
  sql << id << " order by rel desc limit 1";
  mysqlpp::Query query = conn.query (sql.str ());
  if (mysqlpp::UseQueryResult res = query.use ()) {
    mysqlpp::Row row = res.fetch_row ();
    if (row) {
      info = (ReleaseInfo *) malloc (sizeof (ReleaseInfo));
      info->vid = atol (row[0]);
      info->start_y = atoi (row[1]);
      info->start_p = atoi (row[2]);
      info->version = atoi (row[3]);
      info->resolution = atoi (row[4]);
      info->release = atol (row[5]);
    }
  }
  return info;
}

TsInfo *
GetInfo (const string label)
{
  stringstream sql;
  TsInfo *info = NULL;

  sql << "select ID,Freq from series where Name= '" << label << "'";
  mysqlpp::Query query = conn.query (sql.str ());
  if (mysqlpp::UseQueryResult res = query.use ()) {
    mysqlpp::Row row = res.fetch_row ();
    if (row) {
      info = (TsInfo *) malloc (sizeof (TsInfo));
      info->id = atol (row[0]);
      info->freq = atoi (row[1]);
    }
  }
  return info;
}


/**
 * ottiene le osservazioni dal DB.
 * molto timidamente usa una struttura dati di bits++
 */

column 
GetData (long vid, long id)
{
  unsigned int i;
  column col;

  
  stringstream sql;
  sql << "select value from data where vid=";
  sql << vid << " and id=" << id << " order by seq";
  mysqlpp::Query query = conn.query (sql.str ());
  if (mysqlpp::UseQueryResult res = query.use ()) {
    while (mysqlpp::Row row = res.fetch_row ()) {
      col.push_back(atof(row[0]));
    }
  }
  return col;
}


/**
 * capolavoro d'ingegneria del software, ovviamente copiato pari pari da qualche parte
 */

mxArray* 
convertMatrix2mxArray(matrix vdata) {
  int m = vdata.size();
  int n = vdata.nobs();

  // array temporaneo con le osservazioni 
  double *data = (double *) malloc (m * n * sizeof (double));
  matrix::iterator p=vdata.begin(),e=vdata.end();
  int i = 0;
  for (;p!=e;p++) {
    for (int j=0; j<n;j++) {
      data[j*m+i] = (*p)[j];
    }
    i++;
  }
  mxArray *returned =mxCreateDoubleMatrix(m,n,
					  mxREAL);
  size_t bytes_to_copy = m*n * (size_t) mxGetElementSize (returned);
  unsigned char *start_of_pr = (unsigned char *) mxGetData (returned);
  memcpy (start_of_pr, data, bytes_to_copy);
  free (data);
  return returned;
}

/**
 * questa funzione disconnette dal DB quando il MEX viene eliminato 
 * garbage collected
 */

void
disconnect ()
{
  //  mexPrintf ("disconnecting...\n");
  conn.disconnect ();
  //  mexPrintf ("disconnected\n");
}


