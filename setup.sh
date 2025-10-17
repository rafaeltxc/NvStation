#!/bin/bash

shopt -s globstar

git config core.hooksPath hooks

chmod +x ./hooks/**/*
chmod +x ./scripts/**/*
