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


if [[ $UID -ne 0 ]] then 
  echo "permission just for root" >/dev/null 2>&1
  exit(-1)
fi 

function  check_install_package()
{
     if [[ ! -e ./redis-3.0.7.tar.gz   ]] || [[ ! -e ./ruby-2.5.1.tar.gz ]] then
             echo "basic install package resource is not ready......please  download them "
             exit(-1)
     fi

}

function unpack()
{
	   check_install_package()
       for i in $(ls  *.tar.gz > /dev/null 2>&1 ); do
       	#statements
       	  tar -xvf ${i}
       done

       cd ./redis-3.0.7
       mkdir /usr/local/cluster

       ./configure --prefix=/usr/local/cluster

       make && make install 
       
       cd ./ruby-2.5.1

       mkdir /usr/local/ruby 

       ./configure --prefix=/usr/local/cluster

       make && make install 


}


function config_pack()
{         
      
      #sed -i "a\PATH=$PATH:/usr/local/ruby/bin/"  /root/.bash_profile
      #sed -i "a\export PATH"  /root/.bash_profile
      echo 'export PATH=/usr/local/ruby/bin:$PATH ' >>/etc/profile 
      source /etc/profile 
}


function cluster()
{

        mkdir /usr/local/cluster-more/$1

        mkdir /usr/local/cluster-more/$2
        mkdir /usr/local/cluster-more/$3
        mkdir /usr/local/cluster-more/$4
        mkdir /usr/local/cluster-more/$5
        mkdir /usr/local/cluster-more/$6
        mkdir /usr/local/cluster-more/$7

        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$1      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$2      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$3      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$4      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$5      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$6      
        cp -rf  /usr/local/cluster/bin/*    /usr/local/cluster-more/$7      
        
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$1
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$2
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$3
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$4
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$5
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$6
        cp -rf  /usr/local/cluster/redis.conf    /usr/local/cluster-more/$7
        

}




