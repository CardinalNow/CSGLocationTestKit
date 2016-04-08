CSGLocationTestKit
==================
This is a sample project originated to supplement two blog posts written for Cardinal Solutions Group. 

The supporting posts can be found here:

[How to Use Location Services in iOS](http://www.cardinalsolutions.com/blogs/mobile/2012/12/how_to_use_location.html)

[Testing a Location Aware App](http://tech.prandom.com/blog/?p=356)

Background
===
Many applications have requirements around detecting a user's location to support a variety of scenarios. 

Scenarios for Location-Awareness

* Directions and wayfinding
* Providing a different experience
* Enabling new content

Testing location-aware applications can be very challenging, especially if your application is used nationally or globally. Manual testing generally consists of taking the app (and possibly a laptop) out on a drive to verify functionality. While this approach works, it has several problems:

* Lacks consistancy - how do you know/guarantee you're executing the same test every time?
* Requires a lot of QA and dev time - 2 people for every test!
* Could be very expensive - how do you test features in Paris vs. Rome vs. New York City?
* Doesn't scale - not only do you have to test new features, but you have to regression test features every time you make changes!

Apple has provided some mechanisms to simulate locations, which help to alleviate the problems listed above. We have created this code sample to supplement a 2-part blog post series that covers enabling and testing location-aware application using these mechanisms. 

GPX Files
===

[GPX (GPS exchange)](http://www.topografix.com/gpx.asp) files are XML files that conform to the GPX schema, which allows interchanging of GPS data. GPS systems generate and consume this format, and so does Xcode! This is core to how you can simulate locations and routes in Xcode.

You could load any set of GPX files into the simulator to meet your needs. Generating a GPX file by hand can be tedious but don't worry! There are tools for that too. [GPS Visualizer](http://www.gpsvisualizer.com/draw/) is a handy mapping tool that lets you generate GPX files from waypoints and such on a map. Simply add waypoints to your map using the toolbar. Once you have all your waypoints, click the "Download GPX" file button to get a link to the file. 

Note: Xcode tools require waypoints. That means the location simulation is between the waypoints "as the crow flies" (i.e. a straight line between the points). Road routes consist of trackpoints. However, trackpoints are not supported by the Apple tools, so don't even bother with them. 

How to Use This Code Sample
===
This sample iPhone application consists of 2 basic screens that support some basic location functions. 

1. The first screen detects your location, and displays the coordinates.
2. The second screen has a map with a "central" pin, a region around the pin, and the current location. 

The first screen is really just a validation screen. If you run the project as it is, the shared scheme defaults the simulator's location to coordinates in Lincoln, NE, USA as specified in the [LincolnNE.gpx file](https://github.com/CardinalNow/CSGLocationTestKit/blob/master/CSGLocationTestKit/gpx/LincolnNE.gpx) included with the project.

The second screen is where you can do a bit more with region monitoring. The coordinate and region are hardcoded within the app to be a coordinate in Lincoln, NE and a radius of 500m around that coordinate. Enable region monitoring by tapping the "Enable Geofencing" button. Since the simulator is still simulating only 1 location, not much will happen. 

While the application is running in the simulator, switch back to Xcode. In the Debug Area (bottom of the Xcode window), click the blue location arrow to open the "Simulate Location" menu. Select "UniversityOfNebraska" to change the GPX file that is loaded into the simulator. Switch back to the simulator, and you should see the current location dot moving around the map. As it nears and leaves the region being monitored, the label text and appearance will change accordingly. 

//TODO Add Instrument Instruction
