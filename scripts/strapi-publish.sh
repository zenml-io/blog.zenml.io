#! /bin/bash
set -e

array=(${CHANGED_FILES// / })

arraylength=${#array[@]}

foundfile="" 
images=()

for (( i=0; i<${arraylength}; i++ ));
do
  if [ -z "${foundfile}" ]; then
    filetype="${array[$i]##*.}"
    if [[ "$filetype" == "md" ]]; then
      foundfile=${array[$i]}
      break
    fi

    if [[ "$filetype" == "png" || "$filetype" == "jpg" || "$filetype" == "jpeg" ]]; then
      images+=("./${array[$i]}")
    fi
  fi
done

imagearraylength=${#images[@]}

# if [ -z "${foundfile}" ]; then
#   echo "ERROR: No MD File changed"
#   exit 1
# fi

# value=`cat ${foundfile}`

# markdown=$(echo "${value##*---}")

# author=$(echo ${value} | awk -v FS="(author: | title:)" '{print $2}')
# title=$(echo ${value} | awk -v FS="(title: | description:)" '{print $2}')
# description=$(echo ${value} | awk -v FS="(description: \"|\" publish_date:)" '{print $2}')
# date=$(echo ${value} | awk -v FS="(date: | tags:)" '{print $2}')

# slug=$(echo $title | iconv -t ascii//TRANSLIT | sed -r s/[~\^]+//g | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z)

# markdown_without_line_break=${markdown//$'\n'/\\\\n}

# PAYLOAD=$(cat <<EOF
# {
#   "data": {
#     "author": "$( echo ${author})", 
#     "title": "$( echo ${title})", 
#     "description": "$( echo ${description})",
#     "seoTitle": "$( echo ${title})",
#     "slug": "$( echo ${slug})",
#     "blogContent": "{\"markdown\": \"$( echo ${markdown_without_line_break})\"}"
#   }
# }
# EOF
# )

# echo "$PAYLOAD"

# curl -H "Content-Type: application/json" -H "Authorization: Bearer ${STRAPI_TOKEN}" -X POST -d "${PAYLOAD}" ${STRAPI_URL}

echo $images

for (( i=0; i<${imagearraylength}; i++ ));
do
  curl -i -X POST -H "Content-Type: multipart/form-data" -H "Authorization: Bearer ${STRAPI_TOKEN}" -F "files=@"${file} https://zenml-strapi-production.clients-mvst.co/api/upload
done
