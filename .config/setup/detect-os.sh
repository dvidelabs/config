#!/bin/bash

case "$(uname -a)" in
    *Darwin*) echo "macos" ;;
    *Ubuntu*) echo "ubuntu" ;;
    *Linux*)  echo "linux" ;;
    *) echo "other" ;;
esac
