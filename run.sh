#!/bin/bash

set +e
set -o noglob


#
# Set Colors
#

bold=
underline=
reset=

red=
green=
white=
tan=
blue=

#
# Headers and Logging
#

underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
h1() { printf "\n${underline}${bold}${blue}%s${reset}\n" "$@"
}
h2() { printf "\n${underline}${bold}${white}%s${reset}\n" "$@"
}
debug() { printf "${white}%s${reset}\n" "$@"
}
info() { printf "${white}➜ %s${reset}\n" "$@"
}
success() { printf "${green}✔ %s${reset}\n" "$@"
}
error() { printf "${red}✖ %s${reset}\n" "$@"
}
warn() { printf "${tan}➜ %s${reset}\n" "$@"
}
bold() { printf "${bold}%s${reset}\n" "$@"
}
note() { printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}


type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

# Check variables
# docker.image
# docker.path
if [ -z "$ABS_DOCKER_IMAGE" ]; then
  info "Please set the 'image' variable"
  exit 1
fi

# command specific flags
args=
# docker.build.raw.args
raw_args=${ABS_DOCKER_BUILD_RAW_ARGS}

# artifact.host
# artifact.lane
# group.id.path
# artifact.id
# artifact.version

argslist=

if [ -n "${ABS_ARTIFACT_HOST}" ]; then
  args="$args --build-arg ARTIFACT_HOST='${ABS_ARTIFACT_HOST}'"
fi

if [ -n "${ABS_ARTIFACT_LANE}" ]; then
  args="$args --build-arg ARTIFACT_LANE='${ABS_ARTIFACT_LANE}'"
fi

if [ -n "${ABS_GROUP_ID_PATH}" ]; then
  args="$args --build-arg GROUP_ID_PATH='${ABS_GROUP_ID_PATH}'"
fi

if [ -n "${ABS_ARTIFACT_ID}" ]; then
  args="$args --build-arg ARTIFACT_ID='${ABS_ARTIFACT_ID}'"
fi

if [ -n "${ABS_ARTIFACT_VERSION}" ]; then
  args="$args --build-arg ARTIFACT_VERSION='${ABS_ARTIFACT_VERSION}'"
fi

# Check Docker is installed
if ! type_exists 'docker'; then
  error "Docker is not installed on this box."
  info "Please use a box with docker installed"
  exit 1
fi


# Variables
IMAGE="$ABS_DOCKER_IMAGE"
IMAGE_PATH=${ABS_DOCKER_PATH:-.}

set -e
# ----- Building image -----
# see documentation https://docs.docker.com/reference/commandline/cli/#build
# ---------------------------
h1 "Step 1: Building image"

# Check a Dockerfile is present
if [ ! -f "$IMAGE_PATH/Dockerfile" ]; then
  error "No Dockerfile found in folder $IMAGE_PATH."
  info "Please create a Dockerfile : https://docs.docker.com/reference/builder/"
  exit 1
fi


info "$DOCKER_BUILD"
DOCKER_BUILD="docker build --pull ${args} ${raw_args} -t $IMAGE $IMAGE_PATH"
$(DOCKER_BUILD)
if [ $? -ne 0 ];then
  warn $DOCKER_BUILD
  fail "Building image $IMAGE failed"
else
  success "Building image $IMAGE succeeded"
fi
