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
              **********************************


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
 echo "3"
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



*************************************
