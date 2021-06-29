// generation of [Irsa-operator](https://github.com/VoodooTeam/irsa-operator) manifests

local c = import '../../common/common.libsonnet';

{

  default(saName, statements, ns=null)::
    assert std.isArray(statements);

    c.apiVersion('irsa.voodoo.io/v1alpha1')
    + c.metadata.new(saName, ns)
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

  // statements takes a list of resources and the actions to allow on all of them
  statements(resources, actions)::
    assert std.isArray(resources);
    assert std.isArray(actions);
    [
      $.statement(r, actions)
      for r in resources
    ],
}
