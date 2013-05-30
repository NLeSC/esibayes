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

#ifndef __libmmpi_h
#define __libmmpi_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_libmmpi
#define PUBLIC_libmmpi_C_API __global
#else
#define PUBLIC_libmmpi_C_API /* No import statement needed. */
#endif

#define LIB_libmmpi_C_API PUBLIC_libmmpi_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_libmmpi
#define PUBLIC_libmmpi_C_API __declspec(dllexport)
#else
#define PUBLIC_libmmpi_C_API __declspec(dllimport)
#endif

#define LIB_libmmpi_C_API PUBLIC_libmmpi_C_API


#else

#define LIB_libmmpi_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_libmmpi_C_API 
#define LIB_libmmpi_C_API /* No special import/export declaration */
#endif

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV libmmpiInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV libmmpiInitialize(void);

extern LIB_libmmpi_C_API 
void MW_CALL_CONV libmmpiTerminate(void);



extern LIB_libmmpi_C_API 
void MW_CALL_CONV libmmpiPrintStackTrace(void);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxGetverbosity(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSetmpistuff(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxWhoami(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMatlabmain(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxRunmpirankOtherFun(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxRunmpirankOther(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxBcastvar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxReceivevar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSendvar(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxCalcLikelihood(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxLorenz_calc(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxLorenzeq(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMyviz(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAbortOptim(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAllComb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcCbWb(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcObjScore(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaContinue(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaEvolveComplex(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGelmanRubin(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGenerateOffspring(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                             *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaInitialize(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsoda(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPartComplexes(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepRejArray(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepSeqArray(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaStratDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaStratRandDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUnifRandDraw(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestEval(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestParsets(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaBestScore(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                     *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcUncertInts(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCheckForOldResults(int nlhs, mxArray *plhs[], int nrhs, 
                                              mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCopyMakefile(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaDiffStruct(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaGetPrecedingAccepted(int nlhs, mxArray *plhs[], int nrhs, 
                                                mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaIsColumn(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaLoadSettings(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaOpenBrowser(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaOpenPdf(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPack(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaParetoPrinciple(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaParsePairs(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrctile(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPrepParallelFiles(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                             *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPurgeResults(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaRetrieveEnsembleData(int nlhs, mxArray *plhs[], int nrhs, 
                                                mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaroot(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaSaveConf(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaSubplotScreen(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUnpack(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVerifyFieldNames(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                            *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaWriteJobscript(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxSubaxes(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxUimatlab(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxUioctave(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaAnalyzeTimings(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMakeColors(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMargHist(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaMatrixOfScatter(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotEnsemble(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotGelmanRubin(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotPaCo(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaPlotSeq(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisSequences(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization1(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization2(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization3(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization4(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaVisualization5(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcEnsembleCov(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcInnovations(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                           *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcKalmanGain(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcMeasErrCov(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaEnKF(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaProcessBundle(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaUpdateStates(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaCalcPareto(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_libmmpi_C_API 
bool MW_CALL_CONV mlxMmsodaRecalcPareto(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);



extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfGetverbosity();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfSetmpistuff(mxArray* mpisize, mxArray* mpirank);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfWhoami();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMatlabmain(mxArray* verbosity, mxArray* savetimings);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfRunmpirankOtherFun(int nargout, mxArray** bundle, mxArray* conf, mxArray* msg);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfRunmpirankOther();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfBcastvar(int nargout, mxArray** varargout, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfReceivevar(int nargout, mxArray** varargout, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfSendvar(int nargout, mxArray** varargout, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfCalcLikelihood(int nargout, mxArray** objScore, mxArray* conf, mxArray* constants, mxArray* modelOutput, mxArray* parVec);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfLorenz_calc(int nargout, mxArray** uprime, mxArray* t, mxArray* u, mxArray* flag, mxArray* parVec);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfLorenzeq(int nargout, mxArray** modelOutput, mxArray* conf, mxArray* constants, mxArray* init, mxArray* parVec, mxArray* priorTimes);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMyviz();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaAbortOptim(int nargout, mxArray** converged, mxArray* critGelRub, mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaAllComb(int nargout, mxArray** A, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcCbWb(int nargout, mxArray** Cb, mxArray** Wb, mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcObjScore(int nargout, mxArray** varargout, mxArray* conf, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaContinue(int nargout, mxArray** runCondition, mxArray* conf, mxArray* nModelEvals);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaEvolveComplex(int nargout, mxArray** curCompl, mxArray** acceptedChild, mxArray* conf, mxArray* curCompl_in1, mxArray* curSeq, mxArray* propChild);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaGelmanRubin(int nargout, mxArray** rHatRoot, mxArray* conf, mxArray* sequences);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaGenerateOffspring(int nargout, mxArray** propChild, mxArray* conf, mxArray* curCompl, mxArray* curSeq, mxArray* iGeneration);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaInitialize(int nargout, mxArray** varargout, mxArray* mmsodaOptions);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsoda(int nargout, mxArray** varargout, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPartComplexes(int nargout, mxArray** complexes, mxArray* conf, mxArray* evalResults);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPrepRejArray(int nargout, mxArray** metropolisRejects, mxArray* conf, mxArray* metropolisRejects_in1);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPrepSeqArray(int nargout, mxArray** sequences, mxArray* conf, mxArray* sequences_in1);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaStratDraw(int nargout, mxArray** sDraw, mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaStratRandDraw(int nargout, mxArray** sDraw, mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaUnifRandDraw(int nargout, mxArray** uDraw, mxArray* conf, mxArray* drawMode);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaBestEval(int nargout, mxArray** varargout, mxArray* conf, mxArray* evalResults);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaBestParsets(int nargout, mxArray** bestParsets, mxArray* conf, mxArray* evalResults, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaBestScore(int nargout, mxArray** bestScore, mxArray* conf, mxArray* evalResults);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcUncertInts(int nargout, mxArray** varargout, mxArray* conf, mxArray* evalResults, mxArray* metropolisRejects, mxArray* prc, mxArray* evalNumbers, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCheckForOldResults(mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCopyMakefile();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaDiffStruct(int nargout, mxArray** structdiff, mxArray* struct1, mxArray* struct2, mxArray* ignoreFields);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaGetPrecedingAccepted(int nargout, mxArray** iEvalOut, mxArray* conf, mxArray* metropolisRejects, mxArray* iEvalIn);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaIsColumn(int nargout, mxArray** r, mxArray* v);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaLoadSettings(int nargout, mxArray** conf, mxArray* conf_in1, mxArray* f);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaOpenBrowser(mxArray* url);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaOpenPdf(mxArray* url);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPack();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaParetoPrinciple();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaParsePairs();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPrctile(int nargout, mxArray** OUT0, mxArray* IN, mxArray* prc);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPrepParallelFiles();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPurgeResults();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaRetrieveEnsembleData(int nargout, mxArray** stateValuesKFPrior, mxArray** stateValuesKFPert, mxArray** stateValuesKFPost, mxArray** obsPerturbed, mxArray* conf, mxArray* evalNumbers);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaroot(int nargout, mxArray** s);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaSaveConf();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaSubplotScreen(int nargout, mxArray** varargout, mxArray* nRows, mxArray* nCols, mxArray* figIndex, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaUnpack();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVerifyFieldNames(int nargout, mxArray** varargout, mxArray* conf, mxArray* modeStr);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaWriteJobscript();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfSubaxes(mxArray* nRows, mxArray* nCols, mxArray* axesNumber, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfUimatlab(int nargout, mxArray** uiIsMatLab);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfUioctave(int nargout, mxArray** uiIsOctave);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaAnalyzeTimings(mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaMakeColors(int nargout, mxArray** colorList, mxArray* conf);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaMargHist(int nargout, mxArray** varargout, mxArray* conf, mxArray* evalResults, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaMatrixOfScatter(int nargout, mxArray** varargout, mxArray* conf, mxArray* typeStr, mxArray* sequences, mxArray* metropolisRejects, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPlotEnsemble(int nargout, mxArray** varargout, mxArray* conf, mxArray* evalResults, mxArray* metropolisRejects, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPlotGelmanRubin(mxArray* conf, mxArray* critGelRub, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPlotPaCo(int nargout, mxArray** varargout, mxArray* conf, mxArray* evalResults, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaPlotSeq(int nargout, mxArray** varargout, mxArray* conf, mxArray* sequences, mxArray* metropolisRejects, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisSequences(mxArray* conf, mxArray* sequences, mxArray* metropolisRejects);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisualization1();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisualization2();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisualization3();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisualization4();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaVisualization5();

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcEnsembleCov(int nargout, mxArray** ensembleCov, mxArray* stateValuesKFPert, mxArray* iDAStep);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcInnovations(int nargout, mxArray** stateValuesKFInn, mxArray* kalmanGain, mxArray* obsPerturbed, mxArray* measOperator, mxArray* stateValuesKFPert, mxArray* stateValuesKFInn_in1, mxArray* iDAStep);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcKalmanGain(int nargout, mxArray** kalmanGain, mxArray* ensembleCov, mxArray* measErrCov, mxArray* measOperator, mxArray* kalmanGain_in1);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcMeasErrCov(int nargout, mxArray** measErrCov, mxArray* obsPerturbed, mxArray* iDAStep);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaEnKF(int nargout, mxArray** parsets, mxArray* conf, mxArray* parsets_in1);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaProcessBundle(int nargout, mxArray** bundle, mxArray* conf, mxArray* constants, mxArray* bundle_in1);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaUpdateStates(int nargout, mxArray** stateValuesKFPost, mxArray* conf, mxArray* stateValuesKFPert, mxArray* stateValuesKFPost_in1, mxArray* stateValuesKFInn, mxArray* iDAStep);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaCalcPareto(int nargout, mxArray** paretoScores, mxArray* objScores, mxArray* varargin);

extern LIB_libmmpi_C_API bool MW_CALL_CONV mlfMmsodaRecalcPareto(int nargout, mxArray** sequences, mxArray** complexes, mxArray** propChildren, mxArray* conf, mxArray* sequences_in1, mxArray* complexes_in1, mxArray* propChildren_in1);

#ifdef __cplusplus
}
#endif
#endif
