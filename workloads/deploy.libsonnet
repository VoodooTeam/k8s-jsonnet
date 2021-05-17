local common = import '../common/common.libsonnet';
local pod = import './pod.libsonnet';

{
  default(name, image, port, ns=null)::
    common.apiVersion('apps/v1')
    + common.metadata(name)
    + {
      kind: 'Deployment',
      spec: $.spec(name, image, port),
    },

  spec(name, image, port)::
    {
      revisionHistoryLimit: 2,
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
