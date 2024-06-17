#!/bin/bash -l

# CHECK FOR VALID ARGUMENTS
if [ -z "$1" ]
  then
    echo "ERROR: No git tag argument provided."
    exit 1
fi

if [ -z "$2" ]
  then
    printf "ERROR: No destination directory argument provided."
    exit 1
fi

GIT_TAG=$1  # DESIRED RELEASE TO TEST

# DEFINE DIRECTORIES
DEST_ROOT=$2                            # LOCATION WHERE ALL FILES WILL BE STORED
DEST_CLONE=${DEST_ROOT}/geochem_${1}    # GIT CLONE LOCATION
RUNS_DIR=${DEST_ROOT}/runs              # LOCATON OF TEST RUNS


# CHECK IF GIT CLONE DIRECTORY EXISTS
if [ -d ${DEST_CLONE} ]; then
  printf "ERROR: Destination directory already contains ${DEST_CLONE}.  Delete this directory or specify a different destination."
  exit 1
fi

# CHECK IF THE 'runs' DIRECTORY EXISTS
if [ -d ${RUNS_DIR} ]; then
  printf "ERROR: Running directory already exists ${RUNS_DIR}.  Please delete and run the script again."
  exit 1
fi

# GIT CLONE THE REPORT
printf "\n\nSCC TEST - DOWNLOAD FROM GITHUB\n"
printf "===================================================\n"

printf "Downloading GeoChem ${GIT_TAG} to directory ${DEST_CLONE}\n"

git clone --recurse-submodules --depth 1 --branch $1  https://github.com/geoschem/GCClassic.git $DEST_CLONE

printf "Download complete.\n"

printf "\n\nSCC TEST - ENVIRONMENT SETUP\n"
printf "===================================================\n"
printf "Sourcing env.sh to setup enviroment.\n"
source env.sh

printf "\n\nSCC TEST - CREATE RUN DIRECTORY\n"
printf "===================================================\n"
mkdir -p ${RUNS_DIR}

cd ${DEST_CLONE}/test/parallel/GCClassic/ && ./parallelTestCreate.sh ${RUNS_DIR} env.sh ALL YES

if [ $? -ne 0 ]; then
    printf "Failed to create run directories. \nExiting\n"
    exit 1
fi

printf "\n\nSCC TEST - COMPILE RUNS\n"
printf "===================================================\n"
printf "compileOptions=${compileOptions}\n"

cd ${RUNS_DIR}/scripts/
sed -i "s|baseOptions=.*|baseOptions=\"-DCMAKE_BUILD_TYPE=Debug -DRUNDIR='' -DINSTALLCOPY=\${binDir} ${compileOptions}\"|" ./parallelTestCompile.sh

./parallelTestCompile.sh

cat ${RUNS_DIR}/logs/results.compile.log


printf "\n\nSCC TEST - EXECUTE TESTS\n"
printf "===================================================\n"
./parallelTestExecute.sh 

cat tail -l ${RUNS_DIR}/logs/results.parallel.log