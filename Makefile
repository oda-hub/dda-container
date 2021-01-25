USER_ID?=$(shell id -u)
DOCKER_COMMIT=$(shell git describe --always)
OSA_VERSION?=$(shell curl https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/CentOS_7.7.1908_x86_64/latest/latest/osa-version-ref.txt)
#OSA_VERSION_SHORT?=$(shell curl https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/CentOS_7.5.1804_x86_64/latest/latest/osa-version-ref.txt | awk -F- '{print $$1,$$2,$$4}' OFS=-)

TAG=$(DOCKER_COMMIT)
#TAG="$(OSA_VERSION)-$(DOCKER_COMMIT)"
IMAGE="odahub/dda:$(TAG)"
IMAGE_LATEST="odahub/dda:latest"

build: 
	bash urls.sh
	docker build --pull -t $(IMAGE) --build-arg uid=$(USER_ID) --build-arg OSA_VERSION=$(OSA_VERSION) --build-arg CONTAINER_COMMIT=$(DOCKER_COMMIT) .
	echo "built $(IMAGE)"
	echo $(TAG) > image-tag

push: build
	docker push $(IMAGE)
	docker tag $(IMAGE) $(IMAGE_LATEST)
	docker push $(IMAGE_LATEST)

pull:
	docker pull $(IMAGE)

run-it: 
#build
	docker run --privileged --entrypoint=bash -it $(IMAGE)

run: build
	sh run.sh $(IMAGE)

test: build
	sh test.sh $(IMAGE)

singularity:
	echo "will do!"

run-worker: build
	WORKER_MODE=passive DDA_QUEUE="http://in.internal.odahub.io/staging-1-3/dqueue@queue-osa11" sh run.sh $(IMAGE)

singularity: build
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v /dev/shm/singularity/:/output --privileged -t --rm quay.io/singularity/docker2singularity $(IMAGE)
