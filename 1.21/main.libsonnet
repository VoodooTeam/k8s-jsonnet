local k120 = import '../1.20/main.libsonnet';

k120 {
  deploy+:
    {
      default(name, image, port, replicas=null, ns=null)::
        super.default(name, image, port, replicas, ns)
        + {
          apiVersion: 'apps/v1',
        },
    },
}
