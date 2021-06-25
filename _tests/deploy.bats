load ../helpers.bats

@test "== deploy tests (all k8s versions) ==" {}
for v in "${!k8s[@]}"
do
  @test "deploy: minimal - rendering" {
    m=$($gen "${k8s[$v]}.deploy.default('name', 'image:v1', 8080)")
    jq_test "$m" '.kind' 'Deployment'
  }

  @test "deploy: minimal - kubeval" {
    $gen "${k8s[$v]}.deploy.default('name', 'image:v1', 8080)" | $kubeval
  }
  
  @test "deploy: minimal - polaris" {
    $gen "${k8s[$v]}.deploy.default('name', 'image:v1', 8080)" | $polaris
  }
  
  @test "deploy: complete - rendering" {
    m=$($gen "${k8s[$v]}.deploy.default('name', 'image:v1', 8080, replicas=12, ns='my-ns')")
  
    echo $m | kubeval 
    jq_test "$m" '.metadata.namespace' 'my-ns'
    jq_test "$m" '.spec.replicas' '12'
  }
done

