local pkgs = import '../_pkgs/main.libsonnet';

std.objectValues(pkgs.app('appName', 'appImage:v1.0'))
