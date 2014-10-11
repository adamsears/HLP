#!/bin/bash

yum -y install perl-ExtUtils-MakeMaker perl-ExtUtils-CBuilder

tar -zxvf JSON-2.90.tar.gz
cd JSON-2.90/
perl Makefile.PL
make
make test
make install
echo "========module status==========="
hostname 
perl -MJSON -e "print\"module installed\n\""
echo "================================"
cd ..
rm -r JSON-2.90.tar.gz JSON-2.90/ 
