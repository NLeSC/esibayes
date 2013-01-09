#!/bin/bash
#
#PBS -lwalltime=00:10:00
#PBS -lnodes=1
#PBS -o results/
#PBS -e results/


mode=1
case $mode in

1)
    ## interactive on one of the login nodes
    echo "unloading module matlab"
    module unload matlab
    echo "loading module openmpi/gnu"
    module load openmpi/gnu/
    echo "loading module mcr"
    module load mcr
    echo "Starting MPI job on node "`hostname`
    ncpus=`cat /proc/cpuinfo | grep processor | wc -l`
    nprocs=8
    echo "I detected that "`hostname`" has "$ncpus" processors, but I'll start only "$nprocs" processes to keep the sysadmins happy."
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
    date
    mpirun -n $nprocs ./matlabprog -v 0
    date
    ;;
2)
    ## interactive on one batch node
    ##
    ## ask for an interactive session by e.g.
    ## qsub -I -lnodes=1 -lwalltime=00:30:00
    echo "unloading module matlab/64"
    module unload matlab/64
    echo "loading module openmpi/gnu/64"
    module load openmpi/gnu/64
    echo "loading module mcr"
    module load mcr/64
    echo "Starting MPI job on node "`hostname`
    ncpus=`cat /proc/cpuinfo | grep processor | wc -l`
    ((nprocs=$ncpus))
    echo "I detected that "`hostname`" has "$ncpus" processors. I'll start "$nprocs" processes."
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
    mpirun -n $nprocs ./matlabprog
    ;;
3)
    ## interactive on multiple batch nodes
    ##
    ## ask for an interactive session by e.g.
    ## qsub -I -lnodes=2 -lwalltime=00:30:00
    echo "unloading module matlab/64"
    module unload matlab/64
    echo "loading module openmpi/gnu/64"
    module load openmpi/gnu/64
    echo "loading module mcr"
    module load mcr/64
    echo "Starting MPI job on node "`hostname`
    nnodes=$PBS_NUM_NODES
    nprocs=0
    for nodename in `cat $PBS_NODEFILE`
    do
        ncpus=`ssh $nodename 'cat /proc/cpuinfo | grep processor | wc -l'`
        echo "node "$nodename" has "$ncpus" CPUs."
    for i in `seq 1 $ncpus`; do
        echo $nodename >> $TMPDIR/myhostfile
    done
        ((nprocs=$nprocs+$ncpus))
    done
    echo "Starting interactive MPI job on "$nnodes" batch nodes with a total of "$nprocs" CPUs."
    cat $TMPDIR/myhostfile
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PBS_O_WORKDIR
    cd $PBS_O_WORKDIR
    mpirun -np $nprocs -hostfile $TMPDIR/myhostfile $PBS_O_WORKDIR/matlabprog
    ;;
*)
    echo "default case"
esac



