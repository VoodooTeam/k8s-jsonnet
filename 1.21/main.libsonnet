local k120 = import '../1.20/main.libsonnet';

// nothing actually changed
// just an example about how you could use a previous k8s version definitions and update it.
// here, we target deployment.apiVersion
k120 {
  deploy+:
    {
      default(name, image, port, replicas=null, ns=null)::
        super.default(name, image, port, replicas, ns)
        {
          apiVersion: 'apps/v1',
        },
    },
}
