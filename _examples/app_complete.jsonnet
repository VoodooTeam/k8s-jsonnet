std.map(
  function(k)
    std.objectValues(
      k._app.default(
        'appName',
        'appImage:v1.0',
        domain='myapp.voodoo.io',
        ns='my-hardcoded-ns',
        awsPermissions=[{ resource: 'arn:aws:s3:::my-s3-bucket', action: ['s3::List*'] }]
      ),
    ),
  [
    (import '../1.20/main.libsonnet'),
    (import '../1.21/main.libsonnet'),
  ]
)
