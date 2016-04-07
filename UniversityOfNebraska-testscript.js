
var target = UIATarget.localTarget();
var mainWindow = target.frontMostApp().mainWindow();
//tap the map button
mainWindow.buttons()[0].tap();

var startingLocation = { latitude : 40.7826861, longitude : -96.6657829 };
var startingOptions = {speed:1, altitude:200, horizontalAccuracy:5, verticalAccuracy:5};

target.setLocationWithOptions(startingLocation,startingOptions);

// Locations below are based on this google map: https://www.google.com/maps/d/edit?mid=zWx9ykQfubQ8.k4-TJB16tsJs&usp=sharing
// speed is in meters/sec
var points = [
              { location : { latitude : 40.7826861, longitude : -96.6657829 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.7907445, longitude : -96.6632938 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.7917842, longitude : -96.6967678 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8091969, longitude : -96.6968536 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8136144, longitude : -96.6940212 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8208245, longitude : -96.6965961 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8208245, longitude : -96.6823483 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8207596, longitude : -96.6538525 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8338139, longitude : -96.6625214 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8196554, longitude : -96.7033768 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.7844211, longitude : -96.6656693 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.7907445, longitude : -96.663282 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.7917707, longitude : -96.6967312 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8091766, longitude : -96.6968539 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8135842, longitude : -96.6940213 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8208218, longitude : -96.6965493 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.820825, longitude : -96.6823987 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8207596, longitude : -96.653822 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              { location : { latitude : 40.8340343, longitude : -96.6631742 },
              options: {speed:8, altitude:200, horizontalAccuracy:10, verticalAccuracy:15} },
              ];

//set the app to watch for the Univerity of Nebraska location
mainWindow.buttons()["Enable Geofencing"].tap();

//uncomment this line to see the elements of the UI in the trace log
//mainWindow.logElementTree();

var approachingLabelText;
var approachingLogicWorked;
var leavingLogicWorked;

//now "drive"
for (var i = 0; i < points.length; i++){
    target.setLocationWithOptions(points[i].location,points[i].options);

    //check the value of the label that changes 
    approachingLabelText = mainWindow.staticTexts()[0].value();

    if(approachingLabelText == "You're approaching the area"){
        
        approachingLogicWorked = true;
        
        UIALogger.logDebug("Approaching area label was displayed");
        target.delay(5);
        
    }else if(approachingLabelText == "You're leaving the area"){
        
        if(!leavingLogicWorked){
            target.delay(5);
        }
        
        leavingLogicWorked = true;
        UIALogger.logDebug("Leaving area label was displayed");
        
    }else{
        UIALogger.logDebug("Not yet");
        target.delay(2);
    }
    
    target.captureScreenWithName("location changed");
}


if(approachingLogicWorked){
    UIALogger.logPass("Region monitoring logic passed");
}
else{
    UIALogger.logFail("Region monitoring logic failed");
}

UIALogger.logPass("Routing was successful!");
