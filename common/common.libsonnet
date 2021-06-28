{
  apiVersion(v='v1'):: { apiVersion: v },

  metadata:: {
    new(name, ns=null, labels=null, annotations=null):: {
      metadata: {
                  name: name,
                  labels: { app: name }
                          + if labels != null then labels else {},
                }
                + (if ns != null then { namespace: ns } else {})
                + (if annotations != null then { annotations: annotations } else {}),

    },

    addLabels(labels)::
      $.metadata.mergeMeta(labels, 'labels'),

    addAnnotations(annotations)::
      $.metadata.mergeMeta(annotations, 'annotations'),

    mergeMeta(obj, key)::
      assert std.isObject(obj);
      assert std.isString(key);
      {
        metadata+: {
          [key]+: obj,
        },
      },
  },

  keyval(name, value):: {
    name: name,
    value: value,
  },
}
