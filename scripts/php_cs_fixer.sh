pwd

PROJECT_TOP_DIR=$(dirname $0)/..
cd $PROJECT_TOP_DIR

pwd

find .


IFS=$'\n'
COMMIT_SCA_FILES=($(git diff --name-only --diff-filter=ACMRTUXB origin/master ))
unset IFS
./vendor/bin/php-cs-fixer fix --config=.php_cs.dist -vvv --dry-run --diff --path-mode=intersection "${COMMIT_SCA_FILES[@]}"
