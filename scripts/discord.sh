#! /bin/bash
set -e

# Assemble payload

PAYLOAD=$(cat <<EOF
{"content": "New deployment to https://blog.zenml.io. Commit: $(echo $COMMIT_MESSAGE  | sed 's/"/\\"/g')"}
EOF
)

echo ${PAYLOAD}

curl -H "Content-Type: application/json" -X POST -d "${PAYLOAD}" ${DISCORD_URL}
