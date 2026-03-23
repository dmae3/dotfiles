# Homebrew (Apple Silicon)
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew

# Custom local bin
fish_add_path $HOME/local/bin

# Go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# MySQL 5.7
fish_add_path /usr/local/opt/mysql@5.7/bin
fish_add_path /opt/homebrew/opt/mysql-client/bin

# Dart pub-cache
fish_add_path $HOME/.pub-cache/bin

# Java (Android Studio)
set -gx JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
fish_add_path $JAVA_HOME/bin
