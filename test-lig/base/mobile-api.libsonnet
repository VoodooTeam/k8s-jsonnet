local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'mobile-api';
local port = 8080;

{
  main(app_env, image, domain, nrAppName, firebase_env)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName, firebase_env)) } +  // inject env vars in container definition
    {
      ing: $.ingress(domain),
    },


  env_vars(app_env, nrAppName, firebase_env)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('PORT', ':' + std.toString(port)),
        k.common.keyval('APP_NAME', 'MobileAPI'),
        k.common.keyval('NR_APP_NAME', nrAppName),

        k.common.keyval('FIREBASE_PROJECT_ID', firebase_env),
        k.common.keyval('ANDROID_MIN_APPVERSION', '1.0.0'),
        k.common.keyval('IOS_MIN_APPVERSION', '1.3.0'),

        k.common.keyval('ACTIVITY_SERVICE', 'http://activity:8080'),
        k.common.keyval('GAME_SERVICE', 'http://game:8080'),
        k.common.keyval('LEADERBOARD_SERVICE', 'http://leaderboard:8080'),
        k.common.keyval('LEAGUE_SERVICE', 'http://league:8080'),
        k.common.keyval('NOTIFICATION_SERVICE', 'http://notification:8080'),
        k.common.keyval('BADGE_SERVICE', 'http://badge:8080'),
        k.common.keyval('USER_SERVICE', 'http://user:8080'),
        k.common.keyval('IAP_SERVICE', 'http://iap:8080'),
        k.common.keyval('LIG_SVC_TOURNAMENTS', 'tournaments:10000'),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
      ]
    ),

  ingress(domain)::
    k.ing.nginx_tls(
      name,
      [
        k.ing.host_paths(domain, [k.ing.path('/', name, port)]),
      ],
      shared.issuer.metadata.name
    ) + {
      metadata+: {
        annotations+: {
          'nginx.ingress.kubernetes.io/force-ssl-redirect': 'true',
          'nginx.ingress.kubernetes.io/proxy-body-size': '8m',
        },
      },
    },
}
