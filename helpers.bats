k8s=(
  ["1|20"]="(import '$BATS_TEST_DIRNAME/../1.20/main.libsonnet')"  # this is relative to the test files themselves
  ["1|21"]="(import '$BATS_TEST_DIRNAME/../1.21/main.libsonnet')"
  )
gen="jsonnet -e"
kubeval="kubeval"
kubevalIgnoreUnknown="kubeval --ignore-missing-schemas"
polaris="polaris audit --only-show-failed-tests --set-exit-code-below-score 100 --audit-path -"

jq_test() {
  jqcomm=$2' | tostring | test('\"$3\"')'
  echo "$1" | jq -e "$jqcomm"
}

