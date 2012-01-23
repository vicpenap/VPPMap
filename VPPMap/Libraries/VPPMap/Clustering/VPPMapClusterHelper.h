//
//  VPPMapClusterHelper.h
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VPPMapClusterHelper : NSObject

@property (nonatomic, retain) MKMapView *mapView;

- (VPPMapClusterHelper *) initWithMapView:(MKMapView*)mapView;

- (void) clustersForAnnotations:(NSArray*)annotations distance:(float)distance completion:(void (^)(NSArray *data))block;

    
@end
