# Animal Crossing Desktop Clock for KDE Plasma

The 2005 *Animal Crossing Desktop Clock* from Nintendo, ported to Linux as a KDE Plasma 6 widget.

The clock shows the month and day, day of the week, and time on rolling digits, all recreated and scaled from the original artwork cleanly. Every change of the minute, hour, or date plays the same flip animation as the original, and the default town tune from *Animal Crossing* plays at the top of every hour.

![The clock flipping over to the next minute](demo.gif)

## Requirements

- KDE Plasma 6
- The Qt 6 Multimedia QML module, for the sounds (Arch `qt6-multimedia`, Fedora `qt6-qtmultimedia`, Debian and Ubuntu `qml6-module-qtmultimedia`, openSUSE `qt6-multimedia-imports`)

## Installing

Download the `.plasmoid` file from the latest release, then in Plasma open *Add Widgets → Get New Widgets → Install Widget From Local File* and select it. The widget can be placed on the desktop or on a panel.

The widget shows at the original's size by default; *Configure → General* scales it up by whole pixels so it stays crisp. The same page has the 24-hour option, the chime volume, quiet hours, and the colon blink.

The right-click menu keeps the original's *Alarm* toggle, which turns the hourly chime on and off, and includes *Play the town chime* for when you want to hear it on demand.

To install straight from this repo instead of a release file:

```sh
kpackagetool6 --type Plasma/Applet --install .
```

## About the Network Evaluation page

In the summer of 2005, Nintendo of America distributed this desktop widget as an incentive for participating in a ten-minute connectivity test for the Nintendo Wi-Fi Connection, prior to the service's official launch. The clock's *Network Evaluation* command asked a few questions about your router, pinged Nintendo's server to report the results. That service is long gone, so the *Network Evaluation* page in this widget's settings is a replica of the original dialog, rebuilt screen by screen from footage of the 2005 program. It includes the welcome text, the router survey, the firewall notice, the evaluation screen, and the message you get after aborting, with the original button artwork. It connects to nothing and sends nothing. Because the server no longer answers, the evaluation never completes; *Abort* takes you back to the start.

## History

The clock first shipped in February 2002 as *Doubutsu no Mori+ Desktop Clock* on the bonus CD-ROM of Shogakukan's *Nintendo Kōshiki Guidebook: Doubutsu no Mori+*. Nintendo of America localized it as *Animal Crossing Desktop Clock* in August 2005 for the Wi-Fi Connection test described above. The Japanese original had two settings, the hourly tune and always-on-top, which became the "Alarm" and "Display on top" items in the US version's menu.

## Licensing

The widget's code is released under the GNU General Public License, version 3 or later; see `LICENSE`. The artwork and sounds are © 2005 Nintendo, taken from the long-discontinued freeware clock, and are included here for personal use. They are not covered by the GPL and remain Nintendo's property.

---

*Animal Crossing* and *Doubutsu no Mori* are trademarks of Nintendo. This project is not affiliated with or endorsed by Nintendo.
