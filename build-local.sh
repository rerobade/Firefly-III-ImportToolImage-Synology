#!/usr/bin/env bash

#
# Step 1: set repos name.
#
#REPOS_NAME=jc5x/test-repository
REPOS_NAME=jc5x/test-repository

PLATFORMS=linux/amd64

VERSION="${VERSION:-develop}"
IMPORTER="${IMPORTER:-csv}"
APACHE_PLATFORM="${APACHE_PLATFORM:-7.4}"

#
# Step 2: echo some info
#
echo "build-travis.sh v1.2 (2021-01-20): I am building '${VERSION}' for ${REPOS_NAME} (${IMPORTER})."

# new script start

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes i
docker buildx create --name firefly_iii_builder
docker buildx inspect firefly_iii_builder --bootstrap
docker buildx use firefly_iii_builder

# always also push same label as the version (ie develop)
LABEL=$VERSION

# if the version is an alpha version, push to "alpha":
if [[ $VERSION == *"alpha"* ]]; then
	LABEL="alpha"
fi

# if the version is a beta version, push to "beta":
if [[ $VERSION == *"beta"* ]]; then
	LABEL="beta"
fi

if [[ $VERSION != *"beta"* && $VERSION != *"alpha"* && $VERSION != *"develop"* ]]; then
	LABEL="latest"
fi

echo "Version is '$VERSION' so label will be '$REPOS_NAME:$LABEL'."

# build CSV
docker buildx build  --build-arg version=$VERSION --build-arg apache_platform=$APACHE_PLATFORM --build-arg importer=$IMPORTER --platform $PLATFORMS -t $REPOS_NAME:$VERSION --push . -f Dockerfile

echo "Done!"
