local sa = import '../authentication/sa.libsonnet';
local svc = import '../services/main.libsonnet';
local deploy = import '../workloads/deploy.libsonnet';
local hpa = import '../workloads/hpa.libsonnet';

{

  app(name, image, port=3000, permissions=null)::  //todo add domain to generate ingress
    {
      deploy: deploy.default(name, image, port),
      svc: svc.default(name, [svc.port(port)]),
      hpa: hpa.default(name),
    }
    + (if permissions != null then { irsa: 'todo' } else { sa: sa.default(name) }),
}
