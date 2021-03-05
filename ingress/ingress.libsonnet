local common = import '../common/common.libsonnet';

{
  nginx_tls(name, hosts_paths=[], issuer)::
    assert std.length(hosts_paths) > 0;

    common.apiVersion('networking.k8s.io/v1beta1')
    + { kind: 'Ingress' }
    + common.metadata(
      name, null, {}, {
        'cert-manager.io/issuer': issuer,
        'kubernetes.io/tls-acme': 'true',
        'kubernetes.io/ingress.class': 'nginx',
      }
    )
    + {
      spec: {
        rules: hosts_paths,
        tls: [
          {
            hosts: [
              h.host
              for h in hosts_paths
            ],
            secretName: name + '-cert',
          },
        ],
      },
    },

  host_paths(host, paths=[]):: {
    host: host,
    http: {
      paths: paths,
    },
  },

  path(route, svcName, svcPort, type='Prefix'):: {
    path: route,
    pathType: type,
    backend: {
      serviceName: svcName,
      servicePort: svcPort,
    },
  },
}
