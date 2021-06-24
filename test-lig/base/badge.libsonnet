local c = import '../../common/common.libsonnet';
local shared = import './_shared.libsonnet';
local k = shared.k;
local irsa = import '../../crds/irsa/main.libsonnet';

local name = 'badge';
local port = 8080;

{
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
      ]
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              PORT: ':' + std.toString(port),
              APP_NAME: 'BadgeService',
              NR_APP_NAME: nrAppName,
              S3_BUCKET_PUBLIC: asset_config.bucket_name,
              IMAGE_HOST_NAME: asset_config.url,
              GAME_SERVICE: 'http://game:8080',
              LEAGUE_SERVICE: 'http://league:8080',
            }
          ) +
          shared.nrSecretRef +
          shared.mongoSecretRef,
        ),
    },
}
