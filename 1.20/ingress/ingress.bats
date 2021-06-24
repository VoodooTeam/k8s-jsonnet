load ../../helpers.bats

base="(import '$BATS_TEST_DIRNAME/ingress.libsonnet')"
nginx=$base.nginx

@test "ingress: nginx - rendering" {
  m=$($gen "$nginx('name', 'domain.com', [{route: '/', svcName: 'my-svc', svcPort: 8080}])")

  jq_test "$m" '.spec.rules[0].http.paths[0].backend.service.port.number' '8080'
}

@test "ingress: nginx - rendering port name" {
  m=$($gen "$nginx('name', 'domain.com', [{route: '/', svcName: 'my-svc', svcPort: 'http', routeType: 'Exact'}])") 

  jq_test "$m" '.spec.rules[0].http.paths[0].backend.service.port.name' 'http'
}

@test "ingress: nginx - kubeval" {
  $gen "$nginx('name', 'domain.com', [{route: '/', svcName: 'my-svc', svcPort: 8080}])" | $kubeval
}

@test "ingress: nginx - rendering complete" {
  m=$($gen "$nginx('name', 'domain.com', [{route: '/', svcName: 'my-svc', svcPort: 8080}], ns='ns')")

  jq_test "$m" '.metadata.namespace' 'ns'
}
