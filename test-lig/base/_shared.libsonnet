local k = import '../../1.20/main.libsonnet';

{
  k:: k,
  nrSecretRef:: k.container.envFromSecret('new-relic'),
  mongoSecretRef:: k.container.envFromSecret('mongodb'),
}
