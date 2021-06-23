local container = import '../../workloads/container.libsonnet';

{
  //issuer:: k.tls.letsencrypt('devops@voodoo.io'),
  nrSecretRef: container.envFromSecret('new-relic'),
  mongoSecretRef: container.envFromSecret('mongodb'),
}
