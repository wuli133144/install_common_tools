


#!/bin/bash
#
#
#Copyright <2018-7-27> <COPYRIGHT wuyujie@sunlands.com>
#ISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#Permission is hereby granted, free of charge, to any person obtaining a copy of this 
#software and associated documentation files (the "Software"), to deal in the Software
#without restriction, including without limitation the rights to use, copy, modify   ,
#merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
#permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
#DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, AR
#
#
#


if [[ $UID -ne 0 ]] ;then 
  echo "permission just for root" >/dev/null 2>&1
  exit -1
fi 



function check_installing_package()
{
   if [[ ! -e ./mysql* ]]; then
   	#statements
   	 echo "unable to get mysql  resource package, please check it"
   	 exit  -1
   fi

}

function install_start()
{
    
	check_installing_package()

	tar -xvf mysql-5.5.32.tar.gz 

	cd mysql-5.5.32

	cmake . -DCMAKE_INSTALL_PREFIX=/application/mysql-5.5.32 \
	-DMYSQL_DATADIR=/application/mysql-5.5.32/data \
	-DMYSQL_UNIX_ADDR=/application/mysql-5.5.32/tmp/mysql.sock \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
	-DENABLED_LOCAL_INFILE=ON \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_FEDERATED_STORAGE_ENGINE=1 \
	-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
	-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
	-DWITHOUT_PARTITION_STORAGE_ENGINE=1 \
	-DWITH_FAST_MUTEXES=1 \
	-DWITH_ZLIB=bundled \
	-DENABLED_LOCAL_INFILE=1 \
	-DWITH_READLINE=1 \
	-DWITH_EMBEDDED_SERVER=1 \
	-DWITH_DEBUG=0
    #modify config file
	make && make install 
	if [[ $? -ne 0 ]]; then
		#statements
		echo "make install error!"
		exit -1
	fi
	cp -R /application/mysql-5.5.32/support-files/my-small.cnf   /etc/my.cnf
	echo 'PATH=/application/mysql-5.5.32/bin:$PATH' >> /etc/profile
	source /etc/profile 

	chown -R mysql.mysql /application/mysql-5.5.32/data 

	cd /application/mysql-5.5.32/scripts/

	./mysql_install_db --basedir=/application/mysql-5.5.32/ --datadir=/application/mysql-5.5.32/data  --user=mysql 

	cd ../
	cp -R ./support-files/mysql.server  /etc/init.d/mysqld 
 
}

    

function start()
{
    if [[ ! -e /etc/init.d/mysqld ]]; then
    	#statements
    	echo "unable to find binary files of mysql please check it"
    	exit  -1
    fi

    /etc/init.d/mysqld  start 

    if [[ $? -eq 0 ]]; then
    	#statements
    	echo "start mysql success!"
    else 
    		#statements
    		echo "start mysql failed!"
    fi
}


#enter
#


case  $1 in

    "install_start")
    install_start
    ;;
    "start")
    start
    ;;

    *)
    ;;
esac