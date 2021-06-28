local shared = import './_shared.libsonnet';
local k = shared.k;
local irsa = import '../../crds/irsa/main.libsonnet';

{
  local name = 'score-history',
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
    )
    + {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'ScoreHistoryService',
              NR_APP_NAME: nrAppName,
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef,
        )
        + k.deploy.utils.removeAllProbes(),
    },
}
//main(app_env, image, nrAppName)::
//  pkg.simple_dep_svc(name, image, port) +
//  { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName)) } +  // inject env vars in container definition
//  { sa: $.irsa },  // we override the original serviceAccount definition with irsa

//irsa::
//  k.irsa.irsa(name, [
//    k.irsa.statement('*', ['sqs:*']),
//    k.irsa.statement('*', ['sns:*']),
//  ]),

//env_vars(app_env, nrAppName)::
//  k.container.env(
//    [
//      k.common.keyval('APP_ENV', app_env),
//      k.common.keyval('PORT', ':' + std.toString(port)),
//      k.common.keyval('APP_NAME', 'ScoreHistoryService'),
//      k.common.keyval('NR_APP_NAME', nrAppName),
//    ]
//  )
//  + k.container.envFrom(
//    [
//      shared.nrSecretRef,
//      shared.mongoSecretRef,
//    ]
//  ),
//}



