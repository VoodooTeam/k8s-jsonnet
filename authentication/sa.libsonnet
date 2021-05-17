local common = import '../common/common.libsonnet';

{
  default(name, ns=null)::
    common.apiVersion('v1')
    + common.metadata(name, ns)
    + {
      kind: 'ServiceAccount',
    },
}
