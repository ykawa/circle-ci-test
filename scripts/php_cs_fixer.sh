#!/bin/bash -eu

CIRCLECI_BRANCH_NAME="$1"
CIRCLECI_RUNNING_ON_LOCAL="${2:-true}"
BITBUCKET_BRANCH_NAME=$(git rev-parse --abbrev-ref @)

echo "CIRCLECI BRANCH NAME: ${CIRCLECI_BRANCH_NAME}"
echo "BITBUCKET BRANCH NAME: ${BITBUCKET_BRANCH_NAME}"

set +e
IFS=$'\n'
if [ "${CIRCLECI_RUNNING_ON_LOCAL}" = "true" ]; then
  COMMIT_SCA_FILES=($(git diff -p --name-only --reverse --diff-filter=d --format="" master...${BITBUCKET_BRANCH_NAME} | grep \.php$ | sort | uniq))
else
  COMMIT_SCA_FILES=($(git diff -p --name-only --reverse --diff-filter=d --format="" origin/master...origin/${BITBUCKET_BRANCH_NAME} | grep \.php$ | sort | uniq))
fi
unset IFS
set -e

if [ ${#COMMIT_SCA_FILES[@]} -eq 0 ]; then
  echo "Does not perform PHP format check."
else
  echo "${COMMIT_SCA_FILES[@]}"
  echo ""
  ./vendor/bin/php-cs-fixer fix \
    --config=.php_cs.dist \
    --stop-on-violation \
    -vvv \
    --dry-run \
    --diff \
    --path-mode=intersection \
    "${COMMIT_SCA_FILES[@]}"
fi

