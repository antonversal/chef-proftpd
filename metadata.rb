maintainer        "Anton Versal"
maintainer_email  "ant.ver@gmail.com"
license           "MIT"
description       "Installs and configures proftpd"
version           "0.0.1"

recipe "proftpd::source", "Installs proftpd from source and sets up configuration"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end

%w{ build-essential runit }.each do |cb|
  depends cb
end

attribute "proftpd/dir",
  :display_name => "proftpd directory",
  :description => "Location of proftpd configuration files",
  :default => "/etc/proftpd"


attribute "proftpd/binary",
  :display_name => "Proftpd Binary",
  :description => "Location of the proftpd server binary",
  :default => "/usr/sbin/proftpd"