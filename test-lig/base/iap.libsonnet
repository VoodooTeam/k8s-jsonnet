local shared = import './_shared.libsonnet';
local pkg = import 'k8s-jsonnet/_pkgs/main.libsonnet';
local utils = import 'k8s-jsonnet/_utils/main.libsonnet';
local k = import 'k8s-jsonnet/main.libsonnet';

local name = 'iap';
local port = 8080;

{
  main(app_env, image, nrAppName, asset_config)::
    pkg.simple_dep_svc(name, image, port) +
    { deploy+: utils.deploy_container_merge(image, $.env_vars(app_env, nrAppName, asset_config)) } +  // inject env vars in container definition
    { sa: $.irsa(asset_config.bucket_name) },  // we override the original serviceAccount definition with irsa

  irsa(s3_bucket_arn)::
    k.irsa.irsa(name, [
      k.irsa.statement('*', ['sqs:*']),
      k.irsa.statement('*', ['sns:*']),
      k.irsa.statement('arn:aws:s3:::' + s3_bucket_arn + '/*', [
        's3:GetObject',
        's3:GetObjectAcl',
        's3:PutObject',
        's3:PutObjectAcl',
        's3:DeleteObject',
      ]),
    ]),

  env_vars(app_env, nrAppName, asset_config)::
    k.container.env(
      [
        k.common.keyval('APP_ENV', app_env),
        k.common.keyval('PORT', ':' + std.toString(port)),
        k.common.keyval('APP_NAME', 'IAPService'),
        k.common.keyval('NR_APP_NAME', nrAppName),
        k.common.keyval('S3_BUCKET_PUBLIC', asset_config.bucket_name),
        k.common.keyval('IMAGE_HOST_NAME', asset_config.url),
      ]
    )
    + k.container.envFrom(
      [
        shared.nrSecretRef,
        shared.mongoSecretRef,
        k.container.secretRef('in-app-purchase'),
      ]
    ),
}
