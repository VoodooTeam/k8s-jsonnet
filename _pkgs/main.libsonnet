local sa = import '../authentication/sa.libsonnet';
local ingress = import '../ingress/ingress.libsonnet';
local irsa = import '../irsa/main.libsonnet';
local svc = import '../services/main.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';
local hpa = import '../workloads/hpa.libsonnet';

{
  // if provided, awsPermissions must be a list of irsa.statement (see /irsa/main.libsonnet)
  app(name, image, port=3000, replicas=null, awsPermissions=null, domain=null)::
    {
      deploy: deploy.default(name, image, port, replicas=replicas),
      svc: svc.default(name, [svc.port(port)]),
    }

    + (if replicas == null then { hpa: hpa.default(name) } else {})

    + (if awsPermissions != null
       then { irsa: irsa.default(name, awsPermissions) }
       else { sa: sa.default(name) })

    + (if domain != null
       then { ingress: ingress.nginx(name, domain, [{ route: '/', svcName: name, svcPort: port }]) }
       else {}),
}
