local common = import '../common/common.libsonnet';

{

  default(saName, statements)::
    assert std.isArray(statements);

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


  statement(resource, actions)::
    assert std.isArray(actions);
    {
      resource: resource,
      action: actions,
    },

  // statements provide the same interface than terraform :
  // it takes a list of resources and the actions to allow on all of them
  statements(resources, actions)::
    assert std.isArray(resources);
    assert std.isArray(actions);
    [
      $.statement(r, actions)
      for r in resources
    ],
}
