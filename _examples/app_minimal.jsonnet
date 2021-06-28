std.map(
  function(k)
    std.objectValues(
      k._app.default('appName', 'appImage:v1.0'),
    ),
  [
    (import '../1.20/main.libsonnet'),
    (import '../1.21/main.libsonnet'),
  ]
)
