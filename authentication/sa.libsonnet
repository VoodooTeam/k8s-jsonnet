local common = import '../common/common.libsonnet';

{
  default(name)::
    common.apiVersion('v1')
    + common.metadata(name)
    + {
      kind: 'ServiceAccount',
    },
}
