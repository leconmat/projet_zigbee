#! /bin/bash

function usage {
  echo "Usage : $0 module_name";
  exit 1;
}

[[ -z $root_dir ]] && {
  root_dir="modules"
}

[[ -z $1 ]] && {
  echo "You must specify a module_name? See usage"
  usage
  exit 1
}

name=$1

[[ ! -d ${PROJECT_DIR}/${root_dir}/${name} ]] && { echo "ERROR : Directory ${PROJECT_DIR}/${root_dir}/${name} does not exist"; exit 1; }
echo -e "Do you really want to delete the following directory (y/n) ?: \n\t"${PROJECT_DIR}/${root_dir}/${name}\"
read reponse
[[ ! $reponse = "y" ]] && { exit 1; }

rm -r ${PROJECT_DIR}/${root_dir}/${name}
sed -i -e '/\/'${root_dir}'\/'${name}'/d' ${PROJECT_DIR}/config/setup_ENV.design
