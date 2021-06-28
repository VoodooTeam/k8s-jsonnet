local irsa = import '../../crds/irsa/main.libsonnet';
local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'activity',
  local port = 8080,

  main(app_env, image, nrAppName)::
    k._app.default(
      name,
      image,
      port=port,
      awsPermissions=[irsa.statement('*', ['sqs:*'])]
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
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
