
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
 echo "4"
;;
Exit)
exit
;;
*)
echo "wrong choice"
;;
esac
done

