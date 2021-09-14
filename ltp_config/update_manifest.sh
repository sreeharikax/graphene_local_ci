#!/bin/bash

if [[ $LTPSCENARIO == *"syscalls-new"* ]]; then
    sed -i '76 a sgx.allowed_files.pipe202child = "file:pipe2_02_child"' $PWD/install-sgx/testcases/bin/pipe2_02.manifest
    sed -i '76 a sgx.allowed_files.execvpchild = "file:execvp01_child"' $PWD/install-sgx/testcases/bin/execvp01.manifest
    sed -i '76 a sgx.allowed_files.execvchild = "file:execv01_child"' $PWD/install-sgx/testcases/bin/execv01.manifest
    sed -i '76 a sgx.allowed_files.execlpchild = "file:execlp01_child"' $PWD/install-sgx/testcases/bin/execlp01.manifest
    sed -i '76 a sgx.allowed_files.execlchild = "file:execl01_child"' $PWD/install-sgx/testcases/bin/execl01.manifest 
fi