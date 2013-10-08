#include "mex.h"
#include <mpi.h>
#include <string.h>
#include "matlabmpi.h"
/*
 * Tiny function that receives a message
 */

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	size_t numbytes;
	int destination,source,usempi,buffersize;
	double *dum, *d_buf;
	int *i_buf;
	mxArray *deststruct, *bufferstruct;
	MPI_Status status;

	if (nrhs!=1) {
		mexErrMsgIdAndTxt("mm_receive:paramerr1","Please pass the source of the transmission.");
	}
	if (nlhs!=1) {
		mexErrMsgIdAndTxt("mm_receive:paramerr2","This will only result in a single variable.");
	}
	deststruct=mexGetVariable("base","mpirank");
	bufferstruct=mexGetVariable("base","mpibuffersize");
	if (deststruct==NULL) {
		mexErrMsgIdAndTxt("mm_receive:nompirank","mpirank is not defined in base workspace.");
	}
	if (bufferstruct==NULL) {
		mexErrMsgIdAndTxt("mm_receive:nompibuffersize","mpibuffersize is not defined in base workspace.");
	}
	dum=mxGetPr(deststruct);
	destination=(int)dum[0];
	dum=mxGetPr(bufferstruct);
	buffersize=(int)dum[0];
	dum=mxGetPr(prhs[0]);
	source=(int)dum[0];

	MPI_Initialized(&usempi);
	if (usempi) {
		if (MM_BUFFER==NULL) {
			MM_BUFFER=malloc(buffersize);
		}
		if (source<0) {
			MPI_Recv(MM_BUFFER,buffersize,MPI_BYTE,MPI_ANY_SOURCE,102,MPI_COMM_WORLD,&status);
			source=status.MPI_SOURCE;
		} else {
			MPI_Recv(MM_BUFFER,buffersize,MPI_BYTE,source,102,MPI_COMM_WORLD,&status);
		}
		i_buf=(int*) MM_BUFFER;
		numbytes=i_buf[0];
		d_buf=(double*) i_buf+1;
		plhs[0]=mxCreateNumericMatrix(numbytes,1,mxUINT8_CLASS,mxREAL);
		memcpy(mxGetPr(plhs[0]),d_buf,numbytes);
	} else {
		mexErrMsgIdAndTxt("mm_receive:notmpi","This function does not support interactive usage (yet).");
	}
	mxDestroyArray(deststruct);
	mxDestroyArray(bufferstruct);
	return;
}
