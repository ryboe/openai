# OpenAI Container

The `openai` CLI tool in a container so it doesn't pollute your local Python
environment.

## Usage

Put this function in your shell config (e.g. `~/.zshrc`, `~/.bashrc`) and you
can run `openai` as if it was installed natively.

```sh
openai() {
    if ! command -v docker &>/dev/null; then
        echo "docker is not installed"
        echo "please install docker and try again"
        exit 1
    fi

    if ! docker info &>/dev/null; then
        echo "docker is not running"
        echo "please start docker and try again"
        exit 1
    fi

    docker container run --pull always --env OPENAI_API_KEY=$OPENAI_API_KEY ghcr.io/ryboe/openai:latest openai $@
}
```

Here are some examples of how to use `openai`:

```sh
openai api chat_completions.create --model gpt-3.5-turbo --message user 'what are the symptoms of lyme disease?'
openai api image.create --num-images 1 --prompt 'giant gundam with ukrainian colors'
```

## How To Build The Image Locally

```sh
# Build with BuildKit by default. After running this command to install the
# buildx plugin, you can type `docker build` instead of `docker buildx build`.
docker buildx install

# --driver docker-container    run BuildKit engine as a container (moby/buildkit:buildx-stable-1)
# --use                        switch to this new container-based docker engine that you're creating
# --bootstrap                  start moby/buildkit container after it's "created" (pulled, really)
docker builder create --driver docker-container --name mybuilder --use --bootstrap

# --load                       save the image to the local filesystem
# --platform linux/amd64       Codespaces only run on AMD64 processors
# - < Dockerfile               '-' means "don't tar up the current directory and pass it to BuildKit
#                              as a build context". We don't need a build context because we don't
#                              need to copy any files from this repo into the container. The only
#                              thing we need is the Dockerfile, which we're passing by redirecting
#                              it to stdin.
docker image build --load --platform linux/amd64 --build-arg PYTHON_VERSION=3.11 --tag myopenai - < Dockerfile
```
