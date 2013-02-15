
#Use this script interactively on one of the login nodes by typing ./run-mmsoda.sh at the LISA prompt.


echo "Unloading module matlab"
module unload matlab
echo

echo "Loading module openmpi/gnu"
module load openmpi/gnu
echo

echo "Loading module mcr"
module load mcr
echo

echo "Starting MPI job on node "`hostname`
ncpus=`cat /proc/cpuinfo | grep processor | wc -l`
((nprocs=5))
echo

echo "I detected that "`hostname`" has "$ncpus" processors. I'll start "$nprocs" processes."
echo

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

echo "Result of 'ldd matlabprog' is:"
ldd matlabprog
echo

echo "Result of 'ldd libmmpi.so' is:"
ldd libmmpi.so
echo

echo "The current LD_LIBRARY_PATH is:"
echo $LD_LIBRARY_PATH
echo

module list

mcrFolderName=`mktemp -d /scratch/mmsoda-XXXXXXXX`
echo "Setting MCR_CACHE_ROOT to: $mcrFolderName"
export MCR_CACHE_ROOT=$mcrFolderName
echo

echo "The current MCR_CACHE_ROOT is:"
echo $MCR_CACHE_ROOT
echo

echo "Starting MPI run"
echo

mpirun -n $nprocs ./matlabprog -v 0 -t
