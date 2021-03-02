{

  apiVersion(v='v1')::
    { apiVersion: v },

  metadata(n, ns=null, ll={}, aa={})::
    {
      metadata: {
                  name: n,
                }
                + (if ns != null then { namespace: ns } else {})
                + (if ll != {} then { labels: ll } else {})
                + (if aa != {} then { annotations: aa } else {}),
    },

  keyval(name, value)::
    {
      name: name,
      value: value,
    },
}
