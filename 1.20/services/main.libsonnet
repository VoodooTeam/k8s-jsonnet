local c = import '../../common/common.libsonnet';

{

  default(name, ports, selector=null, ns=null)::
    assert std.isArray(ports);
    assert std.length(ports) > 0;
    assert std.length(ports) == 1
           || std.length(std.filter(function(p) p.name == null, ports)) == 0;

    c.apiVersion('v1')
    + { kind: 'Service' }
    + c.metadata.new(name, ns)
    + {
      spec: {
        selector: if selector != null then selector else { app: name },
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
