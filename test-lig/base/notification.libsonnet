local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'notification';
local port = 8080;

{
  main(app_env, image, nrAppName)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName)) } +  // inject env vars in container definition
    { deploy+: utils.deploy_root_permissions() } +  // give root permissions
    {
      sa: $.irsa,  // we override the original serviceAccount definition with irsa
    },


  irsa::
    k.irsa.irsa(name, [
      k.irsa.statement('*', ['sqs:*']),
      k.irsa.statement('*', ['sns:*']),
    ]),

  env_vars(app_env, nrAppName)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('PORT', ':' + std.toString(port)),
        k.common.keyval('APP_NAME', 'NotificationService'),
        k.common.keyval('NR_APP_NAME', nrAppName),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
        shared.mongoSecretRef,
        k.container.secretRef('app-notification'),
      ]
    ),
}
