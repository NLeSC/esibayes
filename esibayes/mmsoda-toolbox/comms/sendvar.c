/*=================================================================
 * The main routine analyzes all incoming (right-hand side) arguments 
 *
 * sendvar 1.0 - completely in C
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
    mxArray *sourcestruct;
    int source, destination, usempi;
    double *dum;
    char* mpibuffer;
    unsigned long mpibuffersize;
#ifdef TIMINGS
    mxArray *ststruct;
    int savetimings;
#endif 
    
    if (nrhs!=2) {
        mexErrMsgTxt("Please pass a single variable and the destination of the transmission.");
    }

    sourcestruct=mexGetVariable("base","mpirank");
    if(sourcestruct==NULL) {
        mexErrMsgTxt("mpirank is not defined in base workspace.");
    }
    
    MPI_Initialized(&usempi);
    if (!usempi) {
        mexErrMsgTxt("MPI is not initialized.");
    }
    
    dum=mxGetPr(sourcestruct);
    source=(int)dum[0];
    dum=mxGetPr(prhs[0]);
    destination=(int)dum[0];
#ifdef TIMINGS
    ststruct=mexGetVariable("base","savetimings");
    if (ststruct!=NULL) {
        savetimings=(int)*mxGetPr(ststruct);
        if (savetimings==1) {
            SetTimeStamp(3);
            SetTimeStamp(31);
        }
    }
#endif
    mpibuffer=SerializeVar(prhs[1],&mpibuffersize);
#ifdef TIMINGS
    if (savetimings==1) {
        SetTimeStamp(32);
        SetTimeStamp(33);
    }
#endif
    MPI_Send(&mpibuffersize,1,MPI_UNSIGNED_LONG,destination,101,MPI_COMM_WORLD);
    MPI_Send(mpibuffer,mpibuffersize,MPI_BYTE,destination,102,MPI_COMM_WORLD);
#ifdef TIMINGS
    if (savetimings==1) {
        SetTimeStamp(34);
        SetTimeStamp(4);
    }
    mxDestroyArray(ststruct);
#endif
    free(mpibuffer);
    mxDestroyArray(sourcestruct);
}
