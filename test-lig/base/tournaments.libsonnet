local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'tournaments',
  local port = 10000,

  main(app_env, image, nrAppName)::
    k._app.default(
      name,
      image,
      port=port,
    )
    + {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: std.toString(port),
              APP_NAME: 'TournamentService',
              NR_APP_NAME: nrAppName,
              MDB_DATABASE: name,
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef,
        )
        + k.deploy.utils.removeAllProbes(),
    },
}
