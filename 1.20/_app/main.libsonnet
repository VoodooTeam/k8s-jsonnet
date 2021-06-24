local irsa = import '../../crds/irsa/main.libsonnet';
local sa = import '../authentication/sa.libsonnet';
local ingress = import '../ingress/ingress.libsonnet';
local svc = import '../services/main.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';
local hpa = import '../workloads/hpa.libsonnet';

{
  // if provided, awsPermissions must be a list of irsa.statement (see /irsa/main.libsonnet)
  default(name, image, port=3000, replicas=null, awsPermissions=null, domain=null, ns=null)::
    {
      deploy: deploy.default(name, image, port, replicas=replicas, ns=ns),
      svc: svc.default(name, [svc.port(port)], ns=ns),
    }

    + (if replicas == null then { hpa: hpa.default(name, ns=ns) } else {})

    + (if awsPermissions != null
       then { irsa: irsa.default(name, awsPermissions, ns=ns) }
       else { sa: sa.default(name, ns=ns) })

    + (if domain != null
       then { ingress: ingress.nginx(name, domain, [{ route: '/', svcName: name, svcPort: port }], ns=ns) }
       else {}),
}
