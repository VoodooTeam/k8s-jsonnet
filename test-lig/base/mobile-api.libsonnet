local c = import '../../common/common.libsonnet';
local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'mobile-api',
  local port = 8080,

  main(app_env, image, domain, nrAppName, firebase_env)::
    k._app.default(
      name,
      image,
      port=port,
      domain=domain,
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'MobileAPI',
              NR_APP_NAME: nrAppName,

              FIREBASE_PROJECT_ID: firebase_env,
              ANDROID_MIN_APPVERSION: '1.0.0',
              IOS_MIN_APPVERSION: '1.3.0',

              ACTIVITY_SERVICE: 'http://activity:8080',
              GAME_SERVICE: 'http://game:8080',
              LEADERBOARD_SERVICE: 'http://leaderboard:8080',
              LEAGUE_SERVICE: 'http://league:8080',
              NOTIFICATION_SERVICE: 'http://notification:8080',
              BADGE_SERVICE: 'http://badge:8080',
              USER_SERVICE: 'http://user:8080',
              IAP_SERVICE: 'http://iap:8080',
              LIG_SVC_TOURNAMENTS: 'tournaments:10000',
            }
          ) +
          shared.nrSecretRef
        )
        + k.deploy.utils.removeAllProbes(),

      ingress+: c.metadata.addAnnotations(
        {
          'nginx.ingress.kubernetes.io/force-ssl-redirect': 'true',
          'nginx.ingress.kubernetes.io/proxy-body-size': '8m',
        }
      ),
    },
}
