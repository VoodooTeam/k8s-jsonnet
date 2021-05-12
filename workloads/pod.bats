load ../test_helpers.bats

base="(import '$BATS_TEST_DIRNAME/pod.libsonnet')"
default=$base.default

@test "pod: minimal - rendering" {
  $gen "$default('name', 'image:v1', 8000)" >/dev/null
}

@test "pod: minimal - kubeval" {
  $gen "$default('name', 'image:v1', 8000)" | $kubeval
}

@test "pod: minimal - polaris" {
  $gen "$default('name', 'image:v1', 8000)" | $polaris
}
