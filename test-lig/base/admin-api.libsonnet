local c = import '../../common/common.libsonnet';
local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'admin-api',
  local port = 8080,

  main(app_env, image, domain, nrAppName, firebase_env)::
    k._app.default(
      name,
      image,
      port=port,
      domain=domain
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'AdminAPI',
              NR_APP_NAME: nrAppName,
              FIREBASE_PROJECT_ID: firebase_env,
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef
          + k.container.envFromSecret(name),
        ),

      ingress+: c.metadata.addAnnotations(
        {
          'nginx.ingress.kubernetes.io/enable-cors': 'true',
          'nginx.ingress.kubernetes.io/cors-allow-methods': 'PUT, GET, POST, DELETE, PATCH, OPTIONS',
          'nginx.ingress.kubernetes.io/cors-allow-headers': 'DNT,X-CustomHeader,X-LANG,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,X-Api-Key,X-Device-Id,Access-Control-Allow-Origin,bearer,service',
          'nginx.ingress.kubernetes.io/cors-allow-origin': '*',
          'nginx.ingress.kubernetes.io/force-ssl-redirect': 'true',
          'nginx.ingress.kubernetes.io/proxy-body-size': '8m',
        },
      ),
    },
}
