PluginAssets
============

It's a plugin for plugins.  It allows plugin "engine" developers to supply image, javascript and stylesheet assets in a public directory inside their plugin that "just work" without having to copy those assets over to the app's main public directory with rake tasks or installation scripts, which is stupid.

In short, it responds to "missing" asset URLs (like /stylesheets/foo.css, /images/foo.png, /javascripts/foo.js) when the web server can't find the file in the public directory, and tries to find a matching file in your plugins and pass that back to the browser through Rails. 


Example
-------

Let's assume you have the following plugins installed:

* RAILS_ROOT/vendor/plugins/plugin_123
* RAILS_ROOT/vendor/gems/plugin_456

Rails would establish the following view paths:

* RAILS_ROOT/app/views
* RAILS_ROOT/vendor/plugins/plugin_123/app/views
* RAILS_ROOT/vendor/gems/plugin_456/app/views

PluginAssets takes these "view paths" and builds the same thing for "public paths" (public directories inside plugins), like this:

* RAILS_ROOT/vendor/plugins/plugin_123/public
* RAILS_ROOT/vendor/gems/plugin_456/public

Given a request for "/stylesheets/foo/bah.css", the web server would first look for "bah.css" in "RAILS_ROOT/public/foo/bah.css".  If that resource doesn't exist, the request would usually be passed through to Rails, which will try to route the request to a controller action and eventually respond with a 404 (file not found).

Instead, this plugin sets up a controller and appropriate routing to handle the request, searching for the file in your plugins and gem plugins.  In this case, it would search for "bah.css" in the following locations:

* RAILS_ROOT/vendor/plugins/plugin_123/public/stylesheets/foo/bah.css
* RAILS_ROOT/vendor/plugins/plugin_456/public/stylesheets/foo/bah.css

As soon as a matching file is found, it's passed back to the browser with the correct mime type.  If none of the plugins have such a file, the regular Rails 404 response for a missing template is invoked.

It works for plugins and gem plugins. It works for the following URLs:

* /images/*
* /stylesheets/*
* /javascripts/*

One day I'll make it configurable for other assets, but in the meantime it's easy to hack/fork.


Caveats
-------

PluginAssets leverages the view_paths array used by Rails plugins that supply their own views.  Rails plugins and gems are only added to the view_paths array automatically if there's an app/views directory inside the plugin.  If you're supplying public assets, chances are pretty good you're supplying views too, so that probably isn't a big deal.


Isn't it inefficient?
---------------------

Yes, it's probably inefficient to go looking through the filesystem and pass the asset back through a Rails request over and over, but this problem should be solved with caching and appropriate response headers, not by copying files around through rake tasks and installer scripts.


There's Still Plenty To Do!
---------------------------

I wrote this on the train this morning as a proof of concept, so there's a long list:

* It should be a gem plugin, so that other gem plugins can list it as a dependency
* I haven't written any tests
* I haven't tackled caching yet (probably need to do both page caching and header response caching)
* Thinking this could be Rack middleware or Rails Metal rather than a full Rails request stack.

I actually want to see this in Rails core, so help me make it awesome!


Etc
---

PluginAssets is Copyright (c) 2009 Justin French, released under the MIT license.  Your feedback, forking and contributions are greatly welcomed.