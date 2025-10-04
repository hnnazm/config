#!/usr/bin/env bash

test -e /etc/bashrc && source /etc/bashrc

case $- in
  *i*);;  # interactive
  *)return ;;
esac

set -o vi

shopt -s checkwinsize
shopt -s histappend
shopt -s autocd
