Deplol
======

This is a tool for publishing Docker containers to the AWS Docker Registry,
and for updating the pods running in your Kubernetes cluster.


Requirements for this tool
--------------------------

### 1. The current working directory must be a Git repository.

### 2. Required files in your project root (from where this command shall run):

* `Dockerfile`
* `.deplol_registry`

The `.deplol_registry` file should contain one line with the registry URL.
For example:

```
979723745180.dkr.ecr.eu-west-1.amazonaws.com/myserver
```

### 3. Proper AWS credentials setup

Use a AWS configuration file with your profiles, or use the standard AWS
credentails enviroment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

### 4. Kubernetes kubectl configuration

Also, you need a `~/.kube/config` configuration for your Kubernetes cluster.


To publish to Docker registry
-----------------------------

Run:

```
./deplol.sh publish
```

### To publish a Docker image using a certain tag:

```
./deplol.sh publish <tag>
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


To update the running version in your Kubernetes cluster
--------------------------------------------------------

To update pod to your current git hash (it must have been `publish`ed
first):

```
./deplol.sh deploy <namespace>
```

The `<namespace>` is the Kubernetes namespace.

The Kubernetes pod deployment name is presumed to match the registry name
(the part after `/` in your docker registry, as defined in `.deplol_registry`).

### To update the pod to a specific git tag (or hash):

```
./deplol.sh deploy <namespace> <tag/hash>
```

This command will search your local git repo for the tag, find the corresponding
hash value, and then use that hash for updating your Kubernetes deployment.

