load ../helpers.bats

base="(import '$BATS_TEST_DIRNAME/deploy.libsonnet')"
default=$base.default

@test "deploy: minimal - rendering" {
  m=$($gen "$default('name', 'image:v1', 8080)")
  jq_test "$m" '.kind' 'Deployment'
}

@test "deploy: minimal - kubeval" {
  $gen "$default('name', 'image:v1', 8080)" | $kubeval
}

@test "deploy: minimal - polaris" {
  $gen "$default('name', 'image:v1', 8080)" | $polaris
}

@test "deploy: complete - rendering" {
  m=$($gen "$default('name', 'image:v1', 8080, replicas=12, ns='my-ns')")

  echo $m | kubeval 
  jq_test "$m" '.metadata.namespace' 'my-ns'
  jq_test "$m" '.spec.replicas' '12'
}
