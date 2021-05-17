local common = import '../common/common.libsonnet';
local pod = import './pod.libsonnet';

{
  default(name, image, port, replicas=null, ns=null)::
    common.apiVersion('apps/v1')
    + common.metadata(name, ns)
    + {
      kind: 'Deployment',
      spec: $.spec(name, image, port, replicas),
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
        spec: pod.spec(name, image, port),
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

    // by default, this will update the first container
    // pass it the name of the container to update to only update this one
    // pass '*' as name to update all containers
    overrideContainer(overrides, name=null)::
      assert std.isObject(overrides);
      assert std.type(name) == 'null' || std.isString(name);
      {
        spec+: {
          template+: {
            spec+: {
              containers: (
                if name == null
                then
                  std.mapWithIndex(function(i, container) if i == 0 then container + overrides else container, super.containers)  // only the first container
                else
                  if name == '*'
                  then
                    std.map(function(container) container + overrides, super.containers)  // all containers
                  else
                    std.map(function(container) if container.name == name then container + overrides else container, super.containers)  // all containers
              ),
            },
          },
        },
      },
  },
}
