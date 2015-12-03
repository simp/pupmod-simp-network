Summary: Host Network Puppet Module
Name: pupmod-network
Version: 4.1.0
Release: 5
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-simplib >= 1.0.0-0
Requires: pupmod-simpcat >= 3.4
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-network-test

Prefix: /etc/puppet/environments/simp/modules

%description
This Puppet module provides the capability to configure host networking.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/network

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/network
done

mkdir -p %{buildroot}/usr/share/simp/tests/modules/network

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/network

%files
%defattr(0640,root,puppet,0750)
%{prefix}/network

%post
#!/bin/sh

if [ -d %{prefix}/network/plugins ]; then
  /bin/mv %{prefix}/network/plugins %{prefix}/network/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Mon Nov 09 2015 Chris Tessmer <chris.tessmer@onypoint.com> - 4.1.0-5
- migration to simplib and simpcat (lib/ only)

* Fri Mar 06 2015 Chris Tessmer <chris.tessmer@onyxpoint.com> - 4.1.0-4
- Fixed bug in network::add_eth that trashed bonded nics.

* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-3
- Changed puppet-server requirement to puppet.

* Fri Sep 05 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-2
- No longer require MAC/Hardware addresses for non-physical interfaces.

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-1
- Removed MD5 file checksums for FIPS compliance.

* Mon Mar 03 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-0
- Refactored manifests to pass all lint tests for hiera and puppet 3 compatibility.
- Added rspec tests for test coverage.
- Removed RedHat references as there are no other current options.

* Mon Oct 07 2013 Kendall Moore <kmoore@keywcorp.com> - 3.0.0-2
- Updated all erb templates to properly scope variables.

* Thu Oct 03 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 3.0.0-1
- Use 'versioncmp' for all version comparisons.

* Tue Sep 24 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 3.0.0-0
- Added the ability to set a boolean, network::auto_restart, to
  indicate whether or not to automatically restart the network.
  interfaces on configuration change.
- Note: This will still run the restart exec but it changes the exec
  method to /bin/true. This is so that all dependencies work properly.

* Tue Sep 24 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.0.0-17
- Added PERSISTENT_DHCLIENT support to network::redhat::global.

* Tue Aug 06 2013 Nick Markowski <nmarkowski@keywcorp.com> - 2.0.0-16
- network::redhat::add_eth now sets ipv6_privacy to rfc3014 by default.

* Mon Aug 05 2013 Kendall Moore <kmoore@keywcorp.com> - 2.0.0-15
- Updated the documentation to include support for multiple static routes in
  the network::route::add definition.

* Thu Apr 11 2013 Maintenance
2.0.0-14
- Now restart the specified add_eth interface if slave != ''.

* Thu Jan 03 2013 Maintenance
2.0.0-13
- Updated the module to make MAC address specification completely optional.
  * blank => autodiscover
  * something with ':' => MAC address
  * anything else => Leave it blank

* Fri Nov 30 2012 Maintenance
2.0.0-12
- Created a Cucumber test to ensure that the network service is running and that
  there are network interfaces currently up.
- Created a Cucumber test to add a bridge interface using the network::redhat::add_eth
  definition and check to make sure that interface is brought up after a puppet run.
- Updated to require pupmod-common >= 2.1.1-2 so that upgrading an old
  system works properly.

* Thu Nov 08 2012 Maintenance
2.0.0-11
- Updated the bonding settings to move the options to the sysconfig file
  instead of modprobe.d.

* Mon Jul 09 2012 Maintenance
2.0.0-10
- Ensure that subinterfaces and VLANs are properly handled when restarting or
  deleting interfaces.

* Thu Jun 07 2012 Maintenance
2.0.0-9
- Ensure that Arrays in templates are flattened.
- Call facts as instance variables.
- Added the ability to delete network interfaces.
- Moved mit-tests to /usr/share/simp...
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
2.0.0-8
- Added a default timeout variable to the DHCP args set very high so
  that systems do not, by default, time out before the DHCP server
  boots.
- Improved test stubs.

* Mon Dec 26 2011 Maintenance
2.0.0-7
- Updated the spec file to not require a separate file list.

* Mon Dec 05 2011 Maintenance
2.0.0-6
- Fixed the modprobe portion of bonding.
- Added a script to safely restart the network *after* the current puppet run.
  This prevents issues with the network restarting and ending up with a partial
  puppet run.

* Sat Nov 19 2011 Maintenance
2.0.0-5
- Removed the false dependency on the interface being named 'eth*' in eth.erb
  since this can interfere with user choice.
- Fixed a long-standing bug with global.erb where the 'networkdelay' option
  wasn't properly output.
- Updated so that interfaces that are not currently up will not be started by
  the network restart exec.
- Fixed the bonding template so that it properly puts the options on the
  separate line.
- Updated the destination of the modprobe file when bonding to sit as
  /etc/modprobe.d/<interface>.conf

* Wed Nov 09 2011 Maintenance
2.0.0-4
- Fixed a typo in the bonding erb template.
- Document the 'bonding' variable.
- Add support for MACADDR

* Mon Oct 31 2011 Maintenance
2.0.0-3
- Ensure that you don't have to specify a MAC address when using a bonded
  interface.

* Mon Oct 10 2011 Maintenance
2.0.0-2
- Updated to put quotes around everything that need it in a comparison
  statement so that puppet > 2.5 doesn't explode with an undef error.

* Fri Feb 11 2011 Maintenance
2.0.0-1
- Updated to use concat_build and concat_fragment types.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Oct 26 2010 Maintenance - 1-1
- Converting all spec files to check for directories prior to copy.

* Fri May 21 2010 Maintenance
1.0-0
- Code and doc refactor.

* Fri Feb 05 2010 Maintenance
0.1-2
- Added most of the useful settings to the Ethernet management defines.

* Thu Jan 28 2010 Trevor Vaughan <tvaughan@onyxpoint.com> - 0.1-1
- Enabled network bridge creation and application. You *must* specify a bridge
  together with a bridged interface for this to work correctly.  Not doing this
  may kill your network connection.
- Added the $delay option to the add_eth define to support bridging dhcp.
- Fixed the add_eth define to include NETWORK instead of NETWORKING.
