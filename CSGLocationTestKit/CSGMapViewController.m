//
//  CSMapViewController.m
//  CSLocationTestKit
//
//  Created by rachel parsons on 1/31/13.
//  Copyright (c) 2013 Cardinal Solutions. All rights reserved.
//

#import "CSGMapViewController.h"

@interface CSGMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UILabel *almostThereView;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation CSGMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.locationManager = [CSGLocationManager sharedInstance];
    
    [self zoomInOnCoordinate];
    [self initiateCoordinate];
    [self dropPinForCoordinate];
    [self dropCircleAroundPin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_ENTERED_REGION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:USER_LEFT_REGION object:nil];
}

#pragma mark - Map build out methods

-(void)zoomInOnCoordinate{
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    CLLocationCoordinate2D centeringCoord = self.locationManager.currentLocation.coordinate;
    self.mapView.region = MKCoordinateRegionMake(centeringCoord, span);
}

-(void)initiateCoordinate{
    self.coordinate = CLLocationCoordinate2DMake(40.819204, -96.698171);
    [self.mapView setCenterCoordinate:self.coordinate];
}

-(void)dropPinForCoordinate{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.coordinate];
    [annotation setTitle:@"Central Point of Region Monitoring"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
}

-(void)dropCircleAroundPin{
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:500];
    [self.mapView addOverlay:circle];
}

#pragma mark - Notification handling

-(void)userEnteredRegion:(NSNotification*)notification{
    self.almostThereView.text = @"You're approaching the area";
    self.almostThereView.accessibilityValue = self.almostThereView.text;
	
	[UIView animateWithDuration:1.5 animations:^{
        self.almostThereView.alpha = 1;
    }];
}

-(void)userLeftRegion:(NSNotification*)notification{
	self.almostThereView.text = @"You're leaving the area";
	self.almostThereView.accessibilityValue = self.almostThereView.text;
	
	[UIView animateWithDuration:1.5 animations:^{
		self.almostThereView.alpha = 0.1;
	}];
	
}

#pragma mark - MapView delegate

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleRenderer.strokeColor = [UIColor blueColor];
    circleRenderer.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:255.0/255.0 alpha:.1];
    circleRenderer.lineWidth = 1;
    return circleRenderer;
}

#pragma mark - Button action

-(IBAction)watchButtonDidTouchUpInside:(id)sender{
    self.almostThereView.text = @"watching!";
    self.almostThereView.accessibilityValue = self.almostThereView.text;
    self.almostThereView.alpha = 0.1;
    self.watchButton.enabled = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userEnteredRegion:) name:USER_ENTERED_REGION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLeftRegion:) name:USER_LEFT_REGION object:nil];

	CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:500 identifier:@"universityRegion"];
	
    [self.locationManager startRegionMonitoring:region];
}

@end
