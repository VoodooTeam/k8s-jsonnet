local base = import '../base/_main.libsonnet';
local assets = import './_assets.libsonnet';
local images = import './_images.libsonnet';

{
  // all the services.
  // at this point, they can still be targetted individually at .svcName.resourceType
  // and overriden
  output:: base.services(
    images,
    env='dev',
    domains={
      adminAPI: 'lig-admin-api.dev-vlbapps.com',
      mobileAPI: 'lig-mobile-api.dev-vlbapps.com',
    },
    assets=assets.withDomain('dev-lig-app.com'),
    nrAppName={
      activity: 'GP-Lig-Activity-Service-dev',
      adminAPI: 'GP-Lig-Admin-API-dev',
      badge: 'GP-Lig-Badge-Service-dev',
      championships: 'GP-Lig-Championship-Service-dev',
      game: 'GP-Lig-Game-Service-dev',
      leaderboard: 'GP-Lig-Leaderboard-Service-dev',
      league: 'GP-Lig-League-Service-dev',
      mobileAPI: 'GP-Lig-Mobile-API-dev',
      notification: 'GP-Lig-Notification-Service-dev',
      orchestrator: 'GP-Lig-Orchestrator-Service-dev',
      scoreHistory: 'GP-Lig-Score-History-Service-dev',
      tournaments: 'GP-Lig-Tournament-Service-dev',
      user: 'GP-Lig-User-Service-dev',
      iap: 'GP-Lig-IAP-Service-dev',
    },
    redis_cluster={
      leaderboard: 'lig-leaderboard-dev',
    },
    firebase_env='ligdev'
  ),
}
