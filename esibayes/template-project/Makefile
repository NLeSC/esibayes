MPIINCLUDE=/sara/sw/openmpi-gnu-1.6.3/include
MFILES=./../mmsoda/comms/*.m ./../mmsoda/mmlib/*.m
MEXFILES=./../mmsoda/comms/mm_bcast.mexa64 ./../mmsoda/comms/mm_receive.mexa64 ./../mmsoda/comms/mm_send.mexa64
USERMODELFILES=model/*.m
MMSODAMFILES=./../mmsoda/*.m ./../mmsoda/tools/*.m ./../mmsoda/visualization/*.m ./../mmsoda/enkf/*.m  ./../mmsoda/mo/*.m
MMSODAOTHERFILES=-a ./../mmsoda/soda-default-settings.ini
VERBOSITY=-v
#VERBOSITY=


all: lib matlabprog

./../mmsoda/comms/%.mexa64: ./../mmsoda/comms/%.c
	mex -I$(MPIINCLUDE) -lmpi $(VERBOSITY) -o $@ $<

lib: $(MFILES) $(MEXFILES)
	mcc -B csharedlib:libmmpi $(MFILES) $(MEXFILES) $(USERMODELFILES) $(MMSODAMFILES) $(MMSODAOTHERFILES) $(VERBOSITY)

matlabprog: lib
	mbuild -output matlabprog ./../mmsoda/comms/matlabmpi.c -L. -I. -I$(MPIINCLUDE) -lmmpi -lmpi $(VERBOSITY)
	# move some files to mmsoda/mmlib to avoid cluttering the user's dir.
	mv libmmpi.c ./../mmsoda/mmlib/
	mv libmmpi.exports ./../mmsoda/mmlib/
	mv libmmpi.h ./../mmsoda/mmlib/
	mv mccExcludedFiles.log ./../mmsoda/mmlib/
	mv readme.txt ./../mmsoda/mmlib/

clean:
	rm -f matlabprog libmmpi.* mccExcludedFiles.log readme.txt ./../mmsoda/comms/*.mexa64

purge:
	rm -f results/*-results-*

rmhostfile:
	#if [ -z "$ PBS_ENVIRONMENT"]; then
	rm ${TMPDIR}/myhostfile
	#else
		#echo "I'm not on any of the batch nodes right now."
	#fi


