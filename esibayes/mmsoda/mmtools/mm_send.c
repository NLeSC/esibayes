#include "mex.h"
#include <mpi.h>
#include <stdio.h>
#include <string.h>
#include "../mmlib/matlabmpi.h"
/*
 * Function that sends a message (variable)
 */

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int source, destination, usempi, buffersize;
	size_t numbytes;
	double *dum, *d_buf;
        int *i_buf;
	mxArray *sourcestruct, *bufferstruct;

	if (nrhs!=2) {
		mexErrMsgIdAndTxt("mm_send:paramerror","Please pass a single variable and the destination of the transmission.");
	}

	sourcestruct=mexGetVariable("base","mpirank");
	bufferstruct=mexGetVariable("base","mpibuffersize");
	if(sourcestruct==NULL) {
		mexErrMsgIdAndTxt("mm_send:nompirank","mpirank is not defined in base workspace.");
	}
	if(bufferstruct==NULL) {
		mexErrMsgIdAndTxt("mm_send:nompibuffersize","mpibuffersize is not defined in base workspace.");
	}
	dum=mxGetPr(sourcestruct);
	source=(int)dum[0];
	dum=mxGetPr(prhs[0]);
	destination=(int)dum[0];
	dum=mxGetPr(bufferstruct);
	buffersize=(int)dum[0];

	if (!mxIsClass(prhs[1],"uint8")) {
		mexErrMsgIdAndTxt("mm_send:notserialized","Please serialize your MATLAB struct first.");
	}

	MPI_Initialized(&usempi);
	if (usempi) {
		numbytes=mxGetNumberOfElements(prhs[1]);
		if ((sizeof(int)+numbytes)>buffersize) {
			mexErrMsgIdAndTxt("mm_send:buffertoosmall","The chosen buffer is too small. Please use the '-b' option.");
		}
		if (MM_BUFFER==NULL) {
			MM_BUFFER=malloc(buffersize);
		}
		i_buf=(int*) MM_BUFFER;
		*i_buf=numbytes;
		d_buf=(double*) i_buf+1;
		memcpy(d_buf,mxGetPr(prhs[1]),numbytes);
		MPI_Send(MM_BUFFER,buffersize,MPI_BYTE,destination,102,MPI_COMM_WORLD);
	} else {
		mexErrMsgIdAndTxt("mm_send:notmpi","This function does not support interactive usage (yet).");
	}
	mxDestroyArray(sourcestruct);
	mxDestroyArray(bufferstruct);
	return;
}
