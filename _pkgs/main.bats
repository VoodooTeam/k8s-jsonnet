load ../_test_utils/helpers.bats

base="(import '$BATS_TEST_DIRNAME/main.libsonnet')"
app=$base.app

@test "app: minimal - rendering" {
  $gen "std.objectValues($app('name', 'image:v1'))"  >/dev/null
}

@test "app: minimal - kubeval" {
  $gen -y "std.objectValues($app('name', 'image:v1'))" | $kubeval
}

@test "app: minimal - polaris" {
  $gen -y "std.objectValues($app('name', 'image:v1'))" | $polaris
}

