#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#*****************************************************************************
#
#   Gradle start up script for UN*X
#
#*****************************************************************************

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass any JVM options to this script.
DEFAULT_JVM_OPTS=""

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
  NONSTOP* )
    nonstop=true
    ;;
esac

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done

SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

# For Cygwin, switch paths to Windows format before running java
if $cygwin ; then
    APP_HOME=`cygpath --path --windows "$APP_HOME"`
    CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
    CYGHOME=`cygpath --path --windows "$HOME"`
fi

# Read `gradle.properties` for JVM settings
if [ -f "$APP_HOME/gradle.properties" ] ; then
    while IFS= read -r prop; do
        case $prop in
            "org.gradle.jvmargs"*) 
                prop_value=${prop#*=}
                # Remove leading/trailing whitespaces
                prop_value=`echo $prop_value | xargs`
                GRADLE_OPTS=$prop_value
                ;;
        esac
    done < "$APP_HOME/gradle.properties"
fi

# Collect all arguments for the java command.
#
# (see http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html
#      http://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html)
#
# `java_args` are for the client VM being launched.
#
# Collect all JVM options in GRADLE_OPTS.
# (This is for backwards compatibility, to have a single variable to collect all options.)
GRADLE_OPTS="$GRADLE_OPTS $DEFAULT_JVM_OPTS"

# Add -Dorg.gradle.appname=... to GRADLE_OPTS
GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.appname=$APP_BASE_NAME"

# Add system properties from JAVA_OPTS
GRADLE_OPTS="$GRADLE_OPTS $JAVA_OPTS"

# Split GRADLE_OPTS into separate args, respecting quotes.
eval "set -- $GRADLE_OPTS"
java_args=()
for arg in "$@" ; do
    java_args=("${java_args[@]}" "$arg")
done

# Find the wrapper JAR.
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

# Build the classpath
CLASSPATH="$WRAPPER_JAR"

# Set the maximum number of file descriptors, if necessary.
if [ "$MAX_FD" != "maximum" -a "$MAX_FD" != "default" ] ; then
    ulimit -n $MAX_FD
fi

# The following section is to find a suitable Java executable.
#
# We can be launched with JAVA_HOME pointing to a JRE, or a JDK, or no
# JAVA_HOME at all.
#
# If JAVA_HOME is not set, we are going to look for a `java` executable on the
# PATH.
#
# If JAVA_HOME is set, we are going to use it.

# Check for a `java` executable
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/bin/java" ] ; then
        JAVACMD="$JAVA_HOME/bin/java"
    else
        echo "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
        echo "Please set the JAVA_HOME variable in your environment to match the"
        echo "location of your Java installation."
        exit 1
    fi
else
    if command -v java >/dev/null 2>&1; then
        JAVACMD=java
    else
        echo "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH."
        echo "Please set the JAVA_HOME variable in your environment to match the"
        echo "location of your Java installation."
        exit 1
    fi
fi

# Execute Gradle
exec "$JAVACMD" "${java_args[@]}" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"