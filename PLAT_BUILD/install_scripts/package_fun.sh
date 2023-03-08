# ====================================== platform ===============================================
#   check_plat()  package=$1
#   check if package is in the platform
# =====================================  tar ====================================================
#   pre_tar()     package=$1  packagename=$2
#   create directory for untar (tar not in a directory) with command mkdir $BUILD_DIR/$2
#   --------------------------------------------------------------------------------------------
#   run_tar() package download=$1
#   untar with command tar -xzvf $BUILD_DIR/packages_targz/$1
#   --------------------------------------------------------------------------------------------
#   post_tar()  package=$1
#   mv $BUILD_DIR/$2 $PLAT_CODES_DIR/$2;link_install $2 $1; link_install $2 "../PLAT_BUILD/$2"
# =============================================================================================
# package=$1  if [ $1 == 'package'  ]; then
# 'libmesh', 'petsc','femus','salome','med','medcoupling'
# working 'openmpi',
# woring  'openfcom', OpenFoam from o.com
# working 'openforg' OpenFoam from o.org
# working 'dragondonjon'
#   --------------------------------------------------------------------------------------------

# ==================================================================================================
check_plat(){
# ==================================================================================================
# ==========================================================================================================
cd ..
if [ -f "platform_conf.sh" ]; then
  source platform_conf.sh
else
  echo " Wrong directory or enviromnent! look for platform_conf.sh generated by platform2_set!"
fi

  # ----------------------------------------------------------------------------------------------
  # cmake_flag="1" compile with ccmake
  export cmake_flag="0"
  PLAT_BUILD_TAR_DIR=$BUILD_DIR/packages_targz
  PLAT_BUILD_LOG_DIR=$BUILD_DIR/package_logs
  PLAT_BUILD_DIR=$BUILD_DIR
  echo " Getting the evironment Platform set up 1 Level directory from   plat_conf.sh script"
  echo $1 ": 1c PLAT_DIR (platform or software or ...) is     = " $PLAT_DIR
  echo
  echo $1 ": 1c PLAT_BUILD dir (BUILD_DIR) is                 = " $PLAT_BUILD_DIR
  echo $1 ": 1c PLAT_BUILD_TAR_DIR (package archive dir)      = " $PLAT_BUILD_TAR_DIR
  echo $1 ": 1c PLAT_BUILD_LOG_DIR  (log dir)                 = " $PLAT_BUILD_LOG_DIR
  echo
  echo $1 ": 1c PLAT_USERS_DIR  (users dir)                   = " $PLAT_USERS_DIR
  echo $1 ": 1c PLAT_CODES_DIR  (codes dir)                   = " $PLAT_CODES_DIR
  echo $1 ": 1c PLAT_THIRD_PARTY_DIR  (third party code dir)  = " $PLAT_THIRD_PARTY_DIR
  echo $1 ": 1c PLAT_VISU  (visualization dir)                = " $PLAT_VISU_DIR
 # ----------------------------------------------------------------------------------------------
  if [ $1 == 'libmesh' ]; then
  export INSTALL_DIR=$PLAT_CODES_DIR
  echo $1 ": 1d MPI dependency: OPENMPI_DIR      = " $PLAT_THIRD_PARTY_DIR /"openmpi/"
  echo $1 ": 1d MPI dependency: PATH             = " $PLAT_THIRD_PARTY_DIR /"openmpi/bin/"
  echo $1 ": 1d MPI dependency: LD_LIBRARY_PATH  = " $PLAT_THIRD_PARTY_DIR /"openmpi/lib/"
  echo $1 " 1d PETSC dependency: PETSC dir       = " $PLAT_THIRD_PARTY_DIR /petsc
  echo $1 " 1d HDF5 dependency: HDF5 dir         =:" $HDF5_DIR
  fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'petsc' ]; then
  export INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
  echo $1 ": 1d MPI dependency: OPENMPI_DIR     = " $PLAT_THIRD_PARTY_DIR /"openmpi/"
  echo $1 ": 1d MPI dependency: PATH            = " $PLAT_THIRD_PARTY_DIR /"openmpi/bin/"
  echo $1 ": 1d MPI dependency: LD_LIBRARY_PATH = " $PLAT_THIRD_PARTY_DIR /"openmpi/lib/"
  fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'femus' ]; then
  export INSTALL_DIR=$PLAT_CODES_DIR
  echo $1 ": 1d libmesh dependency: LIBMESH_DIR = " $PLAT_CODES_DIR /"libmesh/"
  echo $1 ": 1d MPI dependency: OPENMPI_DIR     = " $PLAT_THIRD_PARTY_DIR /"openmpi/"
  echo $1 ": 1d MPI dependency: PATH            = " $PLAT_THIRD_PARTY_DIR /"openmpi/bin/"
  echo $1 ": 1d MPI dependency: LD_LIBRARY_PATH = " $PLAT_THIRD_PARTY_DIR /"openmpi/lib/"
  echo $1 " 1d PETSC dependency: PETSC dir      = " $PLAT_THIRD_PARTY_DIR /petsc
  echo $1 " 1d HDF5 dependency: HDF5 dir        =:" $HDF5_DIR
  fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'salome' ]; then
  export INSTALL_DIR=$PLAT_BUILD_DIR
  export SALOME_BIN=BINARIES-CO7
  export SALOME_MED_DIR=bin/FIELDS/
  export SALOME_MED_COUPL_DIR=bin/MEDCOUPLING
  export SALOME_HDF5_DIR=bin/hdf5
  export SALOME_med_dir=bin/medfile
  fi
   # ----------------------------------------------------------------------------------------------
  if [ $1 == 'med' ]; then
  export INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
  export cmake_flag="1"
  fi
# ----------------------------------------------------------------------------------------------
  if [ $1 == 'medcoupling' ]; then
  export INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
  export cmake_flag="1"
  export MEDFILE_ROOT_DIR=$INSTALL_DIR/med
  echo $1 ": 1d med dependency: MEDFILE_ROOT_DIR = " $PLAT_THIRD_PARTY_DIR /"med/"
  fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'openmpi' ]; then  export INSTALL_DIR=$PLAT_THIRD_PARTY_DIR;  fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'openfcom' ]; then  export INSTALL_DIR=$PLAT_CODES_DIR;   fi
  # ---------------------------------------------------------------------------------------------
  if [ $1 == 'openforg' ]; then  export INSTALL_DIR=$PLAT_CODES_DIR;   fi
  # ----------------------------------------------------------------------------------------------
  if [ $1 == 'dragondonjon' ]; then  export INSTALL_DIR=$PLAT_CODES_DIR; fi
  # ----------------------------------------------------------------------------------------------


  echo $1 ": 1c INSTALL_DIR  (installation dir)               = " $INSTALL_DIR


return
}

# **********************************************************************************
#   TAR
# **********************************************************************************
pre_tar(){
#   $1=name  $2=package name,i.e. pre_tar $name $name_pck
echo "**************  pre tar" $1
# ===================================================================================
    if [ $1 == 'medcoupling'  ]; then
        echo $BUILD_DIR/$2
        mkdir $BUILD_DIR/$2
        cd $BUILD_DIR/$2
    fi
  # ----------------------------------------------------------------------------------------------
    if [ $1 == 'med'  ]; then
        echo $BUILD_DIR/$2
        mkdir $BUILD_DIR/$2
        cd $BUILD_DIR/$2
    fi
 # ----------------------------------------------------------------------------------------------
 # ----------------------------------------------------------------------------------------------
  echo "************** END pre tar" $1
    return
}


# ===================================================================================
run_tar(){
# $1=package download, i.e  run_tar  $name_download
echo "**************  RUN tar" $1
# ===================================================================================
    tar -xzvf $BUILD_DIR/packages_targz/$1
echo "************** END RUN tar" $1
    return
}

# ===================================================================================
post_tar(){
# $1= name,i.e. post_tar  $name
echo "**************  POST tar" $1
# ===================================================================================
 # ----------------------------------------------------------------------------------------------
    if [ $1 == 'femus'  ]; then
        mv $BUILD_DIR/$2 $PLAT_CODES_DIR/$2
        link_install $2 $1
        link_install $2 "../PLAT_BUILD/$2"
        return
    fi
    # ----------------------------------------------------------------------------------------------
    if [ $1 == 'openfcom'  ]; then
        mv $BUILD_DIR/$2 $PLAT_CODES_DIR/$2
        link_install $2 $1
        link_install $2 "../PLAT_BUILD/$2"

#         tar -xzvf $BUILD_DIR/packages_targz/ThirdParty-v2112.tar.gz
        WM_THIRD_PARTY_DIR=$PLAT_CODES_DIR/$2/ThirdParty-$openfcom_ver

        return
    fi


 # ----------------------------------------------------------------------------------------------
 echo "**************  END POST tar" $1
    return
}

# **********************************************************************************
#  configure
# **********************************************************************************
# ===================================================================================
pre_configure(){
#  NAME=$1=name $2=name_pack, i.e. pre_configure $name $name_pck
# ===================================================================================
echo "**************  pre configure" $1
  # -------------------------- openmpi ----------------------------------------------
  if [ $1 == 'openmpi'  ]; then
  export OPTIONS="--prefix=$INSTALL_DIR/$2  --libdir=$INSTALL_DIR/$2/lib"
  return
  fi
  # --------------------------- petsc -----------------------------------------------
  if [ $1 == 'petsc'  ]; then
  export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
  export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH

  echo $name ": 1d MPI dependency: OPENMPI_DIR="  $INSTALL_DIR"/openmpi/"
  echo $name ": 1d MPI dependency: PATH="$INSTALL_DIR/"openmpi/bin/"
  echo $name ": 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"
  echo
  export METHOD=opt
  export PETSC_ARCH=linux-$METHOD
  export PETSC_DIR=$BUILD_DIR/$2
  export INST_PREFIX=$INSTALL_DIR/$2/$PETSC_ARCH
  echo   $1 ": 2a prefix="$INST_PREFIX

  OPTIONS="--prefix=$INST_PREFIX --with-shared-libraries=1 --with-debugging=0 --download-fblaslapack --download-mumps --download-scalapack --download-hypre --download-metis --with-mpi-dir=$INSTALL_DIR/openmpi"
  #  if [  -d "$BUILD_DIR/packages_targz/fblaslapack.tar.gz" ]; then
  #     export OPTIONS="--prefix=$INST_PREFIX
  #                              --with-mpi-dir=$INSTALL_DIR/openmpi
  #                              --with-shared-libraries=1
  #                              --with-debugging=0
  #                              --download-fblaslapack
  #                              --download-hypre
  #                              --download-mumps
  #                              --download-scalapack"
  #   else
  #    export OPTIONS="--prefix=$INST_PREFIX
  #                              --with-mpi-dir=$INSTALL_DIR/openmpi
  #                              --with-shared-libraries=1
  #                              --with-debugging=0
  #                              --download-fblaslapack
  #                              --download-hypre
  #                              --download-mumps
  #                              --download-scalapack"
  #    fi
    return
  fi
  # -------------------------------------------------------------------------------------
  # ------------------------------- libmesh ---------------------------------------------------
  if [ $1 == 'libmesh'  ]; then
        # 1d Add to the path the openmpi executables and libraries in order to compile petsc
        export PATH=$PLAT_THIRD_PARTY_DIR/openmpi/bin/:$PATH
        export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib/:$LD_LIBRARY_PATH
        export PETSC_ARCH=linux-opt
        export PETSC_DIR=$PLAT_THIRD_PARTY_DIR/petsc
        # 1e HDF5 setup ---------------------------------------------------------------
        export HDF5_DIR=$PLAT_THIRD_PARTY_DIR/hdf5

        echo ${SCRIPT_NAME} " 1d MPI dependency: PATH=           "$PLAT_THIRD_PARTY_DIR/"openmpi/bin/"
        echo ${SCRIPT_NAME} " 1d MPI dependency: LD_LIBRARY_PATH="$PLAT_THIRD_PARTY_DIR/"openmpi/lib/"
        echo ${SCRIPT_NAME} " 1d PETSC dependency: PETSC dir    ="$PLAT_THIRD_PARTY_DIR/petsc
        echo ${SCRIPT_NAME} " 1d HDF5 dependency: HDF5 dir      =:" $HDF5_DIR

#         METHOD=$(echo "\"dbg opt\"")
#         METHOD=${METHOD:="dbg opt"}
        export OPTIONS="--prefix=$INSTALL_DIR/$2\
                --libdir=$INSTALL_DIR/$2/lib \
                --with-mpi-dir=$PLAT_THIRD_PARTY_DIR/openmpi \
                --with-hdf5=$PLAT_THIRD_PARTY_DIR/hdf5  \
                --with-methods="opt"  "
                return
  fi
   # -------------------------------------------------------------------------------------
  # ------------------------------- MED ------------------------------------------------
     if [ $1 == 'med'  ]; then
   echo $1 ": 2b starting configure command from"  $PWD "with ccmake "
   CCMAKEDIR=$2; echo ${CCMAKEDIR}
   export HDF5_ROOT_DIR=$PLAT_THIRD_PARTY_DIR/hdf5
   export MPI_ROOT_DIR=$PLAT_THIRD_PARTY_DIR/openmpi
   export OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$2
                   -DCMAKE_CXX_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx
                   -DCMAKE_C_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc
                   -DCMAKE_Fortran_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpif90
                   -DCMAKE_BUILD_TYPE=None
                   -DCMAKE_CXX_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx
                   -DCMAKE_C_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc
                   -DCMAKE_Fortran_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpif90 "
    return
  fi
# -------------------------------------------------------------------------------------
# --------------------------- Medcoupling ----------------------------------------------
if [ $1 == 'medcoupling'  ]; then
 name_pck2=$(echo $2 | tr [:lower:] [:upper:])
 export CONFIGURATION_ROOT_DIR=$BUILD_DIR/$2/CONFIGURATION_$medcoupling_ver
  echo " Configuration for medCoupling in" $CONFIGURATION_ROOT_DIR

 echo preconfig $name_pck2
 export CCMAKEDIR=$name_pck2; echo "${CCMAKEDIR} "; echo $name_pck2;

    # Find Boost from Salome prerequisites
    export BoostDir=$(find $PLAT_THIRD_PARTY_DIR/salome/bin/ -maxdepth 1 -type d -name 'boost*' -print -quit)
    export Libxml2=$(find $PLAT_THIRD_PARTY_DIR/salome/bin/ -maxdepth 1 -type d -name 'libxml2*' -print -quit)
#     export Cppunit=$(find $INSTALL_DIR/salome/bin/ -maxdepth 1 -type d -name 'cppunit*' -print -quit)

    export OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$2
                    -DCMAKE_BUILD_TYPE=NONE
                    -DHDF5_ROOT_DIR=$PLAT_THIRD_PARTY_DIR/salome/bin/hdf5
                    -DBOOST_ROOT_DIR=$BoostDir
                    -DLIBXML2_ROOT_DIR=$Libxml2
                    -DMEDCOUPLING_ENABLE_RENUMBER=OFF
                    -DMEDCOUPLING_PARTITIONER_METIS=OFF
                    -DMEDCOUPLING_PARTITIONER_SCOTCH=OFF
                    -DMEDCOUPLING_ENABLE_PYTHON=OFF
                    -DMEDCOUPLING_BUILD_DOC=OFF
                    -DCMAKE_CXX_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx
                    -DCMAKE_C_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc
                    -DCMAKE_Fortran_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpif90
                    -DCMAKE_CXX_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx
                    -DCMAKE_C_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc
                    -DCMAKE_Fortran_COMPILER_AR=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpif90 "
  return
 fi
 # -------------------------------------------------------------------------------------
 # ------------------------------- openfoamcom---------------------------------------------------
if [ $1 == 'openfcom' ]; then

     # unset foam variables
       unset OPENMPI_INCLUDE_DIR
       unset OPENMPI_COMPILE_FLAGS
       unset OPENMPI_LINK_FLAGS

        # 1d Add to the path the openmpi executables and libraries in order to compile petsc
        export PATH=$PLAT_THIRD_PARTY_DIR/openmpi/bin/:$PATH
        export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib/:$LD_LIBRARY_PATH
        export PETSC_ARCH=linux-opt
        export PETSC_DIR=$PLAT_THIRD_PARTY_DIR/petsc
        # 1e HDF5 setup ---------------------------------------------------------------
        export HDF5_DIR=$PLAT_THIRD_PARTY_DIR/hdf5

        echo "openmpi include dirs " "`mpicc --showme:incdirs`"
        echo "openmpi library dirs " "`mpicc --showme:libdirs`"
        echo "openmpi link dirs    " "`mpicc --showme:linkdirs`"
        echo ${SCRIPT_NAME} " 1d MPI dependency: PATH=           "$PLAT_THIRD_PARTY_DIR/"openmpi/bin/"
        echo ${SCRIPT_NAME} " 1d MPI dependency: LD_LIBRARY_PATH="$PLAT_THIRD_PARTY_DIR/"openmpi/lib/"
        echo ${SCRIPT_NAME} " 1d PETSC dependency: PETSC dir    ="$PLAT_THIRD_PARTY_DIR/petsc
        echo ${SCRIPT_NAME} " 1d HDF5 dependency: HDF5 dir      =:" $HDF5_DIR

        echo " 3) --------- bashrc setup: of6 environment --------- "
        echo
          echo "line to read" $PLAT_CODES_DIR/$name_pck/$name_pck/etc/bashrc
        isThere=`type -t openfoamcom`
        if [ -z "$isThere" ]; then
        echo "line to read" $PLAT_CODES_DIR/$name_pck/$name_pck/etc/bashrc
        echo "alias openfoamcom='export MYHOME=$PLAT_CODES_DIR && source $PLAT_CODES_DIR/$name_pck/$name_pck/etc/bashrc'" >> ~/.bashrc
        else echo "  openfoamcom alias is already in your ~/.bashrc" ;  fi
        echo " --------- end foam environment --------- "
        echo
        source ~/.bashrc



# #         METHOD=$(echo "\"dbg opt\"")
# #         METHOD=${METHOD:="dbg opt"}
#         export OPTIONS="--prefix=$INSTALL_DIR/$2\
#                 --libdir=$INSTALL_DIR/$2/lib \
#                 --with-mpi-dir=$PLAT_THIRD_PARTY_DIR/openmpi \
#                 --with-hdf5=$PLAT_THIRD_PARTY_DIR/hdf5  \
#                 --with-methods="opt"  "
     return
  fi
 # -------------------------------------------------------------------------------------


echo "**************  END pre configure" $1
  return
}

run_configure(){
 # name =$1,i.e. run_configure $name
 # ===========================================================
 echo "**************  run configure" $1

 # package with no needed configuration
 # ----------------------------------------------------------------------------------
   if [ $1 == 'salome'  ]; then return;   fi
   if [ $1 == 'femus'  ]; then return;   fi
   if [ $1 == 'openfcom'  ]; then  return;   fi


 # ----------------------------------------------------------------------------------
 #  standard configure ->  ./configure
   if [ $cmake_flag != '1'  ]; then
    echo "./configure $OPTIONS >& $PLAT_BUILD_LOG_DIR/$1_config.log"
    ./configure $OPTIONS >& $PLAT_BUILD_LOG_DIR/$1_config.log
   # ----------------------------------------------------------------------------------
    # cc make configure
    else
      echo   ccmake $OPTIONS ./$CCMAKEDIR
    ccmake $OPTIONS ./$CCMAKEDIR
    fi
    # check operation
    if [ "$?" != "0" ]; then
       echo -e " 2b${red}ERROR! Unable to configure, see the log${NC}"
#        dialog --msgbox " 2b${red}ERROR! Unable to configure, see the log${NC}" 10 50
       return
    fi
 # ----------------------------------------------------------------------------------

    echo "************** END run configure" $1
    return
}

post_configure(){
#  name =$1,i.e. post_configure $name_pck
echo "**************  post configure" $1
 echo "**************  END post configure" $1
    return
}
# **********************************************************************************
# **********************************************************************************
# **********************************************************************************
#   COMPILE
# **********************************************************************************
#    pre_compile $name
#       run_compile  $name $name_pck
#       post_compile $name


pre_compile(){
# $1=$name, i.e.   pre_compile $name
echo "**************  pre compile" $1
# ----------------------------------------------------------------------------------
  if [ $1 == 'femus'  ]; then
  echo "Setting environment for femus "
  cd $PLAT_CODES_DIR/$2
  source femus.sh
  fi
# ----------------------------------------------------------------------------------
echo "**************  END pre compile" $1
    return
}

run_compile(){
#   $1=$name, i.e.  run_compile  $name $name_pck


# ----------------------------------------------------------------------------------
if [ $1 == 'salome'  ]; then    return;   fi
  # ----------------------------------------------------------------------------------
if [ $1 == 'openfcom'  ]; then

  echo "4) Now let's build OpenFOAM ... will take a while... somewhere between 30 minutes to 3-6 hours ----------"
  export WM_NCOMPPROCS=2
  cd $PLAT_CODES_DIR/$name_pck/$name_pck/
  echo "foam directory " $PWD
  # openfoamcom
  source etc/bashrc
  # This next command will take a while... somewhere between 30 minutes to 3-6 hours.
  ./Allwmake   >& $PLAT_BUILD_LOG_DIR/$1_compile.log
   #Run it a second time for getting a summary of the installation
  ./Allwmake
  return;
     fi
# ----------------------------------------------------------------------------------
   if [ $1 == 'femus'  ]; then
  femus_link_solver_files
  femus_FEMuS_compile_lib_opt 2
  femus_turbulence_compile_lib_opt 2
   return
   fi
# ----------------------------------------------------------------------------------
   echo "make -j2 >&  $PLAT_BUILD_LOG_DIR/$1_compile.log"
    make -j2 >&  $PLAT_BUILD_LOG_DIR/$1_compile.log
    if [ "$?" != "0" ]; then
        echo -e " 2b${red}ERROR! Unable to compile, see the log${NC}"
        dialog --msgbox " 2b${red}ERROR! Unable to compile, see the log${NC}" 10 50
        return
     fi
  # ----------------------------------------------------------------------------------
    return
}


post_compile(){
# $1=$name, i.e.   post_compile $name
    echo "**************" postcompile $1

 # ------------------------ petsc  ----------------------------------------------------
     if [ $1 == 'petsc'  ]; then
    echo "make check >& $PLAT_BUILD_LOG_DIR/$1_testing.log"
    make check >& $PLAT_BUILD_LOG_DIR/$1_testing.log
    if [ "$?" != "0" ]; then
      echo -e " 2d ${red}ERROR! Unable to run test examples${NC}"
      dialog --msgbox " 2d ${red}ERROR! Unable to run test examples${NC}" 10 50
      return
    fi
    return
    fi

  # -----------------------openfoam com ------------------------------------------------
    if [ $1 == 'openfcom'  ]; then
    echo " OpenFOAM installed ----------"
    openfoamcom
    foamSystemCheck
    # Now create a run directory and copy all the tutorials to it
    echo
    return
    fi




 # ----------------------------------------------------------------------------------
    return
}
# **********************************************************************************
# **********************************************************************************
# **********************************************************************************
#  INSTALL
# **********************************************************************************
#   pre_install $name
#      run_install $name $name_pck
#      post_install $name


pre_install(){
# $1=name,i.e. pre_install $name
    echo "pre-install $1"
    return
}

run_install(){
# $1=name,i.e. run_install $name $name_pck
  echo "run install $1"
   if [ $1 == 'salome'  ]; then    return;   fi
   # ----------------------------------------------------------------------------------
   if [ $1 == 'femus'  ]; then return;   fi
   # ----------------------------------------------------------------------------------
   if [ $1 == 'openfcom'  ]; then


  cd $PLAT_CODES_DIR/$name_pck/GeN-Foam/GeN-Foam/
  echo "GeN-Foam directory " $PWD
  openfoamcom
  # This next command will take a while... somewhere between 30 minutes to 3-6 hours.
  ./Allwmake   >& $PLAT_BUILD_LOG_DIR/$1_install.log

   return;
   fi
   # ----------------------------------------------------------------------------------
echo "make install >& $PLAT_BUILD_LOG_DIR/$1_install.log"
    make install >& $PLAT_BUILD_LOG_DIR/$1_install.log
      if [ "$?" != "0" ]; then
        echo -e " 2b${red}ERROR! Unable to install, see the log${NC}"
        return
     fi

    return
}
# =======================================================================
post_install(){
# $1=name,i.e post_install $name
  echo "ppost-install $1"
    return
}
# **********************************************************************************
#  LINK
# **********************************************************************************
# =======================================================================
link_install(){
# $1={name_pck}  $2={name}
  echo "link-install $1"
 if [ -d $INSTALL_DIR/$2 ]
    then
    rm -r $INSTALL_DIR/$2
    echo "ln deleted"
  fi

  if [ $2 == 'petsc'  ]; then
    echo ${name} ": 3a ln -s  from" $INSTALL_DIR/$1/$PETSC_ARCH "to"  $INSTALL_DIR/$2
    ln -s $INSTALL_DIR/$1/$PETSC_ARCH $INSTALL_DIR/$2

  elif [ $2 == 'salome' ]; then

        if [ -L $PLAT_THIRD_PARTY_DIR/$2 ];  then rm -r $PLAT_THIRD_PARTY_DIR/$2; echo "salome ln deleted" ; fi
            ln -s $BUILD_DIR/$1  $PLAT_THIRD_PARTY_DIR/$2  ;
            echo $SCRIPT_NAME " 3a link -> salome from"  $BUILD_DIR/$1 "to"  $PLAT_THIRD_PARTY_DIR/$2

        if [ -L $PLAT_CODES_DIR/$2 ];  then rm -r  $PLAT_CODES_DIR/$2; echo "salome ln deleted" ;fi
            ln -s $BUILD_DIR/$1  $PLAT_CODES_DIR/$2  ;

        if [ -L $PLAT_THIRD_PARTY_DIR/hdf5 ];  then rm -r  $PLAT_THIRD_PARTY_DIR/hdf5;echo "hdf5 ln deleted" ;fi
            ln -s $BUILD_DIR/$1/${SALOME_HDF5_DIR}  $PLAT_THIRD_PARTY_DIR/hdf5  ;
            echo $SCRIPT_NAME " 3a link -> hdf5 from "$BUILD_DIR/$1/${SALOME_HDF5_DIR}  "to" $PLAT_THIRD_PARTY_DIR/hdf5

        if [ -L $PLAT_THIRD_PARTY_DIR/$2/bin ];  then rm -r  $PLAT_THIRD_PARTY_DIR/$2/bin; echo "salome/bin ln deleted" ;fi
            ln -s $BUILD_DIR/$1/$SALOME_BIN       $PLAT_THIRD_PARTY_DIR/$2/bin;
            echo $SCRIPT_NAME " 3a link -> bin from "$BUILD_DIR/$1/$SALOME_BIN   "to" $PLAT_THIRD_PARTY_DIR/$2/bin

        if [ -L $PLAT_THIRD_PARTY_DIR/med ];  then   rm -r  $PLAT_THIRD_PARTY_DIR/med ;echo "med ln deleted" ;fi
            ln -s $BUILD_DIR/$1/$SALOME_med_dir  $PLAT_THIRD_PARTY_DIR/med      ;
            echo $SCRIPT_NAME " 3a link -> salome/med from "  $BUILD_DIR/$1/$SALOME_med_dir "to" $PLAT_THIRD_PARTY_DIR/med      ;

        if [ -L $PLAT_THIRD_PARTY_DIR/MED_mod ];  then rm -r  $PLAT_THIRD_PARTY_DIR/MED_mod ;echo "MED_mod ln deleted" ;fi
            ln -s $BUILD_DIR/$1/${SALOME_MED_DIR}        ${PLAT_THIRD_PARTY_DIR}/MED_mod ;
            echo $SCRIPT_NAME " 3a link -> salome/MED_mod from " $BUILD_DIR/$1/$SALOME_MED_DIR "to " $PLAT_THIRD_PARTY_DIR/MED_mod ;

        if [ -L $PLAT_THIRD_PARTY_DIR/medcoupling ];  then rm -r  $PLAT_THIRD_PARTY_DIR/medcoupling ;echo "MED_coupling ln deleted" ;fi
            ln -s  $BUILD_DIR/$1/$SALOME_MED_COUPL_DIR $PLAT_THIRD_PARTY_DIR/medcoupling    ;
            echo $SCRIPT_NAME " 3a link -> salome/MED_coupling from" $BUILD_DIR/$1/$SALOME_MED_COUPL_DIR "to" $PLAT_THIRD_PARTY_DIR/medcoupling;

    else
    echo ${name} ": 3a ln -s  from" $INSTALL_DIR/$1 "to"  $INSTALL_DIR/$2
    ln -s $INSTALL_DIR/$1 $INSTALL_DIR/$2
  fi

  if [ "$?" != "0" ]; then
        echo -e " 2b${red}ERROR! Unable to link, see the log${NC}"
        return
  fi


  return
}

# =======================================================================
link_lib_lib64(){
   # $1=name
     echo "link_lib_lib64 $1"

   if [ $1 == 'openmpi'  ]; then
    echo ${name} ": 3a ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64";
  ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64
  if [ "$?" != "0" ]; then dialog --msgbox " 2b${red}ERROR! Unable to link, see the log${NC}" 10 50
    return
  fi
 fi

    if [ $1 == 'libmesh'  ]; then
    echo ${name} ": 3a ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64";
  ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64
  if [ "$?" != "0" ]; then
     dialog --msgbox " 2b${red}ERROR! Unable to link, see the log${NC}" 10 50
    return
  fi
 fi

    if [ $1 == 'med'  ]; then
    echo ${name} ": 3a ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64";
  ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64
  if [ "$?" != "0" ]; then dialog --msgbox " 2b${red}ERROR! Unable to link, see the log${NC}" 10 50
    return
  fi
 fi

     if [ $1 == 'medcoupling'  ]; then
    echo ${name} ": 3a ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64";
  ln -s $INSTALL_DIR/$1/lib  $INSTALL_DIR/$1/lib64
  if [ "$?" != "0" ]; then dialog --msgbox " 2b${red}ERROR! Unable to install, see the log${NC}" 10 50
    return
  fi
 fi



  return
  }

# =======================================================================
post_link(){

echo "post link $1"
# --------- petsc ---------------------------------------------------
if [ $1 == 'petsc'  ]; then
   echo  $1 " 3b PETSC post install: PETSC usage "
  echo "In order to run PETSC please set the following environment: "
  echo "export PETSC_DIR="$PLAT_THIRD_PARTY_DIR/$1
  echo "export PETSC_ARCH=$PETSC_ARCH"
fi
# --------------------------------------------------------------------


  }