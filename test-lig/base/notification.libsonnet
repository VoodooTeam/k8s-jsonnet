local shared = import './_shared.libsonnet';
local k = shared.k;
local irsa = import '../../crds/irsa/main.libsonnet';

{
  local name = 'notification',
  local port = 8080,

  main(app_env, image, nrAppName)::
    k._app.default(
      name,
      image,
      port=port,
      awsPermissions=[
        irsa.statement('*', ['sqs:*']),
        irsa.statement('*', ['sns:*']),
      ],
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'NotificationService',
              NR_APP_NAME: nrAppName,
            }
          ) +
          shared.nrSecretRef +
          shared.mongoSecretRef +
          k.container.envFromSecret('app-notification'),
        )
        + k.deploy.utils.removeAllSecurityContexts()
        + k.deploy.utils.removeAllProbes(),
    },
}
