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

  utils:: {
    updateContainer(containerName, container):: {
      spec+: {
        containers: [
          if x.name == containerName
          then x + container
          else x
          for x in super.containers
        ],
      },
    },
  },
}
