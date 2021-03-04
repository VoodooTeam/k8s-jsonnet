local sa = import './authentication/sa.libsonnet';
local common = import './common/common.libsonnet';
local irsa = import './irsa/main.libsonnet';
local svc = import './services/main.libsonnet';
local container = import './workloads/container.libsonnet';
local deploy = import './workloads/deploy.libsonnet';
local pod = import './workloads/pod.libsonnet';

{
  common: common,
  container: container,
  deploy: deploy,
  irsa: irsa,
  pod: pod,
  svc: svc,
  sa: sa,
}
