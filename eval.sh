#!/bin/bash 

path=$(cd "$(dirname "$0")"; pwd)

filesToProcess() {
  local listFile=openssl_files
  cat $listFile | sed -n "${1}~7p" 
}

flags=" --bdd \
  	--study openssl --reuseAST --refEval extract --refLink $path/CLinking.interface \
        -I $path/openssl \
	 -I $path/openssl/include
	-I $path/openssl/include/openssl
	--platfromHeader $path/openssl/platform.h \
        --featureModelDimacs $path/openssl/OpenSSL.dimacs \
	--include $path/openssl/partial_configuration.h \
	--recordTiming --parserstatistics --lexNoStdout"

filesToProcess $1|while read i; do
         echo "Analysing $path/openssl/$i.c"
         echo "With settings: $flags"
         ../TypeChef/cRefactor.sh $path/openssl/$i.c $flags
         echo "Verifiying $path/result/$i"
	 openssl/verify.sh $path/result/$i.c
         done

exit
