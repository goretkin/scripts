#!/bin/bash
#
# GNU GCC COMPILER INSTALLATION SCRIPT
#
# Copyright (c) 2013 Benjamin Beurdouche. All rights reserved.
#
# You might want to modify the first line to specify your own install location.
# Prerequisites : binutils autoconf automake libtool autogen gettext cloog dejagnu



####
# NOTE : You do not need to build this version of GCC to use TTime, you can use an older package
# An up-to-date version of this script is available at http://github.com/beurdouche/scripts/build_gcc.sh
####

set -x

export LUSER="bbeurdouche"
export LGROUP="staff"

export GNU_PREFIX="/opt/gnu"
export GCC_PREFIX="${GNU_PREFIX}/gcc"

sudo mkdir $GNU_PREFIX
sudo chown -R $LUSER:$LGROUP $GNU_PREFIX
cd $GNU_PREFIX

# Hopefully, you can tweak these as they get out of date, but the download URL's
# may not be stable to text substitution.
GMP_VERSION=gmp-5.1.1
MPFR_VERSION=mpfr-3.1.2
MPC_VERSION=mpc-1.0.1
ISL_VERSION=isl-0.11.1
CLOOG_VERSION=cloog-0.18.0
GCC_VERSION=gcc-4.8.1


# Downloads, builds, then install gmp, mpfr, mpc, and gcc 4.7 to GCC_PREFIX
export PATH="${GCC_PREFIX}/bin:${PATH}"
export LD_LIBRARY_PATH="${GCC_PREFIX}/lib:${LD_LIBRARY_PATH}"
export DYLD_LIBRARY_PATH="${GCC_PREFIX}/lib:${DYLD_LIBRARY_PATH}"

#
# GMP
#
if ! test -d "${GMP_VERSION}"
then
    if ! test -f "${GMP_VERSION}.tar.bz2"
    then
        wget "ftp://ftp.gmplib.org/pub/$GMP_VERSION/${GMP_VERSION}.tar.bz2" || exit
        tar xfjv "${GMP_VERSION}.tar.bz2" || exit
    fi
fi
mkdir "${GMP_VERSION}/build"
cd "${GMP_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" || exit
make -j5 || exit
# make check || exit
make install || exit
cd -

#
# MPFR
#

if ! test -d "${MPFR_VERSION}"
then
    if ! test -f "${MPFR_VERSION}.tar.gz"
    then
        wget "http://www.mpfr.org/mpfr-current/${MPFR_VERSION}.tar.gz" || exit
        tar xfvz "${MPFR_VERSION}.tar.gz" || exit
    fi
fi
mkdir "${MPFR_VERSION}/build"
cd "${MPFR_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" --with-gmp="${GCC_PREFIX}" || exit
make -j5 || exit
# make check || exit
make install || exit
cd -

#
# MPC
#

if ! test -d "${MPC_VERSION}"
then
    if ! test -f "${MPC_VERSION}.tar.gz"
    then
        wget "http://www.multiprecision.org/mpc/download/${MPC_VERSION}.tar.gz" || exit
        tar xfvz "${MPC_VERSION}.tar.gz" || exit
    fi
fi
mkdir "${MPC_VERSION}/build"
cd "${MPC_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" --with-gmp="${GCC_PREFIX}" --with-mpfr="${GCC_PREFIX}" || exit
make -j5 || exit
# make check || exit
make install || exit
cd -

#
# ISL
#

if ! test -d "${ISL_VERSION}"
then
    if ! test -f "${ISL_VERSION}.tar.bz2"
    then
        wget "ftp://gcc.gnu.org/pub/gcc/infrastructure/${ISL_VERSION}.tar.bz2" || exit
        tar xfvz "${ISL_VERSION}.tar.bz2" || exit
    fi
fi
mkdir "${ISL_VERSION}/build"
cd "${ISL_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" --with-gmp="${GCC_PREFIX}" --with-mpfr="${GCC_PREFIX}" --with-mpc="${GCC_PREFIX}" || exit
make -j5 || exit
# make check || exit
make install || exit
cd -

#
# CLOOG
#

if ! test -d "${CLOOG_VERSION}"
then
    if ! test -f "${CLOOG_VERSION}.tar.gz"
    then
        wget "ftp://gcc.gnu.org/pub/gcc/infrastructure/${CLOOG_VERSION}.tar.gz" || exit
        tar xfvz "${CLOOG_VERSION}.tar.gz" || exit
    fi
fi
mkdir "${CLOOG_VERSION}/build"
cd "${CLOOG_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" --with-bits=gmp --with-gmp="${GCC_PREFIX}" --with-mpfr="${GCC_PREFIX}" --with-mpc="${GCC_PREFIX}" --with-isl="${GCC_PREFIX}"|| exit
make -j5 || exit
# make check || exit
make install || exit
cd -

#
# GCC
#

if ! test -d "${GCC_VERSION}"
then
    if ! test -f "${GCC_VERSION}.tar.bz2"
    then
        wget "ftp://ftp.uvsq.fr/pub/gcc/releases/${GCC_VERSION}/${GCC_VERSION}.tar.bz2" || exit
        tar xfvj "${GCC_VERSION}.tar.bz2" || exit
    fi
fi
mkdir "${GCC_VERSION}/build"
cd "${GCC_VERSION}/build" || exit

../configure --prefix="${GCC_PREFIX}" --with-gmp="${GCC_PREFIX}" --with-mpfr="${GCC_PREFIX}" --with-mpc="${GCC_PREFIX}" --with-isl="${GCC_PREFIX}" --with-cloog="${GCC_PREFIX}" --enable-checking=release --enable-languages=c,c++,objc,obj-c++,fortran || exit
make -j5 || exit
# make -k check || exit
make install || exit
cd -

