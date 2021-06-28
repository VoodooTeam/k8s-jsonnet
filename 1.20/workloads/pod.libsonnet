local c = import '../../common/common.libsonnet';

{
  deps(k):: {
    local pod = self,

    default(name, image, port=null)::
      c.apiVersion('v1')
      + c.metadata.new(name)
      + {
        kind: 'Pod',
        spec: pod.spec(name, image, port),
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
          k.container.spec(name, image, port),
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
  },
}
