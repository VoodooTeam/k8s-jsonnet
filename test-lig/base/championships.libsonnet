local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'championships';
local port = 50051;

{
  main(app_env, image, nrAppName)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName)) },  // inject env object to container definition

  env_vars(app_env, nrAppName)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('APP_NAME', 'ChampionshipService'),
        k.common.keyval('GRPC_PORT', std.toString(port)),
        k.common.keyval('NR_APP_NAME', nrAppName),
        k.common.keyval('LIG_SVC_LEADERBOARDS', 'leaderboard:50051'),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
        shared.mongoSecretRef,
      ]
    ),
}
