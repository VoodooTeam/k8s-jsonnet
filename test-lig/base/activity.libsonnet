local app = import '../../_apps/main.libsonnet';
local common = import '../../common/common.libsonnet';
local irsa = import '../../irsa/main.libsonnet';
local container = import '../../workloads/container.libsonnet';
local deploy = import '../../workloads/deploy.libsonnet';
local shared = import './_shared.libsonnet';

local name = 'activity';
local port = 8080;

{
  main(app_env, image, nrAppName)::
    app.default(
      name,
      image,
      port=port,
      awsPermissions=[irsa.statement('*', ['sqs:*'])]
    ) +
    {
      deploy+:
        deploy.utils.overrideContainer(
          container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'ActivityService',
              NR_APP_NAME: nrAppName,
              USER_SERVICE: 'http://user:8080',
            }
          ) +
          shared.nrSecretRef +
          shared.mongoSecretRef,
        ),
    },
}
