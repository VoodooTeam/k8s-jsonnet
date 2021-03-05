local sa = import './authentication/sa.libsonnet';
local common = import './common/common.libsonnet';
local ing = import './ingress/ingress.libsonnet';
local irsa = import './irsa/main.libsonnet';
local svc = import './services/main.libsonnet';
local tls = import './tls/issuer.libsonnet';
local container = import './workloads/container.libsonnet';
local deploy = import './workloads/deploy.libsonnet';
local hpa = import './workloads/hpa.libsonnet';
local pod = import './workloads/pod.libsonnet';

{
  common: common,
  container: container,
  deploy: deploy,
  hpa: hpa,
  ing: ing,
  irsa: irsa,
  pod: pod,
  svc: svc,
  sa: sa,
  tls: tls,
}
