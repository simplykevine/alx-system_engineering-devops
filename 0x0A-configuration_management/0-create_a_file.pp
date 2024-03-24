# Using Puppet, create a file in /tmp
$file_path = '/tmp/school'
file { $file_path:
  ensure  => 'file',
  content => 'I love Puppet',
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0744',
}
