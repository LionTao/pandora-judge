#!/bin/bash
root=$(pwd)

rm -rf template
rm -rf pandora_temp_*

git clone -q git@gitee.com:SUMSC/Pandora-2nd-template.git template


while read id_tag repo
do
    cd $PWD
    dir="${id_tag}_pandora"
#    echo "Now judging $id_tag repo is : ${repo}"

    if [[ "$repo" == No* ]];then
        echo "${id_tag} haven't submitted yet!"
        continue

    else
        echo "Cloneing..."
        git clone -q "${repo}" "pandora_temp_${id_tag}"
    fi
    scene="/tmp/${id_tag}"
    rm -rf ${scene}
    mkdir -p "${scene}"
    cp -R "${root}/template/tests" "${scene}/tests"
    cp -R "${root}/pandora_temp_${id_tag}/pandora" "${scene}/pandora"
    cd "${scene}/tests"
    python3 grader.py ${id_tag} > /dev/null
    cd ${root}
    echo "${id_tag} finished!"


done < id_all.txt