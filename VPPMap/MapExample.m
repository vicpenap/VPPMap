//
//  VPPMapExample.m
//  VPPLibraries
//
//  Created by Víctor on 26/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//

#import "MapExample.h"
#import "VPPMapHelper.h"
#import "MapAnnotationExample.h"

@implementation MapExample
@synthesize mapView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(float)RandomFloatStart:(float)a end:(float)b {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

- (void) tonsOfPins {
    srand((unsigned)time(0));
    
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 100; i++) {
        
        MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
        place.coordinate = CLLocationCoordinate2DMake([self RandomFloatStart:41.0 end:44.0],[self RandomFloatStart:-9.0 end:-5.0]);
        [place setTitle:[NSString stringWithFormat:@"Place %d title",i]];
        [tempPlaces addObject:place];
        [place release];
        
    }
    
    _mh.shouldClusterPins = YES;
    [_mh setMapAnnotations:tempPlaces];
    [tempPlaces release];    
}

- (void) toggleCenterOnMe {
    _mh.centersOnUserLocation = !_mh.centersOnUserLocation;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// gets some points
	NSMutableArray * arr = [NSMutableArray array];
	MapAnnotationExample *ann = [[MapAnnotationExample alloc] init];
	ann.coordinate = CLLocationCoordinate2DMake(43.3758888244629,-8.39844131469727);
	ann.title = @"Campo de Marte";
	ann.pinAnnotationColor = MKPinAnnotationColorPurple;
	ann.opensWhenShown = YES;
	[arr addObject:ann];
	[ann release];
	ann = [[MapAnnotationExample alloc] init];
	ann.coordinate = CLLocationCoordinate2DMake(43.3576393127441,-8.4019660949707);
	ann.title = @"Tabacos";
    ann.image = [UIImage imageNamed:@"bikePin"];
	[arr addObject:ann];
	[ann release];
	ann = [[MapAnnotationExample alloc] init];
	ann.coordinate = CLLocationCoordinate2DMake(43.3529319763184,-8.4093017578125);
	ann.title = @"Estación de Tren";
	[arr addObject:ann];
	[ann release];
	
	// sets up the map
	_mh = [[VPPMapHelper VPPMapHelperForMapView:self.mapView 
                             pinAnnotationColor:MKPinAnnotationColorGreen 
                          centersOnUserLocation:NO
                          showsDisclosureButton:YES 
                                       delegate:self] retain];
    self.mapView.showsUserLocation = YES;
	_mh.userCanDropPin = YES;
	_mh.allowMultipleUserPins = YES;
	_mh.pinDroppedByUserClass = [MapAnnotationExample class];
	[_mh setMapAnnotations:arr];
	
	[_mh release];
    
    
    [arr removeAllObjects];
    arr = [NSMutableArray array];
    [arr addObject:[[[UIBarButtonItem alloc] initWithTitle:@"Tons of pins" style:UIBarButtonItemStyleBordered target:self action:@selector(tonsOfPins)] autorelease]];
    [arr addObject:[[[UIBarButtonItem alloc] initWithTitle:@"Toggle Center on me" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleCenterOnMe)] autorelease]];    
    self.navigationItem.rightBarButtonItems = arr;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    if (_mh != Nil) {
        [_mh release];
    }
    [super dealloc];
}


#pragma mark -
#pragma mark VPPMapHelperDelegate

- (void) open:(id<MKAnnotation>)annotation {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Annotation pressed" message:[NSString stringWithFormat:@"It says: %@",annotation.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

- (BOOL) annotationDroppedByUserShouldOpen:(id<MKAnnotation>)annotation {
	MapAnnotationExample *ann = (MapAnnotationExample*)annotation;
	
	ann.title = @"Hi there!";
	ann.pinAnnotationColor = MKPinAnnotationColorGreen;
	
	return YES;
}

@end
