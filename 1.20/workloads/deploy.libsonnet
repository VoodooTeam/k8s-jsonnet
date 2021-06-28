local c = import '../../common/common.libsonnet';

{
  deps(k):: {
    local deploy = self,

    default(name, image, port, replicas=null, ns=null)::
      c.apiVersion('apps/v1')
      + c.metadata.new(name, ns)
      + {
        kind: 'Deployment',
        spec: deploy.spec(name, image, port, replicas),
      },

    spec(name, image, port, replicas)::
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
          spec: k.pod.spec(name, image, port),
        },
      } + (if replicas != null then { replicas: replicas } else {}),

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

      // by default, this will update all containers
      // pass it the name of the container to update to only update this one
      overrideContainer(overrides, name=null)::
        assert std.isObject(overrides);
        assert std.type(name) == 'null' || std.isString(name);
        {
          spec+: {
            template+: {
              spec+: {
                containers: (
                  std.map(function(container)
                            if name == null || container.name == name
                            then container + overrides
                            else container,
                          super.containers)
                ),
              },
            },
          },
        },
    },
  },
}
