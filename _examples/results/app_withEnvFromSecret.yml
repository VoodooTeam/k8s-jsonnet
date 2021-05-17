apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: appName
  name: appName
spec:
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: appName
  template:
    metadata:
      labels:
        app: appName
    spec:
      containers:
        - envFrom:
            - secretRef:
                name: my-secret-name
          image: appImage:v1.0
          imagePullPolicy: Always
          livenessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 3
            periodSeconds: 3
          name: appName
          ports:
            - containerPort: 3000
              name: default
          readinessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 3
            periodSeconds: 3
          resources:
            limits:
              cpu: 200m
              memory: 100Mi
            requests:
              cpu: 100m
              memory: 50Mi
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
            readOnlyRootFilesystem: true
      securityContext:
        fsGroup: 2000
        runAsGroup: 3000
        runAsUser: 1000
      serviceAccountName: appName
---
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  labels:
    app: appName
  name: appName
spec:
  maxReplicas: 100
  metrics:
    - resource:
        name: memory
        target:
          averageUtilization: 100
          type: Utilization
      type: Resource
    - resource:
        name: cpu
        target:
          averageUtilization: 100
          type: Utilization
      type: Resource
  minReplicas: 1
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: appName
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: appName
  name: appName
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: appName
  name: appName
spec:
  ports:
    - port: 3000
  selector:
    app: appName
