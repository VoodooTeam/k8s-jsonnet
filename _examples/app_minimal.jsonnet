local apps = import '../_apps/main.libsonnet';

std.objectValues(apps.default('appName', 'appImage:v1.0'))
