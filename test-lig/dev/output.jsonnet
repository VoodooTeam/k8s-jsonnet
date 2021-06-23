local utils = import '../utils.libsonnet';
local main = import './_main.libsonnet';

utils.services_presenter(main.output)
