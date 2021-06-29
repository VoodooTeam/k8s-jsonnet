local img = import './image.libsonnet';
local k = import 'k8s-jsonnet/1.21/main.libsonnet';

k._app.default('appName', img.app)
