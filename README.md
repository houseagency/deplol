Deplol
======

Tool for simple publishing and deployment of docker images to Kubernetes and
the AWS Docker Registry.

Features:

* Publish and tag containers to AWS Docker Registry.
* Update the pods running in your Kubernetes cluster to the latest container
  image of a certain tag.
* It will help you to keep your docker image tags and git tags in sync.


Install
-------

```
npm install -g deplol
```


Usage
-----

### To publish an image to the AWS Docker Registry:

Required files in your project root (from where this command shall run):

* `Dockerfile`
* `.deplol_registry`

The `.deplol_registry` file should contain one line with the registry URL.
For example:

```
979723745180.dkr.ecr.eu-west-1.amazonaws.com/myserver
```

Run:

```
deplol publish
```

### To publish a Docker image using a certain tag:

```
deplol publish -t <tag>
```

Note, this will tag the current git HEAD with the tag. To store this on your
git server, you must:

```
git push origin --tags
```

If the tag was used before, you will have to `--force` the git push, or
remove the remote tag before pushing:

```
git push origin :refs/tags/<tag>
git push origin --tags
```

(Note that using `--force` is a bit unsafe, since it might force other stuff
than just overwriting tags.)


### To update the running version in your Kubernetes cluster:

To update a pod to your current git hash (it must have been `publish`ed
first):

```
deplol deploy -n <namespace>
```

The `<namespace>` is the Kubernetes namespace.

The Kubernetes pod deployment name is presumed to match the registry name
(the part after `/` in your docker registry, as defined in `.deplol_registry`).

### To update a running container to a specific git tag (or hash):

```
deplol deploy -n <namespace> -t <tag/hash>
```

This command will search your local git repo for the tag, find the corresponding
hash value, and then use that hash for updating your Kubernetes deployment.

