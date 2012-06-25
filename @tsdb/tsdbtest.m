function ts = tsdbtest(db)
conn = db.conn ;
tsx = tsmat(1980,1,12,rand(20,5),'x',today);
tsy = tsmat(1980,4,12,rand(20,5),'x',today-7);
tsstore(db,tsx)
tsstore(db,tsy)
