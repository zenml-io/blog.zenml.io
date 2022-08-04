#! /bin/bash
set -e

array=(${CHANGED_FILES// / })

arraylength=${#array[@]}

echo $array
echo $arraylength

foundfile="" 

for (( i=0; i<${arraylength}; i++ ));
do
  if [ -z "${foundfile}" ]; then
    filetype="${array[$i]##*.}"
    if [[ "$filetype" == "md" ]]; then
      foundfile=${array[$i]}
      break
    fi
  fi
done


if [ -z "${foundfile}" ]; then
  echo "ERROR: No MD File changed"
  exit 1
fi

value=`cat ${foundfile}`

markdown="${value##*---}"

author=$(echo "${value}" | awk -v FS="(author: | title:)" '{print $2}')
title=$(echo "${value}" | awk -v FS="(title: | description:)" '{print $2}')
description=$(echo "${value}" | awk -v FS="(description: \"|\" publish_date:)" '{print $2}')
date=$(echo "${value}" | awk -v FS="(date: | tags:)" '{print $2}')

slug=$(echo "$title" | iconv -t ascii//TRANSLIT | sed -r s/[~\^]+//g | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z)

PAYLOAD=$(cat <<EOF
{
  "data": {
    "author": "$( echo ${author})", 
    "title": "$( echo ${title})", 
    "description": "$( echo ${description})",
    "date": "$( echo ${date})",
    "seoTitle": "$( echo ${author})",
    "slug": "$( echo ${slug})",
    "blogContent": "{\"markdown\": \"$( echo ${markdown})\"}"
  }
}
EOF
)

echo $PAYLOAD

curl -H "Content-Type: application/json, Authorization: Bearer ${STRAPI_TOKEN}" -X POST -d "${PAYLOAD}" ${STRAPI_URL}
