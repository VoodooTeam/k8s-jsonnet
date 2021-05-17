{
  spec(name, image, port)::
    {
      name: name,
      image: image,
      imagePullPolicy: 'Always',
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
      livenessProbe: {
        httpGet: {
          path: '/healthz',
          port: port,
        },
        initialDelaySeconds: 3,
        periodSeconds: 3,
      },
      readinessProbe: {
        httpGet: {
          path: '/healthz',
          port: port,
        },
        initialDelaySeconds: 3,
        periodSeconds: 3,
      },
      securityContext: {
        allowPrivilegeEscalation: false,
        readOnlyRootFilesystem: true,
        capabilities: {
          drop: ['ALL'],
        },
      },
    }
    + (if port != null then { ports: [$.port(port, name)] } else {}),

  port(number, name)::
    assert number > 0 && number < 65536;
    {
      containerPort: number,
      name: name,
    },


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
