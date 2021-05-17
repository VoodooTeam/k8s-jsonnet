local common = import '../common/common.libsonnet';
local pod = import './pod.libsonnet';

{
  default(name, image, port, replicas=null, ns=null)::
    common.apiVersion('apps/v1')
    + common.metadata(name)
    + {
      kind: 'Deployment',
      spec: $.spec(name, image, port, replicas),
    },

  spec(name, image, port, replicas)::
    {
      revisionHistoryLimit: 2,
      replicas: replicas,
      selector: {
        matchLabels: {
          app: name,
        },
      },
      template: {
        metadata: {
          labels: {
            app: name,
          },
        },
        spec: pod.spec(name, image, port),
      },
    },

  utils:: {
    // add this after a deployment
    removeAllSecurityContexts():: {
      spec+: {
        template+: {
          spec+: {
            securityContext:: {},
            containers: [
              x { securityContext:: {} }
              for x in super.containers
            ],
          },
        },
      },
    },

    updateContainer(containerName, container):: {
      spec+: {
        template+: {
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
  },
}
