IFS=$'\n'
COMMIT_SCA_FILES=($(git diff --name-only --diff-filter=ACMRTUXB origin/master ))
unset IFS
./vendors/bin/php-cs-fixer fix --config=.php_cs -vvv --dry-run --diff --path-mode=intersection "${COMMIT_SCA_FILES[@]}"
