{
  _app: import './_app/main.libsonnet',
  common: import '../common/common.libsonnet',
  container: import './workloads/container.libsonnet',
  deploy: import './workloads/deploy.libsonnet',
  hpa: import './workloads/hpa.libsonnet',
  ingress: import './ingress/ingress.libsonnet',
  pod: import './workloads/pod.libsonnet',
  svc: import './services/main.libsonnet',
  sa: import './authentication/sa.libsonnet',
  tls: import './tls/issuer.libsonnet',
}
