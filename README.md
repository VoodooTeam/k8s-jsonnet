# k8s-jsonnet

jsonnet definitions of k8s resources that can be shared across projects

To import this lib in your project, please use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler/releases)

## examples 

You have a few examples in the [./\_examples](./\_examples/) folder

```
jsonnet -y ./_examples/app_minimal.jsonnet | yq eval -P
jsonnet -y ./_examples/app_complete.jsonnet | yq eval -P
jsonnet -y ./_examples/app_withEnvFromSecret.jsonnet | yq eval -P
```
for the results of the commands above, see : [./\_examples/results](./\_examples/results) folder

## Import this in your project 

if you don't use jsonnet bundler in your project yet :

(from your project's root)
```
jb init
```

add this repo as a dependency :
```
jb install https://github.com/VoodooTeam/k8s-jsonnet@v0.1.0
```

You can now reference these files in your project using `local someResource = import 'k8s-jsonnet/someResource.libonnet';` to import resources defined here


### Create a service
Let's create a k8s `Service` called `my-svc` targetting pods with the label `app: "my-app"` on the port `8080` (exposed on the port `8080` of the service itself).

write in a file (`./my-svc.jsonnet` in this example, file names have no special meaning) :
```
local k = import 'k8s-jsonnet/main.libsonnet';

[
  k.svc.base('my-svc', [k.svc.port(8080)], { app: 'my-app' }),
]
```

then, running :
```
jsonnet -J vendor -y ./my-svc.jsonnet 
```
- `-J` indicates the libs folder (created by `json-bundler`)
- `-y` means `yaml` output
- `./my-svc.jsonnet` is the input file

will output in stdout :

```
---
{
   "apiVersion": "v1",
   "kind": "Service",
   "metadata": {
      "labels": {
         "app": "my-svc"
      },
      "name": "my-svc"
   },
   "spec": {
      "ports": [
         {
            "port": 8080
         }
      ],
      "selector": {
         "app": "my-app"
      }
   }
}
```

which is a valid k8s declaration in yaml format of the service we expected to create.


# Run tests
## dependencies 
- jsonnet
- kubeval
- polaris
- bats-core

## Run
```
bats -r .
```
