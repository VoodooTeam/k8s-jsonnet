local c = import '../../common/common.libsonnet';

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
        runAsNonRoot: true,
        capabilities: {
          drop: ['ALL'],
        },
      },
    }
    + (if port != null then { ports: [$.port(port)] } else {}),

  port(number, name=null)::
    assert number > 0 && number < 65536;
    {
      containerPort: number,
    } + (if name != null then { name: name } else {}),


  entryPoint(command=null, args=null)::
    assert std.type(command) == 'null' || std.isArray(command);
    assert std.type(args) == 'null' || std.isArray(args);
    {
      entryPoint: {}
                  + (if command != null then { command: command } else {})
                  + (if args != null then { args: args } else {}),
    },

  envLiterals(keyVals)::
    assert std.isObject(keyVals);
    {
      env+: std.objectValues(
        std.mapWithKey(c.keyval, keyVals)
      ),
    },

  envFromSecret(secretName)::
    {
      envFrom+: [$.secretRef(secretName)],
    },

  envFromConfigMap(cmName)::
    {
      envFrom+: [$.configMapRef(cmName)],
    },

  secretRef(name):: {
    secretRef: {
      name: name,
    },
  },

  configMapRef(name):: {
    configMapRef: {
      name: name,
    },
  },

}
