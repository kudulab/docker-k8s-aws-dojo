# docker-k8s-aws-dojo

A [Dojo](https://github.com/kudulab/dojo) docker image with tools needed to manage a Kubernetes cluster on AWS. Based on [docker-k8s-dojo](https://github.com/kudulab/docker-k8s-dojo). Uses Alpine Linux.

## Usage
1. Install [Dojo](https://github.com/kudulab/dojo)
2. Provide a Dojofile:
```
DOJO_DOCKER_IMAGE="kudulab/k8s-aws-dojo:tagname"
# This directory should exist locally (outside of the container), because
# you may be using some tool that generates kubeconfig and it would be gone
# after you remove the container.
# You can mount any local directory, it doesn't need to be $HOME/.kube
DOJO_DOCKER_OPTIONS="-v $HOME/.kube:/home/dojo/.kube"
```

3. Run `dojo` to make Dojo run a Docker container.
4. Inside the container you can run e.g.:
```bash
kubectl version
kubectl cluster-info
kubectl get pod
helm version
kops version
kops get cluster --full -o yaml --name my-cluster-name --state "s3://my-cluster-name-s3-bucket"
eksctl version
bats -t tests.bats
aws --version
aws s3api list-buckets | jq '.Buckets[]["Name"]'
```

By default, current directory in docker container is `/dojo/work`.


## Specification

Using this Docker image it should be possible to manage a Kubernetes cluster on AWS using either [Amazon Elastic Kubernetes Service (EKS)](https://docs.aws.amazon.com/eks/) or [kops](https://github.com/kubernetes/kops). The following tools are installed:
  * [kubectl](https://github.com/kubernetes/kubectl) - to interact with a cluster
  * [helm](https://github.com/helm/helm) - to package applications which can be deployed on top of a cluster
  * [aws cli version 2](https://github.com/aws/aws-cli)
  * [eksctl](https://github.com/weaveworks/eksctl/) - to manage a cluster on AWS EKS
  * [kops](https://github.com/kubernetes/kops) - to manage a cluster on AWS
  * [bats-core](https://github.com/bats-core/bats-core) - to test a cluster
  * [jq](https://github.com/stedolan/jq) - to parse JSON output in Bash


### Configuration
Those files are used inside the docker image:

1. `~/.ssh` - if exists locally, will be copied
1. `~/.ssh/config` - will be generated on docker container start
1. `~/.gitconfig` - if exists locally, will be copied
1. `~/.kube` - must be mounted; otherwise results in error
1. `~/.kube/config` - if not exists, will be generated on docker container start if `K8S_ENDPOINT` is set
1. `~/.aws` - if exists locally, will be copied

You can set optional variables in Dojofile and they will be used to generate a kube config:
```
DOJO_DOCKER_OPTIONS=-e K8S_ENDPOINT="http://my-k8s.example.com:8080" \
  -e KUBE_USER="mykubeuser"
# environment variable KUBE_USER defaults to ${DOJO_USER}
```

You can also generate it yourself: `/usr/bin/generate-kubeconfig.sh`.

## Development
### Dependencies
* Bash
* Docker daemon
* Bats
* Dojo


### Lifecycle
1. In a feature branch:
    * make changes and add some docs to changelog (do not insert date or version)
    * build docker image: `./tasks build_local`
    * test it: `./tasks itest`
1. Decide that your changes are ready and if so:
    * merge into master branch
    * set version in changelog by running:
      * `./tasks set_version`
      * or `./tasks set_version 1.2.3` to bump to a particular version
    * push to master
1. CI server (GoCD) tests and releases.

## License

Copyright 2020 Ewa Czechowska, Tomasz Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
