{
  base(n, image, ports=[])::
    {
      name: n,
      image: image,
      imagePullPolicy: 'Always',
      ports: ports,
      resources: {
        limits: {
          cpu: '200m',
          memory: '100Mi',
        },
        requests: {
          cpu: '100m',
          memory: '50Mi',
        },
      },
      securityContext: {
        allowPrivilegeEscalation: false,
        capabilities: {
          drop: ['ALL'],
        },
      },
    },

  port(containerPort, name=null)::
    {
      containerPort: containerPort,
      assert containerPort > 0 && containerPort < 65536,
    }
    + (if name != null then { name: name } else {}),


  entryPoint(command=[], args=[])::
    {
      entryPoint: {}
                  + (if command != [] then { command: command } else {})
                  + (if args != [] then { args: args } else {}),
    },

  env(keyvals=[])::
    {
      env: keyvals,
    },

  secretRef(name):: {
    secretRef: {
      name: name,
    },
  },

  envFrom(secretRefs=[])::
    {
      envFrom: secretRefs,
    },
}
