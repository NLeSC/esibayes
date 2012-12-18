MPIINCLUDE=/usr/lib/openmpi/include
MFILES=setmpistuff.m whoami.m
PMFILES=$(addprefix ./../mmsoda/mmlib/,$(MFILES))
MEXFILES=mm_send.mexa64 mm_receive.mexa64 mm_bcast.mexa64
PMEXFILES=$(addprefix ./../mmsoda/mmtools/,$(MEXFILES))
USERMODELFILES=model/*.m
MMSODAMFILES=./../mmsoda/*.m ./../mmsoda/tools/*.m ./../mmsoda/visualization/*.m ./../mmsoda/enkf/*.m  ./../mmsoda/mo/*.m
MMSODAOTHERFILES=-a ./../mmsoda/soda-default-settings.ini
VERBOSITY=-v
#VERBOSITY=


all: lib matlabprog

./../mmsoda/mmtools/%.mexa64: ./../mmsoda/mmtools/%.c
	mex -I$(MPIINCLUDE) -lmpi $(VERBOSITY) -o $@ $<

lib: *.m $(PMFILES) $(PMEXFILES)
	mcc -B csharedlib:libmmpi *.m $(PMFILES) $(PMEXFILES) $(USERMODELFILES) $(MMSODAMFILES) $(MMSODAOTHERFILES) $(VERBOSITY)
	mv mccExcludedFiles.log readme.txt libmmpi.* ./../mmsoda/mmlib

matlabprog: lib
	mbuild -output matlabprog ./../mmsoda/mmlib/matlabmpi.c -L./../mmsoda/mmlib -I./../mmsoda/mmlib -I$(MPIINCLUDE) -lmmpi -lmpi

clean:
	rm -f matlabprog ./../mmsoda/mmlib/libmmpi.* ./../mmsoda/mmlib/mccExcludedFiles.log ./../mmsoda/mmlib/readme.txt ./../mmsoda/mmtools/*.mexa64

purge:
	rm -f results/*
	rm -f data/*

rmhostfile:
	#if [ -z "$ PBS_ENVIRONMENT"]; then
	rm ${TMPDIR}/myhostfile
	#else
		#echo "I'm not on any of the batch nodes right now."
	#fi


