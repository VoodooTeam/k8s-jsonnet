load ../helpers.bats

@test "example: app_minimal" {
  m=$(jsonnet -y $BATS_TEST_DIRNAME/app_minimal.jsonnet)
  echo $m | $kubeval
}

@test "example: app_complete" {
  m=$(jsonnet -y $BATS_TEST_DIRNAME/app_complete.jsonnet)
  echo $m | $kubeval
}

@test "example: app_withEnvFromSecret" {
  m=$(jsonnet -y $BATS_TEST_DIRNAME/app_withEnvFromSecret.jsonnet)
  echo $m | $kubeval
}

