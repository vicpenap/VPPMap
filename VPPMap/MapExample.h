//
//  MapExample.h
//  VPPLibraries
//
//  Created by Víctor on 26/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VPPMapHelperDelegate.h"
#import "VPPMapHelper.h"

@interface MapExample : UIViewController <VPPMapHelperDelegate> {
@private
    VPPMapHelper *_mh;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
