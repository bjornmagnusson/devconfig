#!/usr/bin/env bash

readonly package="setup.sh"

SSH_USER=$USER
GIT_NAME=""
GIT_EMAIL=""
GIT_HOME=""
function showHelp() {
    echo "$package - Setup local development environment"
    echo " "
    echo "$package [options]"
    echo " "
    echo "options:"
    echo "-h, --help  show brief help"
    echo "--git-name  specify which name is used for git commits (default: $GIT_NAME)"
    echo "--git-email  specify which email is used for git commits (default: $GIT_EMAIL)"
    echo "--git-email  specify which directory to use in githome alias (default: $GIT_HOME)"
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
    --git-home)
      shift
      if test $# -gt 0; then
        GIT_HOME=$1
      else
        echo "no git-home parameter specified"
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

echo "============================="
echo "======== GITCONFIG =========="
echo "============================="
cp .gitconfig ~/
dos2unix ~/.gitconfig
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '.bak' "s/<name>/$GIT_NAME/" ~/.gitconfig
  sed -i '.bak' "s/<email>/$GIT_EMAIL/" ~/.gitconfig
else
  sed -i "s/<name>/$GIT_NAME/" ~/.gitconfig
  sed -i "s/<email>/$GIT_EMAIL/" ~/.gitconfig
fi
git config "user.name"
git config "user.email"

echo "============================"
echo "===== KUBECTL ALIASES ======"
echo "============================"
cp .kubectl_aliases ~/
dos2unix ~/.kubectl_aliases
echo "Added $(cat ~/.kubectl_aliases | wc -l)"

echo "============================"
echo "======== BASHRC ============"
echo "============================"
cp -r .bash-git-prompt ~/
cp .bashrc ~/
sed -i "s/<githome>/$(echo $GIT_HOME | sed 's/\//\\\//g')/" ~/.bashrc
dos2unix ~/.bashrc
source ~/.bashrc