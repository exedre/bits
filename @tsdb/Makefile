DEBUG=1

ifeq ($(DEBUG),1)
  DEBUG = -g -DDEBUG=1
else
  DEBUG = -DDEBUG=0
endif

CXXFLAGS= ${DEBUG} -I. `mysql_config --include` -I/usr/local/include/mysql++ -I$(HOME)/work/bits++ 
LDFLAGS= tsloadlib.o -L/usr/local/lib -lmysqlpp `mysql_config --libs` 
PGMS=ntsload_native ntsloadmeta_native
MEX=mex
MEX_SUFFIX=mexglx
ALL: $(PGMS)

ntsload_native : ntsload.cpp tsloadlib.o tsload.hpp
	$(MEX) $(CXXFLAGS) $<  -o $@.$(MEX_SUFFIX) $(LDFLAGS)

ntsloadmeta_native : ntsloadmeta.cpp tsloadlib.o  tsload.hpp
	$(MEX) $(CXXFLAGS) $< -o $@.$(MEX_SUFFIX) $(LDFLAGS)

tsloadlib.o: tsloadlib.cpp
	$(MEX) $(CXXFLAGS) -c $< -o $@

clean:
	$(RM) *.$(MEX_SUFFIX) *~ *.o
