Audio Player
============

This extension for Radiant adds a Flash audio player plugin which can be embedded on the pages of your site. It adds an "Audio" tab to the admin area, where mp3 files may be uploaded.

Installation
------------

This extension is hosted on github. If you don't have git installed, see below. 

If you have git installed,1 `cd` to the root of your radiant project and issue this command: 

    git clone git://github.com/nelstrom/radiant-audio_player-extension.git vendor/extensions/audio_player

From your radiant application root run the install task:

    rake (production) radiant:extensions:audio_player:install

Next, run the demo task (optional):

    rake (production) radiant:extensions:audio_player:demo

This creates an Audio page, with example usage of the Radius tags provided in this extension.

Installing without git
----------------------

If you don’t have git, then you can download the tarball from this URL:

    http://github.com/nelstrom/radiant-audio_player-extension/tarball/master

and expand the contents to `your-radiant-project/vendor/extensions/audio_player`. Proceed by running the `install` and `demo` tasks, as directed above.

Credits
-------

The flash player was created by [Martin Laine][1].
This extension was conceived and designed be Andrew Neil. With thanks to Anna Neil for sponsoring it.

[1]: http://www.1pixelout.net/code/audio-player-wordpress-plugin/