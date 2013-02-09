
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

if [ -d "$TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ" ]; then
    echo "Directory "$TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ" already exists...emptying contents."
    rm -rf "$TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ"
    echo
fi
echo "Making directory: $TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ"
mkdir "$TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ"
echo

echo "Setting MCR_CACHE_ROOT to: $TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ"
export MCR_CACHE_ROOT="$TMPDIR/mmsoda_L6H4-ZNTT-ZSE1-O8KJ"
echo

echo "The current MCR_CACHE_ROOT is:"
echo $MCR_CACHE_ROOT
echo

echo "Starting MPI run"
echo

mpirun -n $nprocs ./matlabprog -v 0 -b 500000 -t
