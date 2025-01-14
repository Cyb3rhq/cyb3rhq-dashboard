#!/bin/bash

# Cyb3rhq package builder
# Copyright (C) 2021, Cyb3rhq Inc.
#
# This program is a free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License (version 2) as published by the FSF - Free Software
# Foundation.

set -e

# Script parameters to build the package
target="cyb3rhq-dashboard"
architecture=$1
revision=$2
version=$3
commit_sha=$4
is_production=$5
directory_base="/usr/share/cyb3rhq-dashboard"

# Build directories
build_dir=/build
pkg_name="${target}-${version}"
pkg_path="${build_dir}/${target}"
source_dir="${pkg_path}/${pkg_name}"
deb_file="${target}_${version}-${revision}_${architecture}.deb"
final_name="${target}_${version}-${revision}_${architecture}_${commit_sha}.deb"

mkdir -p ${source_dir}/debian

# Including spec file
cp -r /root/build-packages/deb/debian/* ${source_dir}/debian/

# Generating directory structure to build the .deb package
cd ${build_dir}/${target} && tar -czf ${pkg_name}.orig.tar.gz "${pkg_name}"

# Configure the package with the different parameters
sed -i "s:VERSION:${version}:g" ${source_dir}/debian/changelog
sed -i "s:RELEASE:${revision}:g" ${source_dir}/debian/changelog
sed -i "s:export INSTALLATION_DIR=.*:export INSTALLATION_DIR=${directory_base}:g" ${source_dir}/debian/rules

# Installing build dependencies
cd ${source_dir}
mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y"

# Build package
debuild --no-lintian -b -uc -us \
    -eINSTALLATION_DIR="${directory_base}" \
    -eVERSION="${version}" \
    -eREVISION="${revision}"

cd ${pkg_path} && sha512sum ${deb_file} >/tmp/${deb_file}.sha512

if [ "${is_production}" = "no" ]; then
  mv ${pkg_path}/${deb_file} /tmp/${final_name}
  mv /tmp/${deb_file}.sha512 /tmp/${final_name}.sha512
else
  mv ${pkg_path}/${deb_file} /tmp/
fi
