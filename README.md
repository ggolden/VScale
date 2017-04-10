# VScale
Virtual Model Railroading

> All code in this repository is Copyright © 2017 Glenn R. Golden. All rights reserved.

> This code is not (currently) open source.If you are interested, please contact me.

### Virtual Model Railroading

I think it would be very cool cool to capture the whole model railroading experience in a virtual environment.

Instead of modeling in HO scale or N scale, try  modeling in Vscale.  Virtual model railroading.

### Technology

Vscale would cross platforms and devices and the cloud.  It can involve AR and VR, too.

Imagine setting up a model railroad on your iPad pro, sharing it with friends locally on your Apple TV, and bringing in friends in remote places through the cloud.  Imagine controlling your railroad using your IPhone and Apple Watch while you are viewing it on your Mac.

### Goal

I set out to answer a few questions:

* Can Apple technology, and SceneKit, pull off the real-time 3D modeling and physics necessary to do th?
* Can I program that technology to do this?
* Can I achieve a realistic looking and behaving model railroad, matching what an HO layout could look like and perform like?
* Can I design a building system that captures the process of real-world modeling in a virtual environment?
* Can I take advantage of multiple platforms, devices, and the cloud, to work together for a multi-device, multi-user experience?

If I can approach "yes" on these issues, I would have achieved, technically, my goals.

There's a big question remaining if I pull all that off:

* Would model railroaders want to use VScale?

This would determine if this has any commercial feasibility.  But at minimum, I know one person who would use this.  Me!

### State of the App

Right now, some of the basics are in place, running on IOS:

* We have a room in which to build our VScale model layout, complete with a bench for the layout, with a painted backdrop, a floor, a ceiling with lights, and walls with some picture hanging on them.
* We have the basic model for a track plan, including straights, curves, and turnouts.
* We have a nice rendering of track, with a pretty good emulation of official HO style rails, ties, and a roadbed with a stone texture.
* We have the basic idea of trains and train cars, with some goofy placeholder engines and cars to form into trains.  The engine has a camera and a light.
* We have basic speed control of the train, and its movement along the track, including turnout controls.
* We have the idea of structures and scenery, and a basic sample train platform to place either in the layout or at a distance along the track plan.
* We have a cute little avatar that can be positioned around the room, that has a camera and light, that we can choose to view the scene from.
* We have some basic controls, to select the view (engine, avatar, main or ceiling), control lighting, control engine speed, and cycle through some fixed turnout settings.
* It is all working with reasonable performance so far, getting over 60 FPS on the iPad pro.

It just looks a little funny with the placeholder backdrop, platform, engine and train cars!

### What's next

Oh, so very much!  Some of the giant ticket items include:

* Bringing in accurately modeled engines and train cars, scenery elements and structures.  I need to master some 3D modeling packages to do this.  There is also a marketplace for pre-made 3D models I might choose to shop in for some of this.
* Curves!  Curves are modeled right now with many short straight segments, due to how the track is being extruded from a bezier curve that forms the track cross-section.  The only extension is straight.  I need to find a way to generate curved track and roadbed that looks and performs well.
* Ground.  The ground is flat, as if we were modeling on foam board or plywood.  I need to find a way to generate textured, contoured ground.  I'm thinking there may be a ML application here - feed it lots of pictures of rolling hillsides and other ground cover, and see if we can generate new ones within parameters.
* Cloud.  I want a way to run an train operations session that is synchronized on multiple devices, perhaps at multiple locations.  While P2P might be interesting, a server in the cloud might work, to store the layout, store the state of all items, and communicate changes and velocities to all participants.  We could probably use some intercom feature so folks can chat while operating.
* Cross Device: My proof of concept here would be to setup a layout, run it full screen on Apple TV, control the trains, turnouts, and views on a number of iPhones and Apple Watches either cloud or local-network connected.
* Multi-User.  Once all this works, we can have modelers upload their layouts into the "Vscale Model Railroading Club", where the public could visit the layout and watch (or initiate) operations.  Clubs could upload a layout and then hold operating sessions, without having to come physically together.

### Screen Shots

* main view

![VScale main view screen shot](https://raw.githubusercontent.com/ggolden/Vscale/master/screen_shots/20170410_main_view.png)

* sky view

![Vscale sky view screen shot](https://raw.githubusercontent.com/ggolden/Vscale/master/screen_shots/20170410_sky_view.png)

* engine view (notice the Avatar, luxo-lamp looking dude)

![Vscale engine view screen shot](https://raw.githubusercontent.com/ggolden/Vscale/master/screen_shots/20170410_engine_view.png)

* at the platform (view from the Avatar)

![Vscale platform view screen shot](https://raw.githubusercontent.com/ggolden/Vscale/master/screen_shots/20170410_platform.png)

* on a siding (view from the Avatar)

![Vscale siding view screen shot](https://raw.githubusercontent.com/ggolden/Vscale/master/screen_shots/20170410_siding.png)
