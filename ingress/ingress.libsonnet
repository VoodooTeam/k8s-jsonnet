local common = import '../common/common.libsonnet';

// paths must be a list of objects with keys :
// route(string), svcName(string), svcPort(string|number), routeType(optional, string)
{
  nginx(name, domain, paths, clusterIssuer='letsencrypt-production', ns=null)::
    assert std.length(paths) > 0;
    assert std.objectHas(paths[0], 'route');
    assert std.objectHas(paths[0], 'svcName');
    assert std.objectHas(paths[0], 'svcPort');

    common.apiVersion('networking.k8s.io/v1beta1')
    + common.metadata(
      name,
      ns,
      annotations={
        'cert-manager.io/cluster-issuer': clusterIssuer,
        'kubernetes.io/tls-acme': 'true',
        'kubernetes.io/ingress.class': 'nginx',
      }
    )
    + {
      kind: 'Ingress',
      spec: {
        tls: [{
          hosts: [domain],
          secretName: name + '-cert',
        }],
        rules: [
          {
            host: domain,
            http: {
              paths:
                [
                  $.path(
                    p.route,
                    p.svcName,
                    p.svcPort,
                    (if std.objectHas(p, 'routeType') then p.routeType),
                  )
                  for p in paths
                ],
            },
          },
        ],
      },
    },

  path(route, svcName, svcPort, type='Prefix')::
    local _type = if type == null then 'Prefix' else type;
    {
      path: route,
      pathType: _type,
      backend: {
        service: {
          name: svcName,
          port: (
            if std.isNumber(svcPort)
            then { number: svcPort }
            else { name: svcPort }
          ),
        },
      },
    },
}
