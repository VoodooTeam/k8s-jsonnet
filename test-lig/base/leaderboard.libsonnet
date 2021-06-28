local shared = import './_shared.libsonnet';
local k = shared.k;
local irsa = import '../../crds/irsa/main.libsonnet';

{
  local name = 'leaderboard',
  local port = 8080,
  local grpc_port = 50051,

  main(app_env, image, nrAppName, redis_cluster_id)::
    k._app.default(
      name,
      image,
      port=port,
      awsPermissions=[
        irsa.statement('*', ['elasticache:DescribeReplicationGroups']),
        irsa.statement('*', ['sqs:*']),
        irsa.statement('*', ['sns:*']),
      ],
    ) +
    {
      deploy+:
        k.deploy.utils.overrideContainer(
          k.container.envLiterals(
            {
              APP_ENV: app_env,
              APP_NAME: 'LeaderboardService',
              PORT: std.toString(port),
              GRPC_PORT: std.toString(grpc_port),
              NR_APP_NAME: nrAppName,
              REDIS_CLUSTER_ID: redis_cluster_id,
              MDB_DATABASE: 'leaderboard',
            }
          ) +
          shared.nrSecretRef +
          shared.mongoSecretRef +
          {
            ports+:
              [
                k.container.port(grpc_port),
              ],
          }
        )
        + k.deploy.utils.removeAllProbes()
      ,
      svc+: {
        spec+: {
          ports+: [
            k.svc.port(grpc_port, name='grpc'),
          ],
        },
      },
    },
}
