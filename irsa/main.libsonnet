local common = import '../common/common.libsonnet';

{

  statement(resource, actions=[])::
    {
      resource: resource,
      action: actions,
    },

  irsa(saName, statements=[])::
    common.apiVersion('irsa.voodoo.io/v1alpha1')
    + common.metadata(saName)
    + {
      kind: 'IamRoleServiceAccount',
    }
    + {
      spec: {
        policy: {
          statement: statements,
        },
      },
    },
}
