{
  base(n, image, ports=[])::
    {
      name: n,
      image: image,
      imagePullPolicy: 'Always',
      ports: ports,
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
