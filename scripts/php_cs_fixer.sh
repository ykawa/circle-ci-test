#!/bin/bash -eu

CIRCLECI_BRANCH_NAME="$1"
BITBUCKET_BRANCH_NAME=$(git rev-parse --abbrev-ref @)

echo "CIRCLECI BRANCH NAME: ${CIRCLECI_BRANCH_NAME}"
echo "BITBUCKET BRANCH NAME: ${BITBUCKET_BRANCH_NAME}"

set +e
IFS=$'\n'
COMMIT_SCA_FILES=($(git diff -p --name-only --reverse --format="" origin/master...origin/${BITBUCKET_BRANCH_NAME} | grep \.php$ | sort | uniq))
unset IFS
set -e

if [ ${#COMMIT_SCA_FILES[@]} -eq 0 ]; then
  echo "Does not perform PHP format check."
else
  ./vendor/bin/php-cs-fixer fix \
	  --config=.php_cs.dist \
	  --stop-on-violation \
	  -vvv \
	  --dry-run \
	  --diff \
	  --path-mode=intersection \
	  "${COMMIT_SCA_FILES[@]}"
fi

