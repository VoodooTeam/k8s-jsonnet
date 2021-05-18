local img = import './image.json';
local apps = import 'k8s-jsonnet/_apps/main.libsonnet';

apps.default('appName', img.app)
