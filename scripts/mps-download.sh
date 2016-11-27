usage() {
  echo "Invalid number of arguments."
  echo "Usage: $0 <youtube-url>"
  exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

docker run -v "$(pwd)":/home/user/mps/ andrey01/mps-youtube daurl "$1"
