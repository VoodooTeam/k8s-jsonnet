local k = import '../1.21/main.libsonnet';

std.objectValues(k._app.default('appName', 'appImage:v1.0'))

// or, if you like one-liners :
// std.objectValues((import '../1.20/main.libsonnet')._app.default('appName', 'appImage:v1.0'))



