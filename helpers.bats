gen="jsonnet -e"
kubeval="kubeval"
kubevalIgnoreUnknown="kubeval --ignore-missing-schemas"
polaris="polaris audit --only-show-failed-tests --set-exit-code-below-score 100 --audit-path -"

jq_test() {
  jqcomm=$2' | tostring | test('\"$3\"')'
  echo "$1" | jq -e "$jqcomm"
}

