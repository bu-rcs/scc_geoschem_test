export OMP_STACKSIZE="2G" 
export OMP_NUM_THREADS=$NSLOTS

ulimit -s unlimited 
ulimit -a 

module purge 
module load intel/2024.0
module load openmpi/4.1.5_intel-2024
module load hdf5/1.10.10_intel-2024
module load hdf4/2.16_no_netcdf_intel-2024
module load netcdf/4.9.2_intel-2024
module load netcdf-fortran/4.6.1_intel-2024

# Tell GEOS-Chem where to find netCDF library files 
export GC_BIN=$SCC_NETCDF_BIN 
export GC_INCLUDE=$SCC_NETCDF_INCLUDE 
export GC_LIB=$SCC_NETCDF_LIB 
export GC_F_BIN=$SCC_NETCDF_FORTRAN_BIN 
export GC_F_INCLUDE=$SCC_NETCDF_FORTRAN_INCLUDE 
export GC_F_LIB=$SCC_NETCDF_FORTRAN_LIB 
export FC='ifort' 
export CC='icc' 
export CXX='icc' 

# CMAKE COMPILE OPTIONS
NC_CONFIG=$SCC_NETCDF_BIN/nc-config
NETCDF_C_LIBRARY=$SCC_NETCDF_LIB/libnetcdf.so
NETCDF_C_INCLUDE_DIR=$SCC_NETCDF_INCLUDE
CMAKE_Fortran_COMPILER=`which ifort`

# ENVIRONMENT VARIABLE USED TO CONFIGURE CMAKE OPTIONS
export compileOptions="-DNC_CONFIG=${NC_CONFIG} -DNETCDF_C_LIBRARY=${NETCDF_C_LIBRARY} -DNETCDF_C_INCLUDE_DIR=${NETCDF_C_INCLUDE_DIR} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}"
