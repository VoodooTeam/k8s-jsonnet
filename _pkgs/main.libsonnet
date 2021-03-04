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

  hpa(appName):: k.hpa.base(appName),

  // simple_dep_svc creates a basic deployment & svc object
  simple_dep_svc(appName, image, appPort=8080, createSa=true)::
    {
      deploy: $.dep(appName, image, appPort, createSa),
      svc: $.svc(appName, appPort),
      hpa: $.hpa(appName),
    }
    + (if createSa then { sa: k.sa.base(appName) } else {}),
}
