local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'leaderboard';
local port = 8080;
local grpc_port = 50051;

{
  main(app_env, image, nrAppName, redis_cluster_id)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName, redis_cluster_id)) } +  // inject env vars in container definition
    $.deploy_add_ports(image, [grpc_port]) +  // inject env vars in container definition
    { sa: $.irsa } +  // we override the original serviceAccount definition with irsa
    { svc: k.svc.base(name, [k.svc.port(port, name='http'), k.svc.port(grpc_port, name='grpc')]) },

  irsa::
    k.irsa.irsa(name, [
      k.irsa.statement('*', ['elasticache:DescribeReplicationGroups']),
      k.irsa.statement('*', ['sqs:*']),
      k.irsa.statement('*', ['sns:*']),
    ]),

  env_vars(app_env, nrAppName, redis_cluster_id)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('APP_NAME', 'LeaderboardService'),
        k.common.keyval('PORT', std.toString(port)),
        k.common.keyval('GRPC_PORT', std.toString(grpc_port)),
        k.common.keyval('NR_APP_NAME', nrAppName),
        k.common.keyval('REDIS_CLUSTER_ID', redis_cluster_id),
        k.common.keyval('MDB_DATABASE', 'leaderboard'),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
        shared.mongoSecretRef,
      ]
    ),

  deploy_add_ports(image, ports):: {
    assert std.isArray(ports),
    assert std.length(ports) > 0,
    assert std.length(ports) == 1
           || std.length(std.filter(function(p) p.name == null, ports)) == 0,

    deploy+: {
      spec+: {
        template+: {
          spec+: {
            containers: [
              if x.image == image
              then x { ports+: std.map($.deploy_port, ports) }
              else x
              for x in super.containers
            ],
          },
        },
      },
    },
  },

  deploy_port(containerPort, name=null)::
    {
      containerPort: containerPort,
      assert containerPort > 0 && containerPort < 65536,
    }
    + (if name != null then { name: name } else {}),
}
