local common = import '../common/common.libsonnet';

{
  letsencrypt(email, prod=true)::
    local name = 'letsencrypt-' + (if prod
                                   then 'prod'
                                   else 'staging');

    common.apiVersion('cert-manager.io/v1')
    + { kind: 'Issuer' }
    + common.metadata(name)
    + {
      spec: {
        acme: {
          server: (if prod
                   then 'https://acme-v02.api.letsencrypt.org/directory'
                   else 'https://acme-staging-v02.api.letsencrypt.org/directory'),
          email: email,
          privateKeySecretRef: {
            name: name,
          },
          solvers: [
            {
              http01: {
                ingress: {
                  class: 'nginx',
                },
              },
            },
          ],
        },
      },
    },
}
