local irsa = import '../../crds/irsa/main.libsonnet';
local shared = import './_shared.libsonnet';
local k = shared.k;

{
  local name = 'iap',
  local port = 8080,

  main(app_env, image, nrAppName, asset_config)::
    k._app.default(
      name,
      image,
      port=port,
      awsPermissions=[
        irsa.statement('*', ['sqs:*']),
        irsa.statement('*', ['sns:*']),
        irsa.statement('arn:aws:s3:::' + asset_config.bucket_name + '/*', [
          's3:GetObject',
          's3:GetObjectAcl',
          's3:PutObject',
          's3:PutObjectAcl',
          's3:DeleteObject',
        ]),
      ],
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'IAPService',
              NR_APP_NAME: nrAppName,
              S3_BUCKET_PUBLIC: asset_config.bucket_name,
              IMAGE_HOST_NAME: asset_config.url,
            }
          )
          + shared.nrSecretRef
          + shared.mongoSecretRef
          + k.container.envFromSecret('in-app-purchase'),
        )
        + k.deploy.utils.removeAllProbes(),
    },
}
