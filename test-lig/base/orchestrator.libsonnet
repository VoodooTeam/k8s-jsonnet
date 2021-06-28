local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'orchestrator',
  local port = 8080,

  main(app_env, image, nrAppName)::
    k._app.default(
      name,
      image,
      port=port,
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'OrchestratorService',
              NR_APP_NAME: nrAppName,
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef,
        )
        + k.deploy.utils.removeAllSecurityContexts()
        + k.deploy.utils.removeAllProbes(),
    },
}
