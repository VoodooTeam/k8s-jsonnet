{

  spec(containers, saName=null)::
    {
      containers: containers,
      serviceAccountName: saName,
    },

  keyval(name, value)::
    {
      name: name,
      value: value,
    },

  env(keyvals=[])::
    {
      env: keyvals,
    },
}
