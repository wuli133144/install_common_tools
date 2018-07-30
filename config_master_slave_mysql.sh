


#!/bin/bash
#
#
#Copyright <2018-7-27> <COPYRIGHT wuyujie@sunlands.com>
#ISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
#THE SOFTWARE.Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"),to deal in the Software
#without restriction, including without limitation the rights to use, copy, modify   ,
#merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
#permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM,DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, AR
#
#
#


if [[ $UID -ne 0 ]] ;then 
  echo "permission just for root" >/dev/null 2>&1
  exit -1
fi 



DATA_DIR=/data/mysql

BASE_DIR=/application/mysql 

#data prepare 

function prepared(){

    mkdir -p /data/mysql/{3306,3307,3308}

    ln -s /application/mysql-5.5.32/  /application/mysql 

    for i in $(ls /data/mysql/);do

        cd  ${DATA_DIR}/${i}

        cp  -rf /application/mysql/support-files/my-small.cnf   ./
        #modify cofig 
        
        sed -i 's#3306#${{i}}#g' my-small.cnf 
        sed -i 's#/application/mysql-5.5.32/tmp/mysql.sock#/${{DATA_DIR}}/${{i}}/my.sock#g'  my-small.cnf 
        sed -i 's#server-id= 1# server-id=${{i}}#g' my-small.cnf 

        chown -R mysql:mysql ${DATA_DIR}/${i}
        /application/mysql/scripts/mysql_install_db --basedir=/application/mysql/  --datadir=/${DATA_DIR}/${i}   --user=mysql 
       
        sleep 2
    done 

}


function start(){
       
    cd ${DATA_DIR}

    for i in $(ls /data/mysql/ ); do
        #statements
         /application/mysql/bin/mysqld_safe --defaults-file=${DATA_DIR}/${i}/my-small.cnf   --user=mysql 
         if [[ $? -ne 0 ]]; then
             #statements
             echo "start mysql server(${i}) failed"
             exit -1
         fi
    done
    
}



function stop(){
       
    cd ${DATA_DIR}

    for i in $(ls /data/mysql/ ); do
        #statements
         /application/mysql/bin/mysqladmin -uroot -p  shutdown
         if [[ $? -ne 0 ]]; then
             #statements
             echo "stop mysql server(${i}) failed"
             exit -1
         fi
    done
    
}


case $1 in
     'start' )
      prepared
      start
      ;;
     'stop')
       stop
        ;;
        *)
        ;;
esac























