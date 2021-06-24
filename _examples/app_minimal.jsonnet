local k = import '../1.20/main.libsonnet';

std.objectValues(k._app.default('appName', 'appImage:v1.0'))
