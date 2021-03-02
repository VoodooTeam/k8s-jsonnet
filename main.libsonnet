local common = import './common/common.libsonnet';
local irsa = import './irsa/main.libsonnet';
local container = import './workloads/container.libsonnet';
local deploy = import './workloads/deploy.libsonnet';
local pod = import './workloads/pod.libsonnet';

{
  common: common,
  deploy: deploy,
  pod: pod,
  container: container,
  irsa: irsa,
}
