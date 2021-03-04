local k = import '../main.libsonnet';

{
  dep(appName, image, appPort, createSa):: k.deploy.base(
    k.common.metadata(appName),
    k.pod.spec(
      [
        (
          k.container.base(
            appName
            , image
            , [k.container.port(appPort)]
          )
        ),
      ]
      , if createSa then appName else null
    )
  ),

  svc(appName, appPort):: k.svc.base(appName, [
    k.svc.port(appPort),
  ]),

  // container_merge target the container with the given image and overrides its definition
  // with the provided object
  container_merge(image, obj):: {
    deploy+: {
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
  },

  // simple_dep_svc creates a basic deployment & svc object
  simple_dep_svc(appName, image, appPort=8080, createSa=true)::
    {
      deploy: $.dep(appName, image, appPort, createSa),
      svc: $.svc(appName, appPort),
    }
    + (if createSa then { sa: k.sa.base(appName) } else {}),
}
