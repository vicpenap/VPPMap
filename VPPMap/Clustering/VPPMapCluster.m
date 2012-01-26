//
//  VPPMapCluster.m
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import "VPPMapCluster.h"

#define kAnnotationsNumber @"%d annotations"

@implementation VPPMapCluster
@synthesize pinAnnotationColor;
@synthesize opensWhenShown;
@synthesize annotations;

- (VPPMapCluster *) init {
    if (self = [super init]) {
        self.annotations = [NSMutableArray array];
    }
    
    return self;
}

- (void) dealloc {
    self.annotations = nil;
    
    [super dealloc];
}

- (NSString *) title {
    return [NSString stringWithFormat:kAnnotationsNumber,[self.annotations count]];
}

- (CLLocationCoordinate2D) coordinate {
    float lat = 0;
    float lon = 0;
    
    for (id<MKAnnotation> ann in self.annotations) {
        lat += ann.coordinate.latitude;
        lon += ann.coordinate.longitude;
    }
    
    return CLLocationCoordinate2DMake(lat/[self.annotations count], lon/[self.annotations count]);
}


@end
