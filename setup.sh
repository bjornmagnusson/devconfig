#!/usr/bin/env bash

readonly package="setup.sh"

SSH_USER=$USER
GIT_NAME=""
GIT_EMAIL=""
function showHelp() {
    echo "$package - Setup local development environment"
    echo " "
    echo "$package [options]"
    echo " "
    echo "options:"
    echo "-h, --help  show brief help"
    echo "--git-name  specify which name is used for git commits (default: $GIT_NAME)"
    echo "--git-email  specify which email is used for git commits (default: $GIT_EMAIL)"
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      showHelp
      exit 0
      ;;
    --git-name)
      shift
      if test $# -gt 0; then
        GIT_NAME=$1
      else
        echo "no git-name parameter specified"
        exit 1
      fi
      shift
      ;;
    --git-email)
      shift
      if test $# -gt 0; then
        GIT_EMAIL=$1
      else
        echo "no git-email parameter specified"
        exit 1
      fi
      shift
      ;;
    *)
      showHelp
      exit 0
      ;;
  esac
done

cp -r .bash-git-prompt ~/
cp .bashrc ~/
cp .gitconfig ~/
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '.bak' "s/<name>/$GIT_NAME/" ~/.gitconfig
  sed -i '.bak' "s/<email>/$GIT_EMAIL/" ~/.gitconfig
else
  sed -i "s/<name>/$GIT_NAME/" ~/.gitconfig
  sed -i "s/<email>/$GIT_EMAIL/" ~/.gitconfig
fi
git config "user.name"
git config "user.email"