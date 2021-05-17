{

  apiVersion(v='v1')::
    { apiVersion: v },

  metadata(name, ns=null, labels=null, annotations=null)::
    {
      metadata: {
                  name: name,
                  labels: { app: name }
                          + if labels != null then labels else {},
                }
                + (if ns != null then { namespace: ns } else {})
                + (if annotations != null then { annotations: annotations } else {}),
    },

  keyval(name, value)::
    {
      name: name,
      value: value,
    },
}
