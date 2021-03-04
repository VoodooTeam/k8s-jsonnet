{

  // container_merge target the container with the given image and overrides its definition
  // with the provided object
  deploy_container_merge(image, obj):: {
    spec+: {
      template+: {
        spec+: {
          containers: [
            if x.image == image
            then x + obj
            else x
            for x in super.containers
          ],
        },
      },
    },
  },
}
