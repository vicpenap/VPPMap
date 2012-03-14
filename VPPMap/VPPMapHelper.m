//
//  VPPMapHelper.m
//  VPPLibraries
//
//  Created by Víctor on 20/10/11.

// 	Copyright (c) 2012 Víctor Pena Placer (@vicpenap)
// 	http://www.victorpena.es/
// 	
// 	
// 	Permission is hereby granted, free of charge, to any person obtaining a copy 
// 	of this software and associated documentation files (the "Software"), to deal
// 	in the Software without restriction, including without limitation the rights 
// 	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// 	copies of the Software, and to permit persons to whom the Software is furnished
// 	to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in
// 	all copies or substantial portions of the Software.
// 	
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
// 	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "VPPMapHelper.h"
#import "VPPMapCustomAnnotation.h"
#import "VPPMapCluster.h"
#import "VPPMapClusterHelper.h"
#import "VPPMapClusterView.h"

#define kVPPMapHelperOpenAnnotationDelay 0.65

#define kVPPMapHelperOnePinLongitudeDelta 0.003f
#define kVPPMapHelperOnePinLatitudeDelta 0.0006f

#define kPressDuration 0.5 // in seconds


@implementation VPPMapHelper
@synthesize mapView;
@synthesize delegate;
@synthesize centersOnUserLocation;
@synthesize showsDisclosureButton;
@synthesize pinAnnotationColor;
@synthesize mapRegionSpan;
@synthesize userCanDropPin;
@synthesize allowMultipleUserPins;
@synthesize pinDroppedByUserClass;
@synthesize shouldClusterPins;
@synthesize distanceBetweenPins;



#pragma mark -
#pragma mark Lifecycle

+ (VPPMapHelper*) VPPMapHelperForMapView:(MKMapView*)mapView 
                      pinAnnotationColor:(MKPinAnnotationColor)annotationColor 
                   centersOnUserLocation:(BOOL)centersOnUserLocation 
                   showsDisclosureButton:(BOOL)showsDisclosureButton 
                                delegate:(id<VPPMapHelperDelegate>)delegate {
	
	// sets up the map
	VPPMapHelper *mh = [[VPPMapHelper alloc] init];
	mh->_userPins = [[NSMutableArray alloc] init];
	// we don't want user's location
	mh.centersOnUserLocation = centersOnUserLocation;
	// we want the disclosure button
	mh.showsDisclosureButton = showsDisclosureButton;
	// green pins
	mh.pinAnnotationColor = annotationColor;
	// mapView referenced
	mh->mapView = [mapView retain];
	// VPPMapHelperDelegate
	mh.delegate = delegate;
	// MKMapViewDelegate
	mapView.delegate = [mh retain];
    mh->_unfilteredPins = [[NSMutableArray alloc] init];
    mh->_currentZoom = -1;
    mh->userCanDropPin = NO;
	
	// adds longpress gesture recognizer
	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
										  initWithTarget:mh action:@selector(handleLongPress:)];
	lpgr.minimumPressDuration = kPressDuration;
	[mh.mapView addGestureRecognizer:lpgr];
	[lpgr release];
	
    // listens to userLocation's changes
    [mh.mapView.userLocation addObserver:mh
                              forKeyPath:@"location"  
                                 options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
                                 context:NULL];
	
	return [mh autorelease];
}



- (void)dealloc {
    if (_userPins != nil) {
        [_userPins release];
    }
    if (mapView != nil) {
        [mapView release];
        mapView = nil;
    }
	self.delegate = nil;
    if (_unfilteredPins != nil) {
        [_unfilteredPins release];
    }
	
	[super dealloc];
}


#pragma mark - Help stuff

- (float) distanceBetweenPins {
    if (distanceBetweenPins == 0) {
        return kVPPMapHelperDistanceBetweenPoints;
    }
    else {
        return distanceBetweenPins;
    }
}

- (CGFloat)annotationPadding {
    return 10.0f;
}

- (CGFloat)calloutHeight {
    return 40.0f;
}

// handling long press

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan
		|| self.userCanDropPin == NO) {
        return;
	}
	
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
	[self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
	
	if (!self.allowMultipleUserPins) {
		for (id<MKAnnotation> ann in _userPins) {
			[self.mapView removeAnnotation:ann];
		}
	}
	
	id<MKAnnotation> pinDroppedByUser = [[self.pinDroppedByUserClass alloc] init];
    pinDroppedByUser.coordinate = touchMapCoordinate;
	
	BOOL open = [self.delegate annotationDroppedByUserShouldOpen:pinDroppedByUser];
	
	[self.mapView addAnnotation:pinDroppedByUser];
	
	if (open) {
		[self performSelector:@selector(openAnnotation:) withObject:pinDroppedByUser afterDelay:kVPPMapHelperOpenAnnotationDelay];
	}
	[_userPins addObject:pinDroppedByUser];
	[pinDroppedByUser release];
}


// annotation disclosured
-(void)open:(id)sender {
	// gets the only (that's why objectAtIndex:0) annotation selected
	id<MKAnnotation> ann = [self.mapView.selectedAnnotations objectAtIndex:0];
	
	[self.delegate open:ann];
}



-(void)openAnnotation:(id<MKAnnotation>)annotation {
	[self.mapView selectAnnotation:annotation animated:YES];
}

- (UIImage*) resizeImageForAnnotation:(UIImage*)image {
    return image;
    //    UIImage *annImage = [image copy];
    //    
    //    CGRect resizeRect;
    //    
    //    resizeRect.size = annImage.size;
    //    CGSize maxSize = CGRectInset(self.mapView.bounds,
    //                                 [self annotationPadding],
    //                                 [self annotationPadding]).size;
    //    maxSize.height -= [self calloutHeight];
    //    if (resizeRect.size.width > maxSize.width)
    //        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    //    if (resizeRect.size.height > maxSize.height)
    //        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    //    
    //    resizeRect.origin = (CGPoint){0.0f, 0.0f};
    //    UIGraphicsBeginImageContext(resizeRect.size);
    //    [annImage drawInRect:resizeRect];
    //    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    
    //    return resizedImage;
}

- (MKAnnotationView*) buildAnnotationViewWithAnnotation:(id<VPPMapCustomAnnotation>)annotation 
                                        reuseIdentifier:(NSString*)identifier 
                                             forMapView:(MKMapView*)theMapView {
    
    MKAnnotationView *customImageView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                      reuseIdentifier:identifier] autorelease];
    
    
    customImageView.image = [self resizeImageForAnnotation:annotation.image];
    customImageView.opaque = NO;
    [customImageView setCanShowCallout:YES];
    
    if (self.showsDisclosureButton) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(open:)
              forControlEvents:UIControlEventTouchUpInside];
        customImageView.rightCalloutAccessoryView = rightButton; 
    }
    
    return customImageView;
}

- (BOOL) annotationShowsDisclosureButton:(id<MKAnnotation>)annotation {
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(showsDisclosureButton)]) {
        id<VPPMapCustomAnnotation>cust = (id<VPPMapCustomAnnotation>)annotation;
        return cust.showsDisclosureButton;
    }
    
    return self.showsDisclosureButton;
}

- (MKAnnotationView*) buildPinAnnotationViewWithAnnotation:(id<MKAnnotation>)annotation 
                                           reuseIdentifier:(NSString*)identifier 
                                                forMapView:(MKMapView*)theMapView {
    
    MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                          reuseIdentifier:identifier] autorelease];
    
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]) {
        [customPinView setPinColor:[(id<VPPMapCustomAnnotation>)annotation pinAnnotationColor]];
    }
    else {
        [customPinView setPinColor:self.pinAnnotationColor];			
    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]
        && [(id<VPPMapCustomAnnotation>)annotation opensWhenShown]) {
        [self performSelector:@selector(openAnnotation:) withObject:annotation afterDelay:kVPPMapHelperOpenAnnotationDelay];
    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(canShowCallout)]) {
        
        id<VPPMapCustomAnnotation> cust = (id<VPPMapCustomAnnotation>)annotation;
        customPinView.canShowCallout = cust.canShowCallout;
    }
    else {
        customPinView.canShowCallout = YES;
    } 
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(animatesDrop)]) {
        id<VPPMapCustomAnnotation>cust = (id<VPPMapCustomAnnotation>)annotation;
        customPinView.animatesDrop = cust.animatesDrop;      
    }
    else if (!self.shouldClusterPins) {
        [customPinView setAnimatesDrop:YES];
    }
    
    if ([self annotationShowsDisclosureButton:annotation]) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(open:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton; 
    }
    
    return customPinView;
}



#pragma mark -
#pragma mark MKMapViewDelegate

// configures the pin for an annotation
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	//	NSLog(@"This is called");
    
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		// NSLog(@"ITs user location class");
		return nil;
	}
    
    if ([annotation isKindOfClass:[VPPMapCluster class]]) {
        VPPMapClusterView *clusterView = (VPPMapClusterView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if (!clusterView) {
            clusterView = [[[VPPMapClusterView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];            
        }
        
        clusterView.title = [NSString stringWithFormat:@"%d",[[(VPPMapCluster*)annotation annotations] count]];
        clusterView.canShowCallout = NO;
        
        return clusterView;
    }
    
    
	
    // annotation must have an image instead of pin icon
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [annotation respondsToSelector:@selector(image)]
        && ((id<VPPMapCustomAnnotation>)annotation).image != nil) {
        static NSString *imageLocationAnnotationIdentifier = @"ImageMapAnnotationIdentifier"; 
        MKPinAnnotationView *imagePinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:imageLocationAnnotationIdentifier];
        
        if (!imagePinView) {
            return [self buildAnnotationViewWithAnnotation:(id<VPPMapCustomAnnotation>)annotation
                                           reuseIdentifier:imageLocationAnnotationIdentifier 
                                                forMapView:theMapView];
        }
        else {
            imagePinView.image = [self resizeImageForAnnotation:((id<VPPMapCustomAnnotation>)annotation).image];
            imagePinView.annotation = annotation;
        }
        return imagePinView;
    }
    
    
    // annotation doesn't have custom image
	static NSString *locationAnnotationIdentifier = @"MapAnnotationIdentifier"; 
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:locationAnnotationIdentifier];
	
	if (!pinView) {
		return [self buildPinAnnotationViewWithAnnotation:annotation 
                                          reuseIdentifier:locationAnnotationIdentifier
                                               forMapView:theMapView];
	} 
	
	else {
		if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]) {
			[pinView setPinColor:[(id<VPPMapCustomAnnotation>)annotation pinAnnotationColor]];
		}
		else {
			[pinView setPinColor:self.pinAnnotationColor];			
		}
		pinView.annotation = annotation;
	}
	
	
	if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]
		&& [(id<VPPMapCustomAnnotation>)annotation opensWhenShown]) {
		[self performSelector:@selector(openAnnotation:) withObject:annotation afterDelay:kVPPMapHelperOpenAnnotationDelay];
	}
	
	return pinView;
}

- (MKCoordinateRegion) regionAccordingToAnnotations:(NSArray*)annotations {
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    CLLocationCoordinate2D currentCoordinate;
    
    float minLatitude = -9999;
    float minLongitude = -9999;
    float maxLatitude = 9999;
    float maxLongitude = 9999;
    for (id<MKAnnotation> ann in annotations) {
        if ([ann isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        currentCoordinate = ann.coordinate;
        if (minLatitude == -9999 || minLongitude == -9999) {
            minLatitude = currentCoordinate.latitude;
            minLongitude = currentCoordinate.longitude;	
        }
        if (maxLatitude == 9999 || maxLongitude == 9999) {
            maxLatitude = currentCoordinate.latitude;
            maxLongitude = currentCoordinate.longitude;				
        }
        
        if (currentCoordinate.latitude < minLatitude) {
            minLatitude = currentCoordinate.latitude;
        }
        if (currentCoordinate.longitude < minLongitude) {
            minLongitude = currentCoordinate.longitude;
        }
        if (currentCoordinate.latitude > maxLatitude) {
            maxLatitude = currentCoordinate.latitude;
        }
        if (currentCoordinate.longitude > maxLongitude) {
            maxLongitude = currentCoordinate.longitude;
        }
    }		
    
    CLLocation *min = [[CLLocation alloc] initWithLatitude:minLatitude longitude:minLongitude];
    CLLocation *max = [[CLLocation alloc] initWithLatitude:maxLatitude longitude:maxLongitude];
    CLLocationDistance dist = [max distanceFromLocation:min];
    [max release];
    [min release];
    
    region.center.latitude = (minLatitude + maxLatitude) / 2.0;
    region.center.longitude = (minLongitude	+ maxLongitude) / 2.0;
    region.span.latitudeDelta = dist / 111319.5; // magic number !! :)
    // explanation here: http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
    region.span.longitudeDelta = 0.0;
    
    return region;
    
}

#pragma mark - Centering map stuff

- (void)observeValueForKeyPath:(NSString *)keyPath  
                      ofObject:(id)object  
                        change:(NSDictionary *)change  
                       context:(void *)context {  
    
    if (self.centersOnUserLocation) {  
        [self centerMap];
    }
}

- (void) centerOnCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };

    region.center = coordinate;
    
    if (self.mapRegionSpan.latitudeDelta != 0.0 && self.mapRegionSpan.longitudeDelta != 0.0) {
        region.span = self.mapRegionSpan;
    }
    else {
        region.span.longitudeDelta = kVPPMapHelperLongitudeDelta;
        region.span.latitudeDelta = kVPPMapHelperLatitudeDelta;		
    }
    
    [self.mapView setRegion:region animated:YES];	
}

- (void) centerMap {
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	CLLocationCoordinate2D currentCoordinate;
	
	if (self.centersOnUserLocation) {
		CLLocation *userLocation = self.mapView.userLocation.location;

		[self centerOnCoordinate:userLocation.coordinate];
		return;
	}
	
	else if ([self.mapView.annotations count] > 1) {	
		region = [self regionAccordingToAnnotations:self.mapView.annotations];
    }
	
	else if ([self.mapView.annotations count] == 1) {
		currentCoordinate = [[self.mapView.annotations objectAtIndex:0] coordinate];
		
        region.center = currentCoordinate;
		
		region.span.longitudeDelta = kVPPMapHelperOnePinLongitudeDelta;
		region.span.latitudeDelta = kVPPMapHelperOnePinLatitudeDelta;		
	}
	
	else {
		return;
	}
	
	
	[self.mapView setRegion:region animated:YES];	
}


#pragma mark - Clustering stuff
- (void) mapView:(MKMapView *)mmapView didAddAnnotationViews:(NSArray *)views {
    if (_pinsToRemove != nil) {
        [mmapView removeAnnotations:_pinsToRemove];
        [_pinsToRemove release];
        _pinsToRemove = nil;
    }
}

- (BOOL) mapViewDidZoom:(MKMapView*)mmapView  {
    if (_currentZoom == mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height) {
        return NO;
    }
    
    _currentZoom = mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height;
    return YES;
}

- (void) mapView:(MKMapView *)mmapView regionDidChangeAnimated:(BOOL)animated {
    if (self.shouldClusterPins && [_unfilteredPins count] != 0 && [self mapViewDidZoom:mmapView]) {
        VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView];
        [mh clustersForAnnotations:_unfilteredPins distance:self.distanceBetweenPins completion:^(NSArray *data) {
            if (_pinsToRemove != nil) {
                [_pinsToRemove release];
            }
            _pinsToRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
            [_pinsToRemove removeObjectsInArray:data];
            [self.mapView addAnnotations:data];
        }];
        [mh release];
    }
}

#pragma mark - Managing annotations
// sets all annotations and initializes map.

- (void)setMapAnnotations:(NSArray*)mapAnnotations {
	// removes all previous annotations
	NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
	[self.mapView removeAnnotations:annotations];
	
	[self addMapAnnotations:mapAnnotations];
	
    if (self.shouldClusterPins) {
        [_unfilteredPins removeAllObjects];
        [self.mapView setRegion:[self regionAccordingToAnnotations:mapAnnotations] animated:YES];	
    }
    else {
        [self centerMap];
    }
}


// adds more annotations 
- (void)addMapAnnotations:(NSArray*)mapAnnotations {
    if (self.shouldClusterPins) {
        VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView];
        [mh clustersForAnnotations:mapAnnotations distance:self.distanceBetweenPins completion:^(NSArray *data) {
            [_unfilteredPins addObjectsFromArray:mapAnnotations];            
            [self.mapView addAnnotations:data];
        }];
        [mh release];
    }
    
    else {
        [self.mapView addAnnotations:mapAnnotations];
    }
}


@end
