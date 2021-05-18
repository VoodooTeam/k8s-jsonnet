local apps = import '../_apps/main.libsonnet';
local container = import '../workloads/container.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';

// our "base" application, using all the default best practices
local myApp = apps.default('appName', 'appImage:v1.0');

std.objectValues(
  myApp
  {  // overrides targetting specific resources
    deploy+: super.deploy  // we update the deployment returned by the apps.app function
             + deploy.utils.overrideContainer(
               container.envFromSecret('my-secret-name')
             ),
  }
)
