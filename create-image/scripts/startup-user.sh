#!/bin/bash

export PS1='$(__git_ps1 "(%s) ")'$PS1

alias ls="ls --color"
alias ll="ls -l"
alias la="ll -a"

# users bin
export PATH=~/bin:$PATH

