{

  spec(containers, saName=null)::
    {
      securityContext: {
        runAsUser: 1000,
        runAsGroup: 3000,
        fsGroup: 2000,
      },
      containers: containers,
    }
    + (if saName != null then { serviceAccountName: saName } else {}),

}
