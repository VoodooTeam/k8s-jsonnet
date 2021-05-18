# k8s-jsonnet

jsonnet definitions of k8s resources that can be shared across projects

Have a look at [./\_apps](./_apps/) folder for ready-to-go apps (see [#examples](#examples) for how you can use them)

The resources definitions here get a perfect score (100/100) with [polaris](https://www.fairwinds.com/polaris) so you're guaranteed to have best-practices out of the box.

## examples 

### one-file examples
You have a few examples in the [./\_examples](./\_examples/) folder

```
jsonnet -y ./_examples/app_minimal.jsonnet | yq eval -P
jsonnet -y ./_examples/app_complete.jsonnet | yq eval -P
jsonnet -y ./_examples/app_withEnvFromSecret.jsonnet | yq eval -P
```
for the results of the commands above, see : [./\_examples/results](./\_examples/results) folder

### project example
have a look at [./\_examples/project/](./\_examples/project/)

## Import this in your project 

To import this lib in your project, please use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler/releases)

If you don't use jsonnet bundler in your project yet :

(from your project's root)
```
jb init
```

add this repo as a dependency :
```
jb install https://github.com/VoodooTeam/k8s-jsonnet@v0.1.0
```

You can now reference these files in your project using `local someResource = import 'k8s-jsonnet/someResource.libonnet';` to import resources defined here

_NB :_ to use jsonnet with jsonnet-bundler, you've to add the `-J ./path/to/the/vendor/folder` flag to jsonnet
```
jsonnet -J ./vendor ./my-app.jsonnet
```

## Work with Jsonnet

Render a file :
```
jsonnet ./_examples/app_minimal.jsonnet
```

Nice yaml output :
```
jsonnet -y ./_examples/app_minimal.jsonnet | yq eval -P
```

See [./\_examples/project/](./\_examples/project/) for more examples



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
