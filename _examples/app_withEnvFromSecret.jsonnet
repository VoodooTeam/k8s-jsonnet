local pkgs = import '../_pkgs/main.libsonnet';
local container = import '../workloads/container.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';

// our "base" application, using all the default best practices
local myApp = pkgs.app(
  'appName',
  'appImage:v1.0',
  domain='myapp.voodoo.io',
  ns='my-hardcoded-namespace',
  awsPermissions=[{ resource: 'arn:aws:s3:::my-s3-bucket', action: ['s3::List*'] }]
);

std.objectValues(
  myApp
  {  // overrides targetting specific resources
    deploy+: super.deploy  // we update the deployment returned by the pkgs.app function
             + deploy.utils.overrideContainer(
               container.envFromSecret('my-secret-name')
             ),
  }
)
