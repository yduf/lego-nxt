# Lego NXT [![Gem Version](https://badge.fury.io/rb/lego-nxt.png)](http://badge.fury.io/rb/lego-nxt) [![Build Status](https://travis-ci.org/nathankleyn/lego-nxt.png)](https://travis-ci.org/nathankleyn/lego-nxt) [![Code Climate](https://codeclimate.com/github/nathankleyn/lego-nxt.png)](https://codeclimate.com/github/nathankleyn/lego-nxt) [![Coverage Status](https://coveralls.io/repos/nathankleyn/lego-nxt/badge.png)](https://coveralls.io/r/nathankleyn/lego-nxt) [![Dependency Status](https://gemnasium.com/nathankleyn/lego-nxt.png)](https://gemnasium.com/nathankleyn/lego-nxt)

> **This gem is under heavy development!** A lot of the below code may not work, and is certainly not guranteed to be reliable if it does! If you need to base a working project on this, I recommend [going back to the `ruby-nxt` gem this work is inspired by](https://github.com/zuk/ruby-nxt) for the time being.

Control a Lego NXT 2.0 brick using Ruby code. This library works by piping commands over a Bluetooth or USB connection to the brick, allowing you to write Ruby scripts to control your NXT brick.

This project used to be based on "ruby-nxt", and Tony Buser's subsequent rewrite "nxt". It is now a complete rewrite, based heavily in some parts on the aforesaid projects internally, but with a brand new external API that should prove cleaner and easier to work with.

This code implements direct command, as outlined in "Appendix 2-LEGO MINDSTORMS NXT Direct Commands.pdf". Not all functionality is implemented yet!

## Getting Started

### Installing This Library

Install the gem:

```sh
gem install lego-nxt
```

Add it as a Bundler dependency as you see fit!

### Connect to Your NXT Brick

In order to start coding with your NXT, you'll need to set up either a USB or Bluetooth connection to it. Follow one of the below sets of steps; if you go for a Bluetooth connection, you'll need to remember the `/dev/*` address you end up using, as you'll need to provide it when making a connection with this library.

#### Connecting Via USB

Simply plug in the NXT, and that's it! This library will take care of enumerating the USB host devices to find the NXT device for you, no effort required on your behalf!

#### Connecting Via Bluetooth

##### Linux

Make sure you have the `bluez` package installed, which should include the `rfcomm` and `hcitool` commands. We start by searching for the MAC address of our NXT:

```sh
$ hcitool scan
  Scanning ...
      90-8E-E0-C1-2A-7B       NXT
```

Then open the `/etc/bluetooth/rfcomm.conf` file and add an entry as follows:

```
rfcomm0 {
  bind yes;
  # Bluetooth address of the device
  device 90-8E-E0-C1-2A-7B;
  # RFCOMM channel for the connection
  channel 1;
  # Description of the connection
  comment "NXT";
}
```

If you're on a distro which has a Bluetoth daemon running automatically, you can simply restart it. For Ubuntu, that will look something like:

```sh
$ sudo /etc/init.d/bluez-utils
```

On other distros where you manage the Bluetooth daemon yourself, you'll need to do the bind calls yourself:

```sh
$ sudo rfcomm bind /dev/rfcomm0 '90-8E-E0-C1-2A-7B'
```

After that, the Bluetooth connection should be established. Check that by running the `rfcomm` command with no arguments:

```sh
$ rfcomm
rfcomm0: 90-8E-E0-C1-2A-7B channel 1 clean
```

The NXT should now be accessible from `/dev/rfcomm0`!

##### Mac OS X

Turn on the NXT and make sure Bluetooth is turned on. Click the bluetooth icon in the menubar of your Mac and select "Setup bluetooth device". It will prompt you for a device type; choose "Any device". Select the NXT from the list and click continue.

The NXT will beep and ask for a passkey. Choose `1234` and press orange button. Enter the `1234` passcode on your Mac when promted. The NXT will beep again; press the orange button to use `1234` again.

Your Mac will then alert you that "There were no supported services found on your device". Ignore and click "Continue", followed by "Quit".

Now click the Bluetooth icon and select "Open bluetooth preferences"; you should see the NXT listed. Select it, then click "Edit Serial Ports".
It should show `NXT-DevB-1`; if not, click "Add", and use:

```
Port Name: NXT-DevB-1
Device Service: Dev B
Port type: RS-232
```

Click "Apply". The NXT should now be accessible from `/dev/tty.NXT-DevB-1`!

## Documentation and Examples

The NXT project has been heavily documented using nice, clean, human readable markdown. YARD is used to generated the docs, and the options have been included in our `.yardopts` file, so simply run a YARD server to read them:

```sh
$ yard server
```

This documents the API, both internal and external. For bite-sized chunks of NXT code that is much more appropriate for beginners, [have a look at the examples](https://github.com/nathankleyn/nxt/tree/master/examples).

In addition to this, you might find the tests quite helpful. There are currently only RSpec unit tests, which can be found in the [`spec`](spec) directory; the plan is to add some decent feature tests soon.

## License

The MIT License

Copyright (c) 2014 Nathan Kleyn

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
