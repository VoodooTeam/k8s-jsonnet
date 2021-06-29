# k8s-jsonnet

Opinionated [jsonnet](https://jsonnet.org/) definitions of k8s resources. 

It provides :
- best-practices by default so you can be confident your app is secure even if you're not a k8s expert,
- high-level functions so you can override anything you want easily,
- ready-to-go app bundles so you can generate everything you need with a single line of code (see [one-file examples](#one-file-examples)).

These resources definitions get a perfect score (100/100) with [polaris](https://www.fairwinds.com/polaris) security scanner.

## examples 

### one-file examples
You have a few examples in the [./\_examples](./\_examples/) folder

```
jsonnet -y ./_examples/app_minimal.jsonnet | yq eval -P
jsonnet -y ./_examples/app_complete.jsonnet | yq eval -P
jsonnet -y ./_examples/app_withEnvFromSecret.jsonnet | yq eval -P
```

the results of the commands above are in the : [./\_examples/results](./\_examples/results) folder

### Jsonnet project example

Have a look at [./\_examples/project/](./\_examples/project/)

## Import this in your project 

To import this lib in your project, you can use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler/releases)

If you don't use jsonnet bundler in your project yet :

(from your project's root)
```
jb init
```

add this repo as a dependency :
```
jb install https://github.com/VoodooTeam/k8s-jsonnet@v0.1.0
```

You can now reference these files in your project using `local someResource = import 'k8s-jsonnet/someResource.libsonnet';` to import resources defined here

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

Deploy your app :

```
jsonnet ./_examples/app_minimal.jsonnet | kubectl -f -
```

See [./\_examples/project/](./\_examples/project/) for more examples

# Development

## dependencies 

If you've got the [nix](https://nixos.org/download.html#nix-quick-install) package manager, just run `nix-shell` from this project's root and you're ready to go.

It will install : 
- make
- go-jsonnet
- jq
- yq-go
- kubeval
- polaris
- bats-core

If you don't have nix, you can install all the packages above manually.

## run tests
```
make test
```
