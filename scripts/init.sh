#!/bin/bash

PATH_POINTER="$HOME/.config/nvim/scripts/pointer.sh"

source "$PATH_POINTER"

if [ "$POINTER" == 1 ]; then
  exit 0
fi

LOCAL="$(pwd)"

# Lombok install
LOMBOK_PATH="$HOME/.local/share/nvim/mason/share/jdtls/"
LOMBOK_JAR="lombok.jar"

if [ ! -f "$LOMBOK_PATH$LOMBOK_JAR" ]; then
    curl -L -o "$LOMBOK_PATH$LOMBOK_JAR" https://projectlombok.org/downloads/lombok.jar
fi

# Markdown plugin build
MARKDOWN_PATH="$HOME/.local/share/nvim/lazy/markdown-preview.nvim/"

pushd "$MARKDOWN_PATH" >/dev/null || exit 1
yarn install
popd >/dev/null

# NeotestJava setup
NEOTEST_JAVA_PATH="$HOME/.local/share/nvim/neotest-java/"
JUNIT_JAR="junit-platform-console-standalone-1.10.1.jar"

if [ ! -f "$NEOTEST_JAVA_PATH$JUNIT_JAR" ]; then
    mkdir -p "$NEOTEST_JAVA_PATH"
    curl -L -o "$NEOTEST_JAVA_PATH$JUNIT_JAR" https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.1/junit-platform-console-standalone-1.10.1.jar
fi

# Mark setup as done
cat > "$PATH_POINTER" <<EOF
# DO NOT CHANGE
POINTER=1
EOF

