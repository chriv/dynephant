#Dynephant

Dynephant is a simple, open-source Dynamic DNS (DDNS) client for
Windows. It is intended to have as few dependencies as possible. It
was written, because, at the time of it's creation, very few DDNS
services had support for IPv6. More specifically, dynv6.com, a DDNS
service, had support for IPv6, but no real Windows client.

Currently, Dynephant only supports dynv6.com, but could easily be
adapted to work with other DDNS services as well.

Dynephant should run on most reasonably current versions of Windows
(and even some not so reasonably current). It requires valid IPv4 and
IPv6 TCP/IP stacks. To work correctly, it requires a working Internet
connection with support for IPv4 and IPv6. It contacts the dynv6.com
service via HTTPS (depending on Internet Explorer 3 or greater, which
should be present in all reasonably current versions of Windows).

It can be run either as an AutoIt3 script (requiring AutoIt3 to be
installed), or a pre-compiled executable (requiring no runtime not
already part of Windows). The dependency on IE for HTTPS creates
some intrinsic limitations on reporting of errors (namely, that
errors are known, but the cause is not automatically).

CLI and GUI, 32-bit and 64-bit versions are provided. Use the CLI
version if you want to monitor or redirect the stderr stream into
a log file. Use the GUI version if you want the program to run
without leaving a Command Prompt open.

##Table of Contents

* [Prerequisites](#prerequisites)
* [License](#license)
* [Usage](#usage)

##Prerequisites

* A relatively current version of Windows
* Internet Explorer 3 or higher installed

##Build requirements (if you want to build .exe from source)

* AutoIt3 (https://www.autoitscript.com)
* AutoIt3Wrapper (part of AutoIt3 by default)
* Au3Check (part of AutoIt3 by default)
* Tidy (part of AutoIt3 by default)
* GnuWin32's sed utility (http://gnuwin32.sourceforge.net/packages/sed.htm)
* Optional: Valid Code-signing certificate / key
* Optional: Windows 10 SDK's signtool (https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk)
* Optional: Working internet connection (needed to have signed timestamp on .exe files)
* Optional: NSIS's makensis (http://nsis.sourceforge.net/Download) (needed to build setup)

##License

Dynephant is licensed using the (extremely permissive) MIT license.
See the LICENSE.txt file.

The included icon is courtesy of http://www.how-to-draw-funny-cartoons.com
(link back required by author if used)

##Usage

First, you need an account with dynv6.com, with at least one host.

Once you have an account with dynv6.com, find your host name and
authentication token.

The command line arguments are:
* -host=\<hostname\>               host name to update on DDNS service
* -token=\<authentication_token\>  authentication token for host name to be updated
* -4                             update DNS A record with IPv4 address
* -6                             update DNS AAAA record with IPv6 address
* -daemon=\<seconds\>              number of seconds to wait between updates

-host and -token are required. Either or both -4 or -6 are required.
Not setting -daemon results in only one update (or attempt) occurring.
Setting -daemon to less than 300 seconds (5 minutes) results in the default
of 1800 seconds (30 minutes) being used.
-host takes only the host name (leave off the dynv6.net part), not the FQDN.

The following example assumes your Fully Qualified Domain Name (FQDN)
for your host name is foobar.dynv6.net, and your authentication token
is randomtextforfoobarhere:

If you want Dynephant to automatically periodically set the AAAA
(IPv6 Address) record, but not the A (IPv4 Address) record for your host
every 10 minutes (600 seconds), you would run Dynephant with the
following command:

```bat
dynephant -host=foobar -token=randomtextforfoobarhere -6 -daemon=600
```

The update_foobar.dynv6.net.bat file contains the following example
of using the CLI version with logging.
```bat
C:\dynephant\dynephant-cli -6 -daemon=600 -host=foobar -token=randomtextforfoobarhere 1>C:\dynephant\dynephant-foobar.log 2>&1
```
Only use a CLI version if you need monitoring or logging, as it stays
running in a Command Prompt window. It is possible to run the cli
version in a hidden window using a third-party utility to launch it.
Here's a one-line example using Sysinternal's psexec utility to run
the batch file update_foobar.dynv6.net.bat as the Windows System
user to effectively hide the Command Prompt window:
```bat
psexec /accepteula -s -d c:\dynephant\update_foobar.dynv6.net.bat
```
Example Windows Shortcuts for launching the GUI version with command
line parameters are included in the installation directory.
