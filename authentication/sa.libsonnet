local common = import '../common/common.libsonnet';

{

  base(name)::
    common.apiVersion('v1')
    + common.metadata(name)
    + {
      kind: 'ServiceAccount',
    },

  // spec(name, podSpec)::
  //   {
  //     selector: {
  //       matchLabels: {
  //         app: name,
  //       },
  //     },
  //     template: {
  //       metadata: {
  //         labels: {
  //           app: name,
  //         },
  //       },
  //       spec: podSpec,
  //     },
  //   },

}
