local k = import '../1.21/main.libsonnet';

std.objectValues(
  k._app.default('appName', 'appImage:v1.0')
  {  // overrides the app just above, targetting specific resources
    deploy+:
      k.deploy.utils.overrideContainer(
        // overrides all containers
        // the "overrideContainer" function takes an optional "name" argument to target a specific container
        k.container.envLiterals(  // defines env vars directly
          {
            APP_NAME: 'appName',
          }
        )
        + k.container.envFromSecret('myAppSecret')  // adds the content of a secret as env vars
      )
      + k.deploy.utils.removeAllProbes(),  // removes livenessProbe & readinessProbe
  }
)
