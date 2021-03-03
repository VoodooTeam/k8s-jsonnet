local common = import '../common/common.libsonnet';

{

  base(name, ports, selector={})::
    assert std.isArray(ports);
    assert std.length(ports) > 0;
    assert std.length(ports) == 1
           || std.length(std.filter(function(p) p.name == null, ports)) == 0;

    common.apiVersion('v1')
    + { kind: 'Service' }
    + common.metadata(name)
    + {
      spec: {
        selector: if selector == {} then { app: name } else selector,
        ports: ports,
      },
    },

  port(port, targetPort=null, name=null)::
    {
      port: port,
    }
    + (if targetPort != null then { targetPort: targetPort } else {})
    + (if name != null then { name: name } else {}),
}
