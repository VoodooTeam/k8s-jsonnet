local k = import '../1.21/main.libsonnet';

std.objectValues(
  k._app.default('appName', 'appImage:v1.0')
  {  // overrides targetting specific resources
    deploy+: super.deploy  // we update the deployment returned by the apps.app function
             + k.deploy.utils.overrideContainer(
               k.container.envFromSecret('my-secret-name')
             ),
  }
)
