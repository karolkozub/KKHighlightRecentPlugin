KKHighlightRecentPlugin
=======================

Important
---------

The plugin doesn't work with Xcode 7 or higher due to changes in the way highlighting is implemented there.

Description
-----------

This plugin subtly highlights recently selected files. For each file the highlight increases when it's selected, and decreases when it's not. This way the most highlighted files are the ones that were edited the longest and the most recenly.

![Screenshot](https://raw.githubusercontent.com/karolkozub/KKHighlightRecentPlugin/master/screenshot.png)

Although it seems to work reliably, it hasn't been thoroughly tested yet. I'm also still experimenting with the highlight increase and fade timing.

To draw the highlight this plugin completely hijacks the `drawsEmphasizeMarker` functionality of `DVTImageAndTextCell`s which doesn't seem to be ever used by Xcode itself, but may be used by some other plugins. Specifically it swizzles the `DVTTheme`s `greenEmphasisBox*Color` methods, making them return `[NSColor clearColor]` by default, so any other emphasis boxes will probably not be visible, at least not to human eyes.

Use [Alcatraz](http://alcatraz.io/) to intall/uninstall.
