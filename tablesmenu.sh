#!/bin/bash

tablesmenu(){

 echo -e "\n+*************Tables Menu**************+"
  echo " 1.Create Table"
  echo " 2.List Tables"
  echo " 3.Drop Table"
  echo " 4.Insert into Table"
  echo " 5.Select from Table"
  echo " 6.Delete from Table"
  echo "+******************************************+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
   1) createtable;;
   2) ls .; tablesmenu;;
   3) droptable;
   4) insert;;
   5) select;;
   6) delete;;
    *) echo " Wrong Choice " ; tablesMenu;
  esac




bash DBMS.sh
}
