/*=================================================================
 * The main routine analyzes all incoming (right-hand side) arguments 
 *
 * bcastvar 1.0 - completely in C
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
             int nrhs, const mxArray *prhs[])
{
    int myself,root,usempi;
    char *mpibuffer;
    unsigned long mpibuffersize;
    double *dum;
    mxArray *myselfstruct;

    if (nrhs>2) {
        mexErrMsgTxt("Please pass the root of the broadcast (and only mandatory for root the variable).");
    }

    myselfstruct=mexGetVariable("base","mpirank");
    if(myselfstruct==NULL) {
        mexErrMsgTxt("mpirank is not defined in base workspace.");
    }

    dum=mxGetPr(myselfstruct);
    myself=(int)dum[0];
    dum=mxGetPr(prhs[0]);
    root=(int)dum[0];

    MPI_Initialized(&usempi);
    if (!usempi) {
        mexErrMsgTxt("MPI is not initialized.");
    }

    if (myself==root) {
        if (nrhs<2) {
            mexErrMsgTxt("For root, a second parameter is required."); 
        }
        mpibuffer=SerializeVar(prhs[1],&mpibuffersize);
        MPI_Bcast(&mpibuffersize,1,MPI_UNSIGNED_LONG,root,MPI_COMM_WORLD);
        MPI_Bcast(mpibuffer,mpibuffersize,MPI_BYTE,root,MPI_COMM_WORLD);
    } else {
        MPI_Bcast(&mpibuffersize,1,MPI_UNSIGNED_LONG,root,MPI_COMM_WORLD);
        mpibuffer=malloc(mpibuffersize);
        MPI_Bcast(mpibuffer,mpibuffersize,MPI_BYTE,root,MPI_COMM_WORLD);
    }
    plhs[0]=DeserializeVar(mpibuffer,mpibuffersize);
    free(mpibuffer);
    mxDestroyArray(myselfstruct);
}
