local shared = import './_shared.libsonnet';
local activity = import './activity.libsonnet';
local adminAPI = import './admin-api.libsonnet';
local badge = import './badge.libsonnet';
local championships = import './championships.libsonnet';
local game = import './game.libsonnet';
local iap = import './iap.libsonnet';
local leaderboard = import './leaderboard.libsonnet';
local league = import './league.libsonnet';
local mobileAPI = import './mobile-api.libsonnet';
local notification = import './notification.libsonnet';
local orchestrator = import './orchestrator.libsonnet';
local scoreHistory = import './score-history.libsonnet';
local tournaments = import './tournaments.libsonnet';
local user = import './user.libsonnet';

{
  removeContainerServiceLimits(container):: container { resources+: { limits:: null } },
  removeAppResourceLimits(_, obj)::
    if std.objectHas(obj, 'deploy') then
      obj {
        deploy+: { spec+: { template+: { spec+: {
          containers: std.map($.removeContainerServiceLimits, obj.deploy.spec.template.spec.containers),
        } } } },
      }
    else obj,

  services(images, env, domains, assets, nrAppName, redis_cluster, firebase_env):: std.mapWithKey($.removeAppResourceLimits, {
    // each resource from base is instanciated with the corresponding image
    activity: activity.main(env, images.activity, nrAppName.activity),
    adminAPI: adminAPI.main(env, images.adminAPI, domains.adminAPI, nrAppName.adminAPI, firebase_env),
    badge: badge.main(env, images.badge, nrAppName.badge, assets.badge),
    championships: championships.main(env, images.championships, nrAppName.championships),
    game: game.main(env, images.game, nrAppName.game, assets.game),
    iap: iap.main(env, images.iap, nrAppName.iap, assets.iap),
    leaderboard: leaderboard.main(env, images.leaderboard, nrAppName.leaderboard, redis_cluster.leaderboard),
    league: league.main(env, images.league, nrAppName.league, assets.league),
    mobileAPI: mobileAPI.main(env, images.mobileAPI, domains.mobileAPI, nrAppName.mobileAPI, firebase_env),
    notification: notification.main(env, images.notification, nrAppName.notification),
    orchestrator: orchestrator.main(env, images.orchestrator, nrAppName.orchestrator),
    scoreHistory: scoreHistory.main(env, images.scoreHistory, nrAppName.scoreHistory),
    tournaments: tournaments.main(env, images.tournaments, nrAppName.tournaments),
    user: user.main(env, images.user, nrAppName.user, assets.user),
  }),

}
