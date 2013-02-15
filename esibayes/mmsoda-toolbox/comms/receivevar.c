/*=================================================================
 * The main routine analyzes all incoming (right-hand side) arguments 
 *
 * receivevar 1.0 - completely in C
 *
 * Copyright 2013 Jeroen Engelberts, SURFsara
 *	
 *=================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <mpi.h>
#include "mex.h"
#include "mat.h"
#include "helper.h"

/* mexFunction is the gateway routine for the MEX-file. */ 
void
mexFunction( int nlhs, mxArray *plhs[],
             int nrhs, const mxArray *prhs[] )
{
    mxArray *deststruct;
    int source, destination, usempi;
    double *dum;
    char* mpibuffer;
    unsigned long mpibuffersize;
    MPI_Status status;
#ifdef TIMINGS
    mxArray *ststruct;
    int savetimings;
#endif    
    if (nrhs>2) {
        mexErrMsgTxt("Please optionally pass the source of the transmission).");
    }

    deststruct=mexGetVariable("base","mpirank");
    if(deststruct==NULL) {
        mexErrMsgTxt("mpirank is not defined in base workspace.");
    }
    
    MPI_Initialized(&usempi);
    if (!usempi) {
        mexErrMsgTxt("MPI is not initialized.");
    }
#ifdef TIMINGS
    ststruct=mexGetVariable("base","savetimings");
    if (ststruct!=NULL) {
        savetimings=(int)*mxGetPr(ststruct);
        if (savetimings==1) {
            SetTimeStamp(1);
            SetTimeStamp(35);
        }
    }
#endif
    dum=mxGetPr(deststruct);
    destination=(int)dum[0];    
    if (nrhs==1) {
        dum=mxGetPr(prhs[0]);
        source=(int)dum[0];
        MPI_Recv(&mpibuffersize,1,MPI_UNSIGNED_LONG,source,101,MPI_COMM_WORLD,&status);
    } else {
        MPI_Recv(&mpibuffersize,1,MPI_UNSIGNED_LONG,MPI_ANY_SOURCE,101,MPI_COMM_WORLD,&status);
        source=status.MPI_SOURCE;
    }
    mpibuffer=malloc(mpibuffersize);
    MPI_Recv(mpibuffer,mpibuffersize,MPI_BYTE,source,102,MPI_COMM_WORLD,&status);
#ifdef TIMINGS
    if (savetimings==1) {
        SetTimeStamp(36);
        SetTimeStamp(37);
    }
#endif
    plhs[0]=DeserializeVar(mpibuffer,mpibuffersize);
#ifdef TIMINGS
    if (savetimings==1) {
        SetTimeStamp(38);
        SetTimeStamp(2);
    }
    mxDestroyArray(ststruct);
#endif
    free(mpibuffer);
    mxDestroyArray(deststruct);
}
