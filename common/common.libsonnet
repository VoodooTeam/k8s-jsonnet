{

  apiVersion(v='v1')::
    { apiVersion: v },

  metadata(name, ns=null, ll={}, aa={})::
    {
      // we set the {app: name} label by default
      local labels = { app: name } + ll,

      metadata: {
                  name: name,
                  labels: labels,
                }
                + (if ns != null then { namespace: ns } else {})
                + (if aa != {} then { annotations: aa } else {}),
    },

  keyval(name, value)::
    {
      name: name,
      value: value,
    },
}
