function m=bcastvar(root,myvar)

if ~(exist('mpisize')==1)
    whoami;
end

if ~(exist('myvar')==1)
    myvar=0;
end

m=hlp_deserialize(mm_bcast(root,hlp_serialize(myvar)));
