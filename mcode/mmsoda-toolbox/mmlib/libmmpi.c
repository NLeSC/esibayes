/*
 * MATLAB Compiler: 4.18 (R2012b)
 * Date: Tue Mar 19 14:43:34 2013
 * Arguments: "-B" "macro_default" "-B" "csharedlib:libmmpi" "-W" "lib:libmmpi"
 * "-T" "link:lib" "./../mmsoda-toolbox/comms/getverbosity.m"
 * "./../mmsoda-toolbox/comms/setmpistuff.m"
 * "./../mmsoda-toolbox/comms/whoami.m"
 * "./../mmsoda-toolbox/mmlib/matlabmain.m"
 * "./../mmsoda-toolbox/mmlib/runmpirankOtherFun.m"
 * "./../mmsoda-toolbox/mmlib/runmpirankOther.m"
 * "./../mmsoda-toolbox/comms/bcastvar.mexa64"
 * "./../mmsoda-toolbox/comms/receivevar.mexa64"
 * "./../mmsoda-toolbox/comms/sendvar.mexa64" "model/calcLikelihood.m"
 * "model/lorenz_calc.m" "model/lorenzeq.m" "model/myviz.m"
 * "./../mmsoda-toolbox/mmsodaAbortOptim.m"
 * "./../mmsoda-toolbox/mmsodaAllComb.m" "./../mmsoda-toolbox/mmsodaCalcCbWb.m"
 * "./../mmsoda-toolbox/mmsodaCalcObjScore.m"
 * "./../mmsoda-toolbox/mmsodaContinue.m"
 * "./../mmsoda-toolbox/mmsodaEvolveComplex.m"
 * "./../mmsoda-toolbox/mmsodaGelmanRubin.m"
 * "./../mmsoda-toolbox/mmsodaGenerateOffspring.m"
 * "./../mmsoda-toolbox/mmsodaInitialize.m" "./../mmsoda-toolbox/mmsoda.m"
 * "./../mmsoda-toolbox/mmsodaPartComplexes.m"
 * "./../mmsoda-toolbox/mmsodaPrepRejArray.m"
 * "./../mmsoda-toolbox/mmsodaPrepSeqArray.m"
 * "./../mmsoda-toolbox/mmsodaStratDraw.m"
 * "./../mmsoda-toolbox/mmsodaStratRandDraw.m"
 * "./../mmsoda-toolbox/mmsodaUnifRandDraw.m"
 * "./../mmsoda-toolbox/tools/mmsodaBestEval.m"
 * "./../mmsoda-toolbox/tools/mmsodaBestParsets.m"
 * "./../mmsoda-toolbox/tools/mmsodaBestScore.m"
 * "./../mmsoda-toolbox/tools/mmsodaCalcUncertInts.m"
 * "./../mmsoda-toolbox/tools/mmsodaCheckForOldResults.m"
 * "./../mmsoda-toolbox/tools/mmsodaCopyMakefile.m"
 * "./../mmsoda-toolbox/tools/mmsodaDiffStruct.m"
 * "./../mmsoda-toolbox/tools/mmsodaGetPrecedingAccepted.m"
 * "./../mmsoda-toolbox/tools/mmsodaIsColumn.m"
 * "./../mmsoda-toolbox/tools/mmsodaLoadSettings.m"
 * "./../mmsoda-toolbox/tools/mmsodaOpenBrowser.m"
 * "./../mmsoda-toolbox/tools/mmsodaOpenPdf.m"
 * "./../mmsoda-toolbox/tools/mmsodaPack.m"
 * "./../mmsoda-toolbox/tools/mmsodaParetoPrinciple.m"
 * "./../mmsoda-toolbox/tools/mmsodaParsePairs.m"
 * "./../mmsoda-toolbox/tools/mmsodaPrctile.m"
 * "./../mmsoda-toolbox/tools/mmsodaPrepParallelFiles.m"
 * "./../mmsoda-toolbox/tools/mmsodaPurgeResults.m"
 * "./../mmsoda-toolbox/tools/mmsodaRetrieveEnsembleData.m"
 * "./../mmsoda-toolbox/tools/mmsodaroot.m"
 * "./../mmsoda-toolbox/tools/mmsodaSaveConf.m"
 * "./../mmsoda-toolbox/tools/mmsodaSubplotScreen.m"
 * "./../mmsoda-toolbox/tools/mmsodaUnpack.m"
 * "./../mmsoda-toolbox/tools/mmsodaVerifyFieldNames.m"
 * "./../mmsoda-toolbox/tools/mmsodaWriteJobscript.m"
 * "./../mmsoda-toolbox/tools/subaxes.m" "./../mmsoda-toolbox/tools/uimatlab.m"
 * "./../mmsoda-toolbox/tools/uioctave.m"
 * "./../mmsoda-toolbox/visualization/mmsodaAnalyzeTimings.m"
 * "./../mmsoda-toolbox/visualization/mmsodaMakeColors.m"
 * "./../mmsoda-toolbox/visualization/mmsodaMargHist.m"
 * "./../mmsoda-toolbox/visualization/mmsodaMatrixOfScatter.m"
 * "./../mmsoda-toolbox/visualization/mmsodaPlotEnsemble.m"
 * "./../mmsoda-toolbox/visualization/mmsodaPlotGelmanRubin.m"
 * "./../mmsoda-toolbox/visualization/mmsodaPlotPaCo.m"
 * "./../mmsoda-toolbox/visualization/mmsodaPlotSeq.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisSequences.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisualization1.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisualization2.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisualization3.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisualization4.m"
 * "./../mmsoda-toolbox/visualization/mmsodaVisualization5.m"
 * "./../mmsoda-toolbox/enkf/mmsodaCalcEnsembleCov.m"
 * "./../mmsoda-toolbox/enkf/mmsodaCalcInnovations.m"
 * "./../mmsoda-toolbox/enkf/mmsodaCalcKalmanGain.m"
 * "./../mmsoda-toolbox/enkf/mmsodaCalcMeasErrCov.m"
 * "./../mmsoda-toolbox/enkf/mmsodaEnKF.m"
 * "./../mmsoda-toolbox/enkf/mmsodaProcessBundle.m"
 * "./../mmsoda-toolbox/enkf/mmsodaUpdateStates.m"
 * "./../mmsoda-toolbox/mo/mmsodaCalcPareto.m"
 * "./../mmsoda-toolbox/mo/mmsodaRecalcPareto.m" "-a"
 * "./../mmsoda-toolbox/mmsoda-default-settings.ini" "-v" 
 */

#include <stdio.h>
#define EXPORTING_libmmpi 1
#include "libmmpi.h"

static HMCRINSTANCE _mcr_inst = NULL;


#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_libmmpi_C_API
#define LIB_libmmpi_C_API /* No special import/export declaration */
#endif

LIB_libmmpi_C_API 
bool MW_CALL_CONV libmmpiInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream((void *)(libmmpiInitializeWithHandlers));
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV libmmpiInitialize(void)
{
  return libmmpiInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}

LIB_libmmpi_C_API 
void MW_CALL_CONV libmmpiTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_libmmpi_C_API 
void MW_CALL_CONV libmmpiPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxGetverbosity(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "getverbosity", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSetmpistuff(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "setmpistuff", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxWhoami(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "whoami", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMatlabmain(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "matlabmain", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxRunmpirankOtherFun(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "runmpirankOtherFun", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxRunmpirankOther(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "runmpirankOther", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxBcastvar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "bcastvar", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxReceivevar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "receivevar", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSendvar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "sendvar", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxCalcLikelihood(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "calcLikelihood", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxLorenz_calc(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "lorenz_calc", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxLorenzeq(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "lorenzeq", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMyviz(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "myviz", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAbortOptim(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaAbortOptim", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAllComb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaAllComb", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcCbWb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcCbWb", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcObjScore(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcObjScore", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaContinue(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaContinue", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaEvolveComplex(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaEvolveComplex", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGelmanRubin(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaGelmanRubin", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGenerateOffspring(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                             *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaGenerateOffspring", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaInitialize(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaInitialize", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsoda(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsoda", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPartComplexes(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPartComplexes", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepRejArray(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPrepRejArray", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepSeqArray(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPrepSeqArray", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaStratDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaStratDraw", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaStratRandDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaStratRandDraw", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUnifRandDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaUnifRandDraw", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestEval(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaBestEval", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestParsets(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaBestParsets", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestScore(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaBestScore", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcUncertInts(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcUncertInts", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCheckForOldResults(int nlhs, mxArray *plhs[], int nrhs, 
                                              mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCheckForOldResults", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCopyMakefile(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCopyMakefile", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaDiffStruct(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaDiffStruct", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGetPrecedingAccepted(int nlhs, mxArray *plhs[], int nrhs, 
                                                mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaGetPrecedingAccepted", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaIsColumn(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaIsColumn", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaLoadSettings(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaLoadSettings", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaOpenBrowser(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaOpenBrowser", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaOpenPdf(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaOpenPdf", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPack(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPack", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaParetoPrinciple(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaParetoPrinciple", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaParsePairs(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaParsePairs", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrctile(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPrctile", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepParallelFiles(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                             *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPrepParallelFiles", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPurgeResults(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPurgeResults", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaRetrieveEnsembleData(int nlhs, mxArray *plhs[], int nrhs, 
                                                mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaRetrieveEnsembleData", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaroot(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaroot", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaSaveConf(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaSaveConf", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaSubplotScreen(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaSubplotScreen", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUnpack(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaUnpack", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVerifyFieldNames(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                            *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVerifyFieldNames", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaWriteJobscript(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaWriteJobscript", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSubaxes(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "subaxes", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxUimatlab(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "uimatlab", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxUioctave(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "uioctave", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAnalyzeTimings(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaAnalyzeTimings", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMakeColors(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaMakeColors", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMargHist(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaMargHist", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMatrixOfScatter(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaMatrixOfScatter", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotEnsemble(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPlotEnsemble", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotGelmanRubin(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPlotGelmanRubin", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotPaCo(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPlotPaCo", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotSeq(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaPlotSeq", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisSequences(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisSequences", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization1(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisualization1", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization2(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisualization2", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization3(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisualization3", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization4(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisualization4", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization5(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaVisualization5", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcEnsembleCov(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcEnsembleCov", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcInnovations(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcInnovations", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcKalmanGain(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcKalmanGain", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcMeasErrCov(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcMeasErrCov", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaEnKF(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaEnKF", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaProcessBundle(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaProcessBundle", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUpdateStates(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaUpdateStates", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcPareto(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaCalcPareto", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaRecalcPareto(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "mmsodaRecalcPareto", nlhs, plhs, nrhs, prhs);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfGetverbosity()
{
  return mclMlfFeval(_mcr_inst, "getverbosity", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfSetmpistuff(mxArray* mpisize, mxArray* mpirank)
{
  return mclMlfFeval(_mcr_inst, "setmpistuff", 0, 0, 2, mpisize, mpirank);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfWhoami()
{
  return mclMlfFeval(_mcr_inst, "whoami", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMatlabmain(mxArray* verbosity, mxArray* savetimings)
{
  return mclMlfFeval(_mcr_inst, "matlabmain", 0, 0, 2, verbosity, savetimings);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfRunmpirankOtherFun(int nargout, mxArray** bundle, mxArray* conf, 
                                        mxArray* msg)
{
  return mclMlfFeval(_mcr_inst, "runmpirankOtherFun", nargout, 1, 2, bundle, conf, msg);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfRunmpirankOther()
{
  return mclMlfFeval(_mcr_inst, "runmpirankOther", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfBcastvar(int nargout, mxArray** varargout, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "bcastvar", nargout, -1, -1, varargout, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfReceivevar(int nargout, mxArray** varargout, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "receivevar", nargout, -1, -1, varargout, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfSendvar(int nargout, mxArray** varargout, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "sendvar", nargout, -1, -1, varargout, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfCalcLikelihood(int nargout, mxArray** objScore, mxArray* conf, 
                                    mxArray* constants, mxArray* modelOutput, mxArray* 
                                    parVec)
{
  return mclMlfFeval(_mcr_inst, "calcLikelihood", nargout, 1, 4, objScore, conf, constants, modelOutput, parVec);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfLorenz_calc(int nargout, mxArray** uprime, mxArray* t, mxArray* u, 
                                 mxArray* flag, mxArray* parVec)
{
  return mclMlfFeval(_mcr_inst, "lorenz_calc", nargout, 1, 4, uprime, t, u, flag, parVec);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfLorenzeq(int nargout, mxArray** modelOutput, mxArray* conf, mxArray* 
                              constants, mxArray* init, mxArray* parVec, mxArray* 
                              priorTimes)
{
  return mclMlfFeval(_mcr_inst, "lorenzeq", nargout, 1, 5, modelOutput, conf, constants, init, parVec, priorTimes);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMyviz()
{
  return mclMlfFeval(_mcr_inst, "myviz", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaAbortOptim(int nargout, mxArray** converged, mxArray* 
                                      critGelRub, mxArray* conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaAbortOptim", nargout, 1, 2, converged, critGelRub, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaAllComb(int nargout, mxArray** A, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaAllComb", nargout, 1, -1, A, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcCbWb(int nargout, mxArray** Cb, mxArray** Wb, mxArray* 
                                    conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcCbWb", nargout, 2, 1, Cb, Wb, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcObjScore(int nargout, mxArray** varargout, mxArray* conf, 
                                        mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcObjScore", nargout, -1, -2, varargout, conf, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaContinue(int nargout, mxArray** runCondition, mxArray* conf, 
                                    mxArray* nModelEvals)
{
  return mclMlfFeval(_mcr_inst, "mmsodaContinue", nargout, 1, 2, runCondition, conf, nModelEvals);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaEvolveComplex(int nargout, mxArray** curCompl, mxArray** 
                                         acceptedChild, mxArray* conf, mxArray* 
                                         curCompl_in1, mxArray* curSeq, mxArray* 
                                         propChild)
{
  return mclMlfFeval(_mcr_inst, "mmsodaEvolveComplex", nargout, 2, 4, curCompl, acceptedChild, conf, curCompl_in1, curSeq, propChild);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaGelmanRubin(int nargout, mxArray** rHatRoot, mxArray* conf, 
                                       mxArray* sequences)
{
  return mclMlfFeval(_mcr_inst, "mmsodaGelmanRubin", nargout, 1, 2, rHatRoot, conf, sequences);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaGenerateOffspring(int nargout, mxArray** propChild, mxArray* 
                                             conf, mxArray* curCompl, mxArray* curSeq, 
                                             mxArray* iGeneration)
{
  return mclMlfFeval(_mcr_inst, "mmsodaGenerateOffspring", nargout, 1, 4, propChild, conf, curCompl, curSeq, iGeneration);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaInitialize(int nargout, mxArray** varargout, mxArray* 
                                      mmsodaOptions)
{
  return mclMlfFeval(_mcr_inst, "mmsodaInitialize", nargout, -1, 1, varargout, mmsodaOptions);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsoda(int nargout, mxArray** varargout, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsoda", nargout, -1, -1, varargout, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPartComplexes(int nargout, mxArray** complexes, mxArray* conf, 
                                         mxArray* evalResults)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPartComplexes", nargout, 1, 2, complexes, conf, evalResults);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPrepRejArray(int nargout, mxArray** metropolisRejects, 
                                        mxArray* conf, mxArray* metropolisRejects_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPrepRejArray", nargout, 1, 2, metropolisRejects, conf, metropolisRejects_in1);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPrepSeqArray(int nargout, mxArray** sequences, mxArray* conf, 
                                        mxArray* sequences_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPrepSeqArray", nargout, 1, 2, sequences, conf, sequences_in1);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaStratDraw(int nargout, mxArray** sDraw, mxArray* conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaStratDraw", nargout, 1, 1, sDraw, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaStratRandDraw(int nargout, mxArray** sDraw, mxArray* conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaStratRandDraw", nargout, 1, 1, sDraw, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaUnifRandDraw(int nargout, mxArray** uDraw, mxArray* conf, 
                                        mxArray* drawMode)
{
  return mclMlfFeval(_mcr_inst, "mmsodaUnifRandDraw", nargout, 1, 2, uDraw, conf, drawMode);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaBestEval(int nargout, mxArray** varargout, mxArray* conf, 
                                    mxArray* evalResults)
{
  return mclMlfFeval(_mcr_inst, "mmsodaBestEval", nargout, -1, 2, varargout, conf, evalResults);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaBestParsets(int nargout, mxArray** bestParsets, mxArray* conf, 
                                       mxArray* evalResults, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaBestParsets", nargout, 1, -3, bestParsets, conf, evalResults, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaBestScore(int nargout, mxArray** bestScore, mxArray* conf, 
                                     mxArray* evalResults)
{
  return mclMlfFeval(_mcr_inst, "mmsodaBestScore", nargout, 1, 2, bestScore, conf, evalResults);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcUncertInts(int nargout, mxArray** varargout, mxArray* 
                                          conf, mxArray* evalResults, mxArray* 
                                          metropolisRejects, mxArray* prc, mxArray* 
                                          evalNumbers, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcUncertInts", nargout, -1, -6, varargout, conf, evalResults, metropolisRejects, prc, evalNumbers, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCheckForOldResults(mxArray* conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCheckForOldResults", 0, 0, 1, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCopyMakefile()
{
  return mclMlfFeval(_mcr_inst, "mmsodaCopyMakefile", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaDiffStruct(int nargout, mxArray** structdiff, mxArray* 
                                      struct1, mxArray* struct2, mxArray* ignoreFields)
{
  return mclMlfFeval(_mcr_inst, "mmsodaDiffStruct", nargout, 1, 3, structdiff, struct1, struct2, ignoreFields);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaGetPrecedingAccepted(int nargout, mxArray** iEvalOut, mxArray* 
                                                conf, mxArray* metropolisRejects, 
                                                mxArray* iEvalIn)
{
  return mclMlfFeval(_mcr_inst, "mmsodaGetPrecedingAccepted", nargout, 1, 3, iEvalOut, conf, metropolisRejects, iEvalIn);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaIsColumn(int nargout, mxArray** r, mxArray* v)
{
  return mclMlfFeval(_mcr_inst, "mmsodaIsColumn", nargout, 1, 1, r, v);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaLoadSettings(int nargout, mxArray** conf, mxArray* conf_in1, 
                                        mxArray* f)
{
  return mclMlfFeval(_mcr_inst, "mmsodaLoadSettings", nargout, 1, 2, conf, conf_in1, f);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaOpenBrowser(mxArray* url)
{
  return mclMlfFeval(_mcr_inst, "mmsodaOpenBrowser", 0, 0, 1, url);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaOpenPdf(mxArray* url)
{
  return mclMlfFeval(_mcr_inst, "mmsodaOpenPdf", 0, 0, 1, url);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPack()
{
  return mclMlfFeval(_mcr_inst, "mmsodaPack", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaParetoPrinciple()
{
  return mclMlfFeval(_mcr_inst, "mmsodaParetoPrinciple", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaParsePairs()
{
  return mclMlfFeval(_mcr_inst, "mmsodaParsePairs", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPrctile(int nargout, mxArray** OUT0, mxArray* IN, mxArray* prc)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPrctile", nargout, 1, 2, OUT0, IN, prc);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPrepParallelFiles()
{
  return mclMlfFeval(_mcr_inst, "mmsodaPrepParallelFiles", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPurgeResults()
{
  return mclMlfFeval(_mcr_inst, "mmsodaPurgeResults", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaRetrieveEnsembleData(int nargout, mxArray** 
                                                stateValuesKFPrior, mxArray** 
                                                stateValuesKFPert, mxArray** 
                                                stateValuesKFPost, mxArray** 
                                                obsPerturbed, mxArray* conf, mxArray* 
                                                evalNumbers)
{
  return mclMlfFeval(_mcr_inst, "mmsodaRetrieveEnsembleData", nargout, 4, 2, stateValuesKFPrior, stateValuesKFPert, stateValuesKFPost, obsPerturbed, conf, evalNumbers);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaroot(int nargout, mxArray** s)
{
  return mclMlfFeval(_mcr_inst, "mmsodaroot", nargout, 1, 0, s);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaSaveConf()
{
  return mclMlfFeval(_mcr_inst, "mmsodaSaveConf", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaSubplotScreen(int nargout, mxArray** varargout, mxArray* 
                                         nRows, mxArray* nCols, mxArray* figIndex, 
                                         mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaSubplotScreen", nargout, -1, -4, varargout, nRows, nCols, figIndex, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaUnpack()
{
  return mclMlfFeval(_mcr_inst, "mmsodaUnpack", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVerifyFieldNames(int nargout, mxArray** varargout, mxArray* 
                                            conf, mxArray* modeStr)
{
  return mclMlfFeval(_mcr_inst, "mmsodaVerifyFieldNames", nargout, -1, 2, varargout, conf, modeStr);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaWriteJobscript()
{
  return mclMlfFeval(_mcr_inst, "mmsodaWriteJobscript", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfSubaxes(mxArray* nRows, mxArray* nCols, mxArray* axesNumber, 
                             mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "subaxes", 0, 0, -4, nRows, nCols, axesNumber, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfUimatlab(int nargout, mxArray** uiIsMatLab)
{
  return mclMlfFeval(_mcr_inst, "uimatlab", nargout, 1, 0, uiIsMatLab);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfUioctave(int nargout, mxArray** uiIsOctave)
{
  return mclMlfFeval(_mcr_inst, "uioctave", nargout, 1, 0, uiIsOctave);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaAnalyzeTimings(mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaAnalyzeTimings", 0, 0, -1, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaMakeColors(int nargout, mxArray** colorList, mxArray* conf)
{
  return mclMlfFeval(_mcr_inst, "mmsodaMakeColors", nargout, 1, 1, colorList, conf);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaMargHist(int nargout, mxArray** varargout, mxArray* conf, 
                                    mxArray* evalResults, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaMargHist", nargout, -1, -3, varargout, conf, evalResults, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaMatrixOfScatter(int nargout, mxArray** varargout, mxArray* 
                                           conf, mxArray* typeStr, mxArray* sequences, 
                                           mxArray* metropolisRejects, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaMatrixOfScatter", nargout, -1, -5, varargout, conf, typeStr, sequences, metropolisRejects, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPlotEnsemble(int nargout, mxArray** varargout, mxArray* conf, 
                                        mxArray* evalResults, mxArray* metropolisRejects, 
                                        mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPlotEnsemble", nargout, -1, -4, varargout, conf, evalResults, metropolisRejects, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPlotGelmanRubin(mxArray* conf, mxArray* critGelRub, mxArray* 
                                           varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPlotGelmanRubin", 0, 0, -3, conf, critGelRub, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPlotPaCo(int nargout, mxArray** varargout, mxArray* conf, 
                                    mxArray* evalResults, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPlotPaCo", nargout, -1, -3, varargout, conf, evalResults, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaPlotSeq(int nargout, mxArray** varargout, mxArray* conf, 
                                   mxArray* sequences, mxArray* metropolisRejects, 
                                   mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaPlotSeq", nargout, -1, -4, varargout, conf, sequences, metropolisRejects, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisSequences(mxArray* conf, mxArray* sequences, mxArray* 
                                        metropolisRejects)
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisSequences", 0, 0, 3, conf, sequences, metropolisRejects);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisualization1()
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisualization1", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisualization2()
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisualization2", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisualization3()
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisualization3", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisualization4()
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisualization4", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaVisualization5()
{
  return mclMlfFeval(_mcr_inst, "mmsodaVisualization5", 0, 0, 0);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcEnsembleCov(int nargout, mxArray** ensembleCov, mxArray* 
                                           stateValuesKFPert, mxArray* iDAStep)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcEnsembleCov", nargout, 1, 2, ensembleCov, stateValuesKFPert, iDAStep);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcInnovations(int nargout, mxArray** stateValuesKFInn, 
                                           mxArray* kalmanGain, mxArray* obsPerturbed, 
                                           mxArray* measOperator, mxArray* 
                                           stateValuesKFPert, mxArray* 
                                           stateValuesKFInn_in1, mxArray* iDAStep)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcInnovations", nargout, 1, 6, stateValuesKFInn, kalmanGain, obsPerturbed, measOperator, stateValuesKFPert, stateValuesKFInn_in1, iDAStep);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcKalmanGain(int nargout, mxArray** kalmanGain, mxArray* 
                                          ensembleCov, mxArray* measErrCov, mxArray* 
                                          measOperator, mxArray* kalmanGain_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcKalmanGain", nargout, 1, 4, kalmanGain, ensembleCov, measErrCov, measOperator, kalmanGain_in1);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcMeasErrCov(int nargout, mxArray** measErrCov, mxArray* 
                                          obsPerturbed, mxArray* iDAStep)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcMeasErrCov", nargout, 1, 2, measErrCov, obsPerturbed, iDAStep);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaEnKF(int nargout, mxArray** parsets, mxArray* conf, mxArray* 
                                parsets_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaEnKF", nargout, 1, 2, parsets, conf, parsets_in1);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaProcessBundle(int nargout, mxArray** bundle, mxArray* conf, 
                                         mxArray* constants, mxArray* bundle_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaProcessBundle", nargout, 1, 3, bundle, conf, constants, bundle_in1);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaUpdateStates(int nargout, mxArray** stateValuesKFPost, 
                                        mxArray* conf, mxArray* stateValuesKFPert, 
                                        mxArray* stateValuesKFPost_in1, mxArray* 
                                        stateValuesKFInn, mxArray* iDAStep)
{
  return mclMlfFeval(_mcr_inst, "mmsodaUpdateStates", nargout, 1, 5, stateValuesKFPost, conf, stateValuesKFPert, stateValuesKFPost_in1, stateValuesKFInn, iDAStep);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaCalcPareto(int nargout, mxArray** paretoScores, mxArray* 
                                      objScores, mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "mmsodaCalcPareto", nargout, 1, -2, paretoScores, objScores, varargin);
}

LIB_libmmpi_C_API 
bool MW_CALL_CONV mlfMmsodaRecalcPareto(int nargout, mxArray** sequences, mxArray** 
                                        complexes, mxArray** propChildren, mxArray* conf, 
                                        mxArray* sequences_in1, mxArray* complexes_in1, 
                                        mxArray* propChildren_in1)
{
  return mclMlfFeval(_mcr_inst, "mmsodaRecalcPareto", nargout, 3, 4, sequences, complexes, propChildren, conf, sequences_in1, complexes_in1, propChildren_in1);
}

