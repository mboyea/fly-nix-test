echo_error() {
  echo "Error in $SCRIPT_NAME:" "$@" 1>&2;
}

load_env_file() {
  # if git is not installed, return
  if ! [ -x "$(command -v git)" ]; then
    return
  fi
  # if current directory is not a git directory, return
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return
  fi
  # go to top-level of git directory
  base_dir="$(git rev-parse --show-toplevel)"
  cd "$base_dir"
  # load .env file if it exists
  if [ -r "$ENV_FILE" ]; then
    set -a
    # shellcheck disable=SC1091 source=/dev/null
    source "$ENV_FILE"
    set +a
  fi
}

test_env() {
  # disable exit on undefined variable use
  set +u
  # for each env variable
  while [[ $# -gt 0 ]]; do
    # check that env variable is defined
    if [ -z "${!1}" ]; then
      echo_error The required environment variable "$1" is not defined
      exit 1
    fi
    shift
  done
  # enable exit on undefined variable use
  set -u
}

deploy_docker_image_to_fly_registry() {
  "$DOCKER_IMAGE_STREAM" | gzip --fast | skopeo --insecure-policy copy --dest-creds="x:$FLY_API_TOKEN" "docker-archive:/dev/stdin" "docker://registry.fly.io/$FLY_APP_NAME:$DOCKER_IMAGE_TAG"
}

load_docker_image_on_fly_server() {
  flyctl deploy --ha=false -c "$FLY_CONFIG" -i "registry.fly.io/$FLY_APP_NAME:$DOCKER_IMAGE_TAG"
}

main() {
  test_env ENV_FILE
  load_env_file
  test_env SCRIPT_NAME DOCKER_IMAGE_STREAM DOCKER_IMAGE_NAME DOCKER_IMAGE_TAG FLY_API_TOKEN FLY_APP_NAME FLY_CONFIG
  deploy_docker_image_to_fly_registry
  load_docker_image_on_fly_server
}

main "$@"
