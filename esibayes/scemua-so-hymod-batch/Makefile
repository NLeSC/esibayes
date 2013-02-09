MPIINCLUDE=/sara/sw/openmpi-gnu-1.6.3/include
MFILES=./../mmsoda-toolbox/comms/*.m ./../mmsoda-toolbox/mmlib/*.m
MEXFILES=./../mmsoda-toolbox/comms/mm_bcast.mexa64 ./../mmsoda-toolbox/comms/mm_receive.mexa64 ./../mmsoda-toolbox/comms/mm_send.mexa64
USERMODELFILES=model/*.m
MMSODAMFILES=./../mmsoda-toolbox/*.m ./../mmsoda-toolbox/tools/*.m ./../mmsoda-toolbox/visualization/*.m ./../mmsoda-toolbox/enkf/*.m  ./../mmsoda-toolbox/mo/*.m
MMSODAOTHERFILES=-a ./../mmsoda-toolbox/mmsoda-default-settings.ini
VERBOSITY=-v
#VERBOSITY=


all: lib matlabprog

./../mmsoda-toolbox/comms/%.mexa64: ./../mmsoda-toolbox/comms/%.c
	mex -I$(MPIINCLUDE) -lmpi $(VERBOSITY) -o $@ $<

lib: $(MFILES) $(MEXFILES)
	mcc -B csharedlib:libmmpi $(MFILES) $(MEXFILES) $(USERMODELFILES) $(MMSODAMFILES) $(MMSODAOTHERFILES) $(VERBOSITY)

matlabprog: lib
	mbuild -output matlabprog ./../mmsoda-toolbox/comms/matlabmpi.c -L. -I. -I$(MPIINCLUDE) -lmmpi -lmpi $(VERBOSITY)
	# move some files to mmsoda-toolbox/mmlib to avoid cluttering the user's dir.
	mv libmmpi.c ./../mmsoda-toolbox/mmlib/
	mv libmmpi.exports ./../mmsoda-toolbox/mmlib/
	mv libmmpi.h ./../mmsoda-toolbox/mmlib/
	mv mccExcludedFiles.log ./../mmsoda-toolbox/mmlib/
	mv readme.txt ./../mmsoda-toolbox/mmlib/

clean:
	rm -f matlabprog libmmpi.* mccExcludedFiles.log readme.txt ./../mmsoda-toolbox/comms/*.mexa64

purge:
	rm -f results/*-results*
	rm -f results/*.pbs.*
	rm -f results/conf-out.mat
	rm -f results/timing_???.mat

rmhostfile:
	#if [ -z "$ PBS_ENVIRONMENT"]; then
	rm ${TMPDIR}/myhostfile
	#else
		#echo "I'm not on any of the batch nodes right now."
	#fi


