local common = import '../common/common.libsonnet';

{

  base(meta, podSpec)::
    common.apiVersion('apps/v1')
    + meta
    + {
      kind: 'Deployment',
      spec: $.spec(meta.metadata.name, podSpec),
    },

  spec(name, podSpec)::
    {
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
        spec: podSpec,
      },
    },

}
