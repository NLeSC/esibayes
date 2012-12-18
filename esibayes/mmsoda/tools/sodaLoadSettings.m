function conf = sodaLoadSettings(conf,f)


if uimatlab
   [varName,varValue] = textread(f,'%s = %[^\n]');
   for k=1:numel(varName)
       if ~isfield(conf,varName{k})
           eval(['conf.',varName{k},'=',varValue{k},';'])
       end
   end
elseif uioctave
   fid = fopen(f,'r');
   while true
      s = fgetl(fid);
      if s==-1
         break
      end
      varName=sscanf(s,'%s = %*s','C');
      if ~isfield(conf,varName)
          eval(['conf.',s,';']);
          %eval(['conf.',varName,'=',varValue,';'])
      end
   end
elseif isdeployed
   [varName,varValue] = textread(f,'%s = %[^\n]');
   for k=1:numel(varName)
       if ~isfield(conf,varName{k})
           eval(['conf.',varName{k},'=',varValue{k},';'])
       end
   end
else
   disp('Unrecognized UI. Aborting.')
end


