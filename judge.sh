#!/bin/bash
set -e

root=$(pwd)

rm -rf "${root}/template"
rm -rf "${root}/pandora_temp_*"

echo '' > "${root}/summary.txt"

git clone -q https://LionTao:$(gitee-pat)@gitee.com/SUMSC/Pandora-2nd-template.git "${root}/template"

pip3 install -U --user pip
pip3 install  --user -U -r "${root}/template/requirements.txt"

cd "${root}"
python3 "${root}/get_all_user.py"

sleep 1
while read id_tag repo
do
    echo "================ ${id_tag} ================"
    cd "${root}"
    dir="${id_tag}_pandora"
    echo -e "Now judging ${id_tag} \n repo : ${repo}"

    if [[ "$repo" == No* ]];then
        echo -e "[ERROR] ${id_tag} haven't submitted yet!\n"
        continue

    else
        echo -e  "Cloneing...\c"
        git clone -q "${repo}" "${root}/pandora_temp_${id_tag}"
        if [ -d "${root}/pandora_temp_${id_tag}/pandora" ];then
            echo "ok"
        else
            echo -e "\n[ERROR] Not a standard repo!"
        fi
    fi
    scene="/tmp/${id_tag}"
    rm -rf ${scene}
    mkdir -p "${scene}"
    cp -R "${root}/template/tests" "${scene}/tests"
    cp -R "${root}/pandora_temp_${id_tag}/pandora" "${scene}/pandora"
    cd "${scene}/tests"
    python3 grader.py "${id_tag}" "${repo}" | grep "id:" >> "${root}/summary.txt"
    cd ${root}
    echo -e "[INFO] ${id_tag} finished!\n"
    rm -rf "${root}/pandora_temp_${id_tag}"
    rm -rf ${scene}


done < "${root}/id_all.txt"

cd ${root}


rm -rf "${root}/template"
rm -rf "${root}/pandora_temp_*"
rm "${root}/id_all.txt"

echo "====== SUMMARY ========"
cat "${root}/summary.txt"