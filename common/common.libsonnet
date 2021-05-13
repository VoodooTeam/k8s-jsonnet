{

  apiVersion(v='v1')::
    { apiVersion: v },

  metadata(name, ns=null, labels={}, annotations={})::
    {
      metadata: {
                  name: name,
                  labels: { app: name }
                          + labels,
                }
                + (if ns != null then { namespace: ns } else {})
                + (if annotations != {} then { annotations: annotations } else {}),
    },

  keyval(name, value)::
    {
      name: name,
      value: value,
    },
}
