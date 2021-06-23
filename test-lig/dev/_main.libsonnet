local base = import '../base/_main.libsonnet';
local assets = import './_assets.libsonnet';
local images = import './_images.libsonnet';
local nrAppName = import './_nrAppName.libsonnet';

local env = 'dev';

{
  // all the services.
  // at this point, they can still be targetted individually at .svcName.resourceType
  // and overriden
  output:: base.services(
    images,
    env,
    {
      adminAPI: 'lig-admin-api.dev-vlbapps.com',
      mobileAPI: 'lig-mobile-api.dev-vlbapps.com',
    },
    assets.withDomain('dev-lig-app.com'),
    nrAppName,
    {
      leaderboard: 'lig-leaderboard-dev',
    },
    'ligdev'
  ),
}
