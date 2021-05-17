local pkgs = import '../_pkgs/main.libsonnet';

std.objectValues(
  pkgs.app(
    'appName',
    'appImage:v1.0',
    domain='myapp.voodoo.io',
    ns='my-hardcoded-ns',
    awsPermissions=[{ resource: 'arn:aws:s3:::my-s3-bucket', action: ['s3::List*'] }]
  )
)
