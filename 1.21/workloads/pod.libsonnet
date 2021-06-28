local pod_120 = import '../../1.20/workloads/pod.libsonnet';

// doesn't change anything, just an example about how it could
pod_120 {
  deps(k):: super.deps(k) {
    spec(name, image, port)::
      super.spec(name, image, port)
      {
        //newField: 'hello',
      },
  },
}
