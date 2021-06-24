local k = import '../1.20/main.libsonnet';

// our "base" application, using all the default best practices
local myApp = k._app.default('appName', 'appImage:v1.0');

std.objectValues(
  myApp
  {  // overrides targetting specific resources
    deploy+: super.deploy  // we update the deployment returned by the apps.app function
             + k.deploy.utils.overrideContainer(
               k.container.envFromSecret('my-secret-name')
             ),
  }
)
