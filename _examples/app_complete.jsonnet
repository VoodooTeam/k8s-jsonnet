local pkgs = import '../_pkgs/main.libsonnet';

std.objectValues(
  pkgs.app(
    'appName',
    'appImage:v1.0',
    domain='myapp.voodoo.io',
    ns='my-hardcoded-ns'
  )
)
