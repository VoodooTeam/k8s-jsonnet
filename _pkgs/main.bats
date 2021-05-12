load ../test_helpers.bats

base="(import '$BATS_TEST_DIRNAME/main.libsonnet')"
app=$base.app

@test "app: minimal - rendering" {
  $gen "std.objectValues($app('name', 'image'))"  >/dev/null
}

@test "app: minimal - kubeval" {
  $gen -y "std.objectValues($app('name', 'image'))" | $kubeval
}

@test "app: minimal - polaris" {
  $gen -y "std.objectValues($app('name', 'image'))" | $polaris
}

