load ../../helpers.bats

base="(import '$BATS_TEST_DIRNAME/main.libsonnet')"
app=$base.default

@test "app: minimal - rendering" {
  m=$($gen "$app('name', 'image:v1')")

  jq_test "$m" '.deploy.kind' 'Deployment'
  jq_test "$m" '.svc.kind' 'Service'
  jq_test "$m" '.hpa.kind' 'HorizontalPodAutoscaler'
  jq_test "$m" '.ingress' 'null'
  jq_test "$m" '.irsa' 'null'
}

@test "app: minimal - kubeval" {
  $gen -y "std.objectValues($app('name', 'image:v1'))" | $kubeval
}

@test "app: minimal - polaris" {
  $gen -y "std.objectValues($app('name', 'image:v1'))" | $polaris
}

@test "app: irsa" {
  m=$($gen "$app('name', 'image:v1', awsPermissions=[{resource:'bla', action:['s3::List']}])")
  jq_test "$m" '.irsa.kind' 'IamRoleServiceAccount'
}

@test "app: ingress" {
  m=$($gen "$app('name', 'image:v1', domain='voodoo.io')")
  jq_test "$m" '.ingress.kind' 'Ingress'
}
