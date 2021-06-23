local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'tournaments';
local port = 10000;

{
  main(app_env, image, nrAppName)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName, name)) },

  env_vars(app_env, nrAppName, name)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('PORT', std.toString(port)),
        k.common.keyval('APP_NAME', 'TournamentService'),
        k.common.keyval('NR_APP_NAME', nrAppName),
        k.common.keyval('MDB_DATABASE', name),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
        shared.mongoSecretRef,
      ]
    ),
}
