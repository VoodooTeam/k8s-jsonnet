load ../helpers.bats

@test "== pod tests (all k8s versions) ==" {}
for v in "${!k8s[@]}"
do
  @test "pod: minimal - rendering" {
    $gen "${k8s[$v]}.pod.default('name', 'image:v1', 8000)" >/dev/null
  }
  
  @test "pod: minimal - kubeval" {
    $gen "${k8s[$v]}.pod.default('name', 'image:v1', 8000)" | $kubeval
  }
  
  @test "pod: minimal - polaris" {
    $gen "${k8s[$v]}.pod.default('name', 'image:v1', 8000)" | $polaris
  }
done
