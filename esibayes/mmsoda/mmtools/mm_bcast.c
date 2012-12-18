#include "mex.h"
#include <mpi.h>
#include <stdio.h>
#include <string.h>
#include "../mmlib/matlabmpi.h"
/*
 * Function that broadcasts a message (variable)
 */

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int myself,root,usempi,buffersize;
	double *dum, *d_buf;
	int *i_buf;
	mxArray *myselfstruct, *bufferstruct;

	if (nrhs!=2) {
		mexErrMsgIdAndTxt("mm_bcast:paramerr1","Please pass a single variable and the root of the broadcast.");
	}
	if (nlhs!=1) {
		mexErrMsgIdAndTxt("mm_bcast:paramerr2","This will only result in a single variable.");
	}
	myselfstruct=mexGetVariable("base","mpirank");
	bufferstruct=mexGetVariable("base","mpibuffersize");
	if(myselfstruct==NULL) {
		mexErrMsgIdAndTxt("mm_bcast:nompirank","mpirank is not defined in base workspace.");
	}
	if(bufferstruct==NULL) {
		mexErrMsgIdAndTxt("mm_bcast:nompibuffersize","mpibuffersize is not defined in base workspace.");
	}
	dum=mxGetPr(myselfstruct);
	myself=(int)dum[0];
	dum=mxGetPr(bufferstruct);
	buffersize=(int)dum[0];
	dum=mxGetPr(prhs[0]);
	root=(int)dum[0];

	if (!mxIsClass(prhs[1],"uint8")) {
		mexErrMsgIdAndTxt("mm_bcast:notserialized","Please serialize your MATLAB struct first.");
	}

	MPI_Initialized(&usempi);
	if (usempi) {
		if (MM_BUFFER==NULL) {
			MM_BUFFER=malloc(buffersize);
		}
		if (myself==root) {
			i_buf=(int*) MM_BUFFER;
			i_buf[0]=mxGetNumberOfElements(prhs[1]);
			d_buf=(double*) i_buf+1;
			memcpy(d_buf,mxGetPr(prhs[1]),i_buf[0]);
		}
		MPI_Bcast(MM_BUFFER,buffersize,MPI_BYTE,root,MPI_COMM_WORLD);
		i_buf=(int*) MM_BUFFER;
		d_buf=(double*) i_buf+1;
		plhs[0]=mxCreateNumericMatrix(i_buf[0],1,mxUINT8_CLASS,mxREAL);
		memcpy(mxGetPr(plhs[0]),d_buf,i_buf[0]);
	} else {
		mexErrMsgIdAndTxt("mm_bcast:notmpi","This function does not support interactive usage (yet).");
	}
	mxDestroyArray(myselfstruct);
	mxDestroyArray(bufferstruct);
	return;
}
