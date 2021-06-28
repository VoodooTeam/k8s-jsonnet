local irsa = import '../../crds/irsa/main.libsonnet';

{
  deps(k):: {
    // if provided, awsPermissions must be a list of irsa.statement (see /irsa/main.libsonnet)
    default(name, image, port=3000, replicas=null, awsPermissions=null, domain=null, ns=null)::
      {
        deploy: k.deploy.default(name, image, port, replicas=replicas, ns=ns),
        svc: k.svc.default(name, [k.svc.port(port)], ns=ns),
      }

      + (if replicas == null then { hpa: k.hpa.default(name, ns=ns) } else {})

      + (if awsPermissions != null
         then { irsa: irsa.default(name, awsPermissions, ns=ns) }
         else { sa: k.sa.default(name, ns=ns) })

      + (if domain != null
         then { ingress: k.ingress.nginx(name, domain, [{ route: '/', svcName: name, svcPort: port }], ns=ns) }
         else {}),
  },
}
