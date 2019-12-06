#!/bin/bash -eu

#branch="$1"
branch=$(git rev-parse --abbrev-ref @)
echo "BRANCH NAME: ${branch}"

set +e
IFS=$'\n'
COMMIT_SCA_FILES=($(git diff -p --name-only --reverse --format="" origin/master...origin/${branch} | grep \.php$ | sort | uniq))
unset IFS
set -e

echo "${COMMIT_SCA_FILES[@]}"
if [ ${#COMMIT_SCA_FILES[@]} -gt 0 ]; then
  ./vendor/bin/php-cs-fixer fix --config=.php_cs.dist --stop-on-violation -vvv --dry-run --diff --path-mode=intersection "${COMMIT_SCA_FILES[@]}"
fi

