local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'championships',
  local port = 50051,

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
              APP_NAME: 'ChampionshipService',
              GRPC_PORT: std.toString(port),
              NR_APP_NAME: nrAppName,
              LIG_SVC_LEADERBOARDS: 'leaderboard:50051',
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef,
        )
        + k.deploy.utils.removeAllProbes(),
    },
}
