#!/bin/bash

createtable(){


echo -e "Table name: \c "
read tablename


echo -e "Enter number of columns : \c"
read colnum

counter=1
sep="|"
rsep="\n"
pkey=""
metadata="field"$sep"type"$sep"key"

 while [ $counter -le $colnum ]
  do
    echo -e "Column No.$counter is: \c"
    read colname

    echo -e "Type of Column $colname is: "
    select var in "int" "str"
    do
      case $var in
        int ) coltype="int";break;;
        str ) coltype="str";break;;
        * ) echo "Wrong Choice" ;;
      esac
done


if [[ $pkey == "" ]]; then
      echo -e "Make PrimaryKey ? "
      select var in "yes" "no"
      do
        case $var in
          yes ) pkey="PK";
          metadata+=$rsep$colname$sep$coltype$sep$pkey;
          break;;
          no )
          metadata+=$rsep$colname$sep$coltype$sep""
          break;;
          * ) echo "Wrong Choice" ;;
        esac
      done
    else
      metadata+=$rsep$colname$sep$coltype$sep""
    fi
    if [[ $counter == $colnum ]]; then
      temp=$temp$colname
    else	
      temp=$temp$colname$sep
    fi
    ((counter++))
  done
  touch .$tablename
  echo -e $metadata  >> .$tablename
  touch $tablename
  echo -e $temp >> $tablename
  if [[ $? == 0 ]]
  then
    echo "Table Created Successfully"
    tablesmenu
  else
    echo "Error Creating Table $tablename"
    tablesmenu
  fi
}


bash DBMS.sh
}
