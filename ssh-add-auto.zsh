ssh(){
   local found=0
   setopt RE_MATCH_PCRE

   while IFS='' read -r line
   do
      if [[ $found -eq 1 && $line =~ 'Host ' ]]; then
         found=0
      fi
      if [[ $found -eq 1 ]]; then
         if [[ $line =~ '[^#]{0,}IdentityFile ' ]]; then
            keyfile=${line#*IdentityFile *}
         fi
      fi
      if [[ "Host $1" == "$line" ]]; then
         found=1
      fi
   done < ~/.ssh/config
   keyfile=${keyfile/\~/$HOME}
   ssh-add -l | grep $keyfile > /dev/null
   if ! [[ $? -eq 0 ]]; then
      ssh-add $keyfile
   fi
   /usr/bin/ssh $1
}
