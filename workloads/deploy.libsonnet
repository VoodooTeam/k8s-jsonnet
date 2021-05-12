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
}
