local pkgs = import '../_pkgs/main.libsonnet';
local container = import '../workloads/container.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';


std.objectValues(
  pkgs.app(  // our "base" application
    'appName',
    'appImage:v1.0',
    domain='myapp.voodoo.io',
    ns='my-hardcoded-ns',
    awsPermissions=[{ resource: 'arn:aws:s3:::my-s3-bucket', action: ['s3::List*'] }]
  )
  {  // overrides targetting specific resources
    deploy+: super.deploy  // we update the deployment returned by the pkgs.app function
             + deploy.utils.overrideContainer(container.envFromSecret('my-secret-name')),
  }
)
