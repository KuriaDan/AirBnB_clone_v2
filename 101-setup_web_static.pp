#!/usr/bin/env puppet

# Install Nginx if it's not already installed
package { 'nginx':
  ensure => 'installed',
}

# Create the /data/ folder if it doesn't exist
file { '/data/':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
}

# Create the /data/web_static/ folder if it doesn't exist
file { '/data/web_static/':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

# Create the /data/web_static/releases/ folder if it doesn't exist
file { '/data/web_static/releases/':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

# Create the /data/web_static/shared/ folder if it doesn't exist
file { '/data/web_static/shared/':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

# Create the /data/web_static/releases/test/ folder if it doesn't exist
file { '/data/web_static/releases/test/':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}

# Create a fake HTML file /data/web_static/releases/test/index.html
file { '/data/web_static/releases/test/index.html':
  ensure  => 'file',
  content => '<html><body>Test</body></html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
}

# Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test/',
  force  => true,
}

# Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
file { '/etc/nginx/sites-enabled/default':
  ensure  => 'file',
  content => '
  server {
      listen 80 default_server;
      listen [::]:80 default_server;
      root /data/web_static/current;
      index index.html;
      server_name _;
      location /hbnb_static {
           alias /data/web_static/current/;
      }
  }
  ',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx after updating the configuration
service { 'nginx':
  ensure => 'running',
  enable => true,
}
