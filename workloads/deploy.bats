load ../_test_utils/helpers.bats

base="(import '$BATS_TEST_DIRNAME/deploy.libsonnet')"
default=$base.default

@test "deploy: minimal - rendering" {
  $gen "$default('name', 'image:v1', 8080)" >/dev/null
}

@test "deploy: minimal - kubeval" {
  $gen "$default('name', 'image:v1', 8080)" | $kubeval
}

@test "deploy: minimal - polaris" {
  $gen "$default('name', 'image:v1', 8080)" | $polaris
}

@test "deploy: complete - rendering" {
  $gen "$default('name', 'image:v1', 8080, namespace='my-ns')" | $kubeval
}
