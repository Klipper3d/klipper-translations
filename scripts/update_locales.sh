#!/bin/bash
#Automatically generate a set of po and md files for 
#Localization in the ./locales/[language]/ folder
#requirement: pip install mdpo

width=71

#Generate Pot Base Files
for file in docs/*.md; do
  
  mdfile=${file/docs\//} #Remove docs/
  mdfilepath=docs/$mdfile #add docs/ 
  potfile=${mdfile//.md/.pot} #replace .md with .pot
  potfilepath=docs/locales/en/$potfile #Add docs/locales/en/ to potfile
  echo "Converting $mdfile to $potfile"
  command="md2po $mdfilepath --md-encoding utf-8 --po-encoding utf-8 -e utf-8 \
  -w $width -q -s --po-filepath $potfilepath"
  echo "$command"
  $($command)
done

for dir in docs/locales/*/; do
  dir=${dir%*/}
  dir=${dir##*/}
  if [ $dir != "en" ]; then
    echo "Updating $dir"
    for file in docs/*.md; do
      mdfile=${file/docs\//} #Remove docs/
      mdfilepath=docs/$mdfile #add docs/ 
      pofile=${mdfile//.md/.po} #replace .md with .po
      pofilepath=docs/locales/$dir/LC_MESSAGES/$pofile #Add target directory 
      #to pofile
      targetmdfile=docs/locales/$dir/$mdfile #Add target directory to mdfile
      echo "Converting $mdfile to $pofile"
      command="md2po $mdfilepath --md-encoding utf-8 --po-encoding utf-8 \
      -e utf-8 -w $width -q -s --po-filepath $pofilepath"
      echo "$command"
      $($command)
      echo "Converting $pofile to $mdfile"
      command="po2md $mdfilepath --md-encoding utf-8 --po-encoding utf-8 \
      -p $pofilepath -q -s $targetmdfile"
      echo "$command"
      $($command)
    done
  fi
done
