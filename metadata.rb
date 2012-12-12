maintainer        "Anton Versal"
maintainer_email  "ant.ver@gmail.com"
license           "MIT"
description       "Installs and configures proftpd"
version           "0.0.1"

recipe "proftpd::source", "Installs proftpd from source and sets up configuration"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ build-essential }.each do |cb|
  depends cb
end

attribute "proftpd/dir",
  :display_name => "proftpd directory",
  :description => "Location of proftpd configuration files",
  :default => "/etc/proftpd"

attribute "proftpd/log_dir",
  :display_name => "proftpd log directory",
  :description => "Location of proftpd log files",
  :default => "/var/log/proftpd"

attribute "proftpd/contrib_modules",
  :display_name => "contrib modules",
  :description => "list of proftpd contrib modules",
  :default => nil

attribute "proftpd/user",
  :display_name => "Proftpd user",
  :description => "User that runs proftpd service",
  :default => "proftpd"

attribute "proftpd/port",
  :display_name => "Server port",
  :description => "ftp server port, usually 21",
  :default => "21"

attribute "proftpd/max_instances",
  :display_name => "Maximum instances",
  :description => "Maximum number of child processes",
  :default => "30"

attribute "proftpd/umask",
  :display_name => "Umask",
  :description => "Umask",
  :default => "022"
