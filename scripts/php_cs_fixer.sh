
IFS=$'\n'
COMMIT_SCA_FILES=($(git diff --name-only --diff-filter=ACMRTUXB origin/master ))
unset IFS
echo "${COMMIT_SCA_FILES[@]}"
./vendor/bin/php-cs-fixer fix --config=.php_cs.dist -vvv --dry-run --diff --path-mode=intersection "${COMMIT_SCA_FILES[@]}"

