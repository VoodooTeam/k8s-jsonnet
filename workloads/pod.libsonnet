local common = import '../common/common.libsonnet';
local container = import './container.libsonnet';

{
  default(name, image, port=null)::
    common.apiVersion('v1')
    + common.metadata(name)
    + {
      kind: 'Pod',
      spec: $.spec(name, image, port),
    },

  spec(name, image, port)::
    {
      serviceAccountName: name,
      securityContext: {
        runAsUser: 1000,
        runAsGroup: 3000,
        fsGroup: 2000,
      },
      containers: [
        container.spec(name, image, port),
      ],
    },
}
