#!/bin/bash
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
bash DBMS.sh
}
selectall()
{
echo -e "enter the table name: \c"
read tname
column -t -s '|' $tname 2 >>./.error.log
if [ $? != 0 ];
then 
echo " no such file exist"
fi
}



selectfromtable()
{
select choice in selectall selectwithcondition
do
case $choice in 
selectall)
selectall
;;
selectwithcondition)
selectwithcondition
;;
*)
echo "wrong choice"
;;
esac
done
}

dropfromtable (){
echo -e "enter the table name : \c "
read tname
echo -e "enter value :\c "
read field
fid= $(awk 'BEGIN {FS ="|"} {if (NR ==1) {for(i=1;i<NF;i++) {if $i == "'$field'" print i }}}', $tname)
if [ fid == " " ];
then
echo "not found"
tablemenu
else
echo -e "enter the value "
read val
res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tname  2>> ./.error.log)

if [ res == "" ];
then
echo "value not found"
tablemenu
else
NR = $(awk 'BEGIN{FS= "|"}{if($'$fid'=="'$val'") print NR}' $tname 2 >> ./.error.log)
sed -i '$NRd' $tname 2>> ./.error.log
echo "row deleted successfully"
tablemenu
fi
fi
}

      
tablemenu ()
{
select choice in CreateTable ListTables InsertIntoTable Selectfromtable DropFromTable DropTable Exit
do
case $choice in

CreateTable)
 echo "1"
;;
ListTables)
 echo "2"
;;
InsertIntoTable)
 echo "3"
;;
SelectFromTable)
selectfromtable
;;
DropFromTable)
exit
;;
DropTable)
echo "Droptable"
;;
Exit)
exit
;;
*)
echo "wrong choice"
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
tablemenue

else
echo "DataBase $dbname is not exist"
 bash DBMS.sh

fi
}

select choice in CreateDataBase ListDataBases ConnectToDataBase DropDataBase Exit
do
case $choice in

CreateDataBase)
 echo "1"
;;
ListDataBases)
 echo "2"
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
;;
esac
done
