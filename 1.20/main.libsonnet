{
  _app: (import './_app/main.libsonnet').deps(self),
  common: import '../common/common.libsonnet',
  container: import './workloads/container.libsonnet',
  deploy: (import './workloads/deploy.libsonnet').deps(self),
  hpa: import './workloads/hpa.libsonnet',
  ingress: import './ingress/ingress.libsonnet',
  pod: (import './workloads/pod.libsonnet').deps(self),
  sa: import './authentication/sa.libsonnet',
  svc: import './services/main.libsonnet',
  tls: import './tls/issuer.libsonnet',
}
