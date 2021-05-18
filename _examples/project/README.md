# Real project example

## Jsonnet bundler
jsonnet-bundler (`jb`) is used to get the k8s-jsonnet lib (this repo)

```
jb init
```

then
```
jb install ../../
```

_NB: instead of local path, you'll use github url with the release version :_
```
jb install https://github.com/VoodooTeam/k8s-jsonnet@<the-version-you-want>
```

this created the `./vendor` folder, `./jsonnetfile.json` & `./jsonnetfile.lock.json` files (same role as `package.json` with JS)

## Jsonnet files
3 files are used to generate our app : [./app.jsonnet](./app.jsonnet), [./definitions.libsonnet](./definitions.libsonnet), [./image.json](./image.json). Everything could be in the same file, we do that for convenience as explained below.

### app.jsonnet
Is the file that actually renders all our k8s manifests.

You can get a pretty yaml output of our app using :
```
jsonnet -J ./vendor -y ./app.jsonnet | yq eval -P
```

It simply imports `./definitions.libsonnet` and outputs it as a list of resources (what k8s expects).

### definitions.libsonnet
This file contains all our resources in a map, this is convenient if you've got to tweak something during the development and your app grows in size because it allows you to target a single resource.

Get just the `deployment` of our app (pretty yaml) :
```
jsonnet -e  "(import './definitions.libsonnet').deploy" -J ./vendor | yq eval -P
```

It imports some of the resources of this lib and the `./image.json` file.

### image.json
This file only contains an object with our app image tag. This is convenient because if you use a gitops continuous delivery pattern, you can use a standard tool like `jq` to just update this field.

_NB_: jsonnet is a super set of `json` so there's no problem importing json in jsonnet.

