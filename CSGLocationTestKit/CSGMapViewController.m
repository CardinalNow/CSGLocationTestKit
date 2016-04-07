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
    
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    CLLocationCoordinate2D centeringCoord = self.locationManager.currentLocation.coordinate;
    self.mapView.region = MKCoordinateRegionMake(centeringCoord, span);
	
	self.coordinate = CLLocationCoordinate2DMake(40.819204, -96.698171);
	
	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	[annotation setCoordinate:self.coordinate];
	[annotation setTitle:@"Central Point of Region Monitoring"]; //You can set the subtitle too
	[self.mapView addAnnotation:annotation];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_ENTERED_REGION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:USER_LEFT_REGION object:nil];

}

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
