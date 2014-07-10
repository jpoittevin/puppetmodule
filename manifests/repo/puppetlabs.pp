#"
# This module is used to setup the puppetlabs repos
# that can be used to install puppet.
#
class puppet::repo::puppetlabs (
  $ensure = present,
) {

  case $::osfamily {
    'Debian': {
      apt::source { 'apt.puppetlabs.com':
        ensure    => $ensure,
        location  => 'http://apt.puppetlabs.com/',
        release   => $::lsbdistcodename,
        repos     => 'main dependencies',
        key       => '4BD6EC30',
      }
    }
    'Redhat': {
      if $::operatingsystem == 'Fedora' {
        $ostype='fedora'
        $prefix='f'
      } else {
        $ostype='el'
        $prefix=''
      }
      yumrepo { 'puppetlabs-deps':
        ensure   => $ensure,
        baseurl  => "http://yum.puppetlabs.com/${ostype}/${prefix}\$releasever/dependencies/\$basearch",
        descr    => 'Puppet Labs Dependencies $releasever - $basearch ',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
      }

      yumrepo { 'puppetlabs':
        ensure   => $ensure,
        baseurl  => "http://yum.puppetlabs.com/${ostype}/${prefix}\$releasever/products/\$basearch",
        descr    => 'Puppet Labs Products $releasever - $basearch',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
