{

  spec(containers, saName=null)::
    {
      containers: containers,
    }
    + (if saName != null then { serviceAccountName: saName } else {}),

}
