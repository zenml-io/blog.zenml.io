#! /bin/bash

# CONSTS

URL=${DISCORD_URL}
USERNAME_ADDON=$([ -z "$CI_ENVIRONMENT_SLUG" ] && echo "$CI_PROJECT_NAME" || echo "$CI_ENVIRONMENT_SLUG")
COMMIT_DESTINATION=$([ -z "$CI_ENVIRONMENT_URL" ] && echo "${CI_PROJECT_NAME}/${CI_COMMIT_REF_NAME}" || echo "$CI_ENVIRONMENT_URL")


# Assemble payload

PAYLOAD=$(cat <<EOF
{"content": "New deployment to ${COMMIT_DESTINATION}. Commit: $(echo $CI_COMMIT_MESSAGE  | sed 's/"/\\"/g')",
"username": "GITLAB CI - ${USERNAME_ADDON}"}
EOF
)

echo ${PAYLOAD}

curl -H "Content-Type: application/json" -X POST -d "${PAYLOAD}" ${URL}
