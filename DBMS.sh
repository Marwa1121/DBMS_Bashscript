#!/bin/bash
 createdatabase(){
echo -e "Enter Database Name: \c"
  read dbName
  mkdir -p ./DBMS/$dbName
  if [[ $? == 0 ]]
  then
    echo "Database Created Successfully"
  else
    echo "Error Creating Database $dbName"
  fi
 mainscript
 
}

 listdatabases()
{
echo -e "The existing databases are :"

ls ./DBMS; 

mainscript

}

dropdatabase()
{
echo -e " Enter database name : \c "
read dbname
rm -r ./DBMS/$dbname 2>>./.error.log
if [ $? == 0 ]; then
 echo "database is dropped successfully"
else
 echo "database is not found"
fi
mainscript
}

createtable(){
echo -e "Table name: \c "
read tablename
echo -e "Enter number of columns : \c"
read colnum

counter=1
sep="|"
rsep="\n"
pkey=""
metadata="Table name"$rsep$tablename$rsep"number of colums"$rsep$colnum$rsep
metadata+="field"$sep"type"$sep"key"

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
  touch  metadata$tablename
  echo -e $metadata  >> metadata$tablename
  touch $tablename
  echo -e $temp >> $tablename
  if [[ $? == 0 ]]
  then
    echo "Table Created Successfully"
    tablemenu
  else
    echo "Error Creating Table $tablename"
    tablemenu
  fi
}




listtables(){

ls .;
tablemenu
}

selectall(){
echo -e "Enter Table Name: \c"
  read tName
  column -t -s '|' $tName 2>>./.error.log
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tName"
  fi
selectfromtable
}



droptable(){
 echo -e "Enter Table Name: "
  read tName
  rm $tName metadata$tName 2>>./.error.log
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
fi
mainscript
}



selectcol() {
 echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Column Number: \c"
  read colNum
  awk 'BEGIN{FS="|"}{print $'$colNum'}' $tName
 
}

selectfromtable()
{
select choice in select_all select_column Exit
do
case $choice in 
select_all)
selectall
;;
select_column)
selectcol
;;
Exit)
tablemenu
;;
*)
echo "wrong choice"
selectfromtable
;;
esac
done
selectfromtable
}

dropfromtable(){

 echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    tablemenu
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName 2>>./.error.log)
    if [[ $res == "" ]]
    then
      echo "Value Not Found"
      tablemenu
    else
      NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print NR}' $tName 2>>./.error.log)
      sed -i ''$NR'd' $tName 2>>./.error.log
      echo "Row Deleted Successfully"
      tablemenu
    fi
  fi

}

insertintotable(){
echo Enter the name of table you want to insert into
read tablename
numofcolums=$(sed -n '4p' metadata$tablename)
row=""
sep="|"
newLine="\n"
i=0
t=6
while [ $i -lt $numofcolums ]
do
colName=$( sed -n  ''$t'p' "metadata$tablename" | cut -d '|' -f 1 )
colType=$( sed -n  ''$t'p' "metadata$tablename" | cut -d '|' -f 2 )
echo "Enter the $colName"
read data
if [ $colType == "int" ]; then
while ! [[ "$data" =~ ^[0-9]+$ ]]; do
echo -e "invalid DataType !!"
echo -e "$colName ($colType) = \c"
read data
done
fi
if [ $colType == "text" ]; then
while  [[ "$data" =~ ^[0-9]+$ ]]; do
echo -e "invalid DataType !!"
echo -e "$colName ($colType) = \c"
read data
done
fi
if [ $i == $(($numofcolums-1)) ]; then
row=$row$data$newLine
else
row=$row$data$sep
fi
((t= t + 1 ))
((i= i + 1 ))

done
echo -e $row"\c" >> $tablename
if [ $? == 0 ]
then
echo "Data Inserted Successfully"
else
echo "Error Inserting Data into Table $tablename"
fi

tablemenu
 
}

      
tablemenu ()
{
select choice in CreateTable ListTables InsertIntoTable Selectfromtable DropFromTable DropTable Exit
do
case $choice in

CreateTable)
 createtable
;;
ListTables)
 listtables
;;
InsertIntoTable)
 insertintotable
;;
Selectfromtable)
selectfromtable
;;

DropTable)
droptable
;;

DropFromTable)
dropfromtable
;;
Exit)
mainscript
;;
*)
echo "wrong choice"
tablemenu
esac
done
}

connectdb()
{
echo -e "enter database name :\c "
read dbname
cd  ./DBMS/$dbname 2>>./.error.log
 if [ $? == 0 ]; then
echo "DataBase $dbname is successfully connected"
tablemenu

else
echo "DataBase $dbname is not exist"
 mainscript

fi
}


mainscript(){
select choice in CreateDataBase ListDataBases ConnectToDataBase DropDataBase Exit
do
case $choice in

CreateDataBase)
 createdatabase
;;
ListDataBases)
 listdatabases
;;
ConnectToDataBase)
 connectdb
;;
DropDataBase)
 dropdatabase 
;;
Exit)
exit
;;
*)
echo "wrong choice"
bash DBMS.sh
;;
esac
done
}

mainscript
