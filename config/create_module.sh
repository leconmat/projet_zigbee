#! /bin/bash

function usage {
  echo "Usage : $0 module_name";
}

[[ -z $root_dir ]] && {
  root_dir="modules"
}

[[ -z $1 ]] && {
  echo "You must specify the module_name. See usage"
  usage
  exit 1
}

name=$1

dir_name=${name,,}; dir_name_uc=${name^^};

[[ -d ${PROJECT_DIR}/${root_dir}/${dir_name} ]] && { echo "ERROR: Directory already exists ${PROJECT_DIR}/${root_dir}/${dir_name}"; exit 1; }

echo "Creating the following directories and files"

echo "${PROJECT_DIR}/${root_dir}/${dir_name}"
mkdir -p ${PROJECT_DIR}/${root_dir}/${dir_name}

echo "${PROJECT_DIR}/${root_dir}/${dir_name}/rtl"
mkdir -p ${PROJECT_DIR}/${root_dir}/${dir_name}/rtl

echo "${PROJECT_DIR}/${root_dir}/${dir_name}/rtl/src"
mkdir -p ${PROJECT_DIR}/${root_dir}/${dir_name}/rtl/src

echo "${PROJECT_DIR}/${root_dir}/${dir_name}/testbench"
mkdir -p ${PROJECT_DIR}/${root_dir}/${dir_name}/testbench

echo "${PROJECT_DIR}/${root_dir}/${dir_name}/testbench/src"
mkdir -p ${PROJECT_DIR}/${root_dir}/${dir_name}/testbench/src

[[ $root_dir == "modules" ]] && sed -i -e '/# Modules directories/a export '${dir_name_uc}'_DIR=$(PROJECT_DIR)/'${root_dir}'/'${dir_name} ${PROJECT_DIR}/config/setup_ENV.design
