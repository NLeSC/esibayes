
#Use this script interactively on one of the login nodes by typing ./run-mmsoda.sh at the LISA prompt.


echo "unloading module matlab"
module unload matlab
echo "loading module openmpi/gnu"
module load openmpi/gnu
echo "loading module mcr"
module load mcr
echo "Starting MPI job on node "`hostname`
ncpus=`cat /proc/cpuinfo | grep processor | wc -l`
((nprocs=3))
echo "I detected that "`hostname`" has "$ncpus" processors. I'll start "$nprocs" processes."
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
echo "making directory:$TMPDIR/mmsoda_ZDST-5ROY-0SMF-VJB1"
mkdir $TMPDIR/mmsoda_ZDST-5ROY-0SMF-VJB1
echo "setting MCR_CACHE_ROOT to:$TMPDIR/mmsoda_ZDST-5ROY-0SMF-VJB1"
export MCR_CACHE_ROOT=$TMPDIR/mmsoda_ZDST-5ROY-0SMF-VJB1
mpirun -n $nprocs ./matlabprog -v 0 -b 500000000 -t
