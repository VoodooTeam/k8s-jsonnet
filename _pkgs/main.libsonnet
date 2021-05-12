local k = import '../main.libsonnet';

{

  // simple_dep_svc creates a basic deployment & svc object
  app(name, image, port=3000, permissions=null)::  //todo add domain to generate ingress
    {
      deploy: k.deploy.default(name, image, port),
      svc: k.svc.default(name, [k.svc.port(port)]),
      hpa: k.hpa.default(name),
    }
    + (if permissions != null then { irsa: 'todo' } else { sa: k.sa.default(name) }),
}
