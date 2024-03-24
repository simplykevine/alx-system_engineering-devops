# This Puppet manifest is to change the OS configuration
# to allow login with the holberton user and open a file
# without any error message.

# Ensure pam_limits package is installed
package { 'libpam-modules':
  ensure => installed,
}

# Ensure sudo package is installed
package { 'sudo':
  ensure => installed,
}

# Set file limits for the holberton user
file { '/etc/security/limits.d/holberton.conf':
  ensure  => file,
  content => "holberton hard nofile 4096\nholberton soft nofile 1024",
}

# Executing the following commands to update the pam_limits configuration
exec { 'update_pam_limits':
  command => 'echo "session required pam_limits.so" >> /etc/pam.d/common-session',
  path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  unless  => 'grep -q "session required pam_limits.so" /etc/pam.d/common-session',
}

# Applying changes to the holberton user
user { 'holberton':
  ensure     => present,
  managehome => true,
  groups     => ['sudo'],
  require    => [Package['libpam-modules'], Package['sudo']],
}

# Restarting the holberton user's session
exec { 'restart_holberton_session':
  command     => '/bin/su - holberton -c "true"',
  refreshonly => true,
  require     => [User['holberton'], Exec['update_pam_limits']],
}
