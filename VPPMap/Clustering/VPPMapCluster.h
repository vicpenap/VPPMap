//
//  VPPMapCluster.h
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPPMapCustomAnnotation.h"

@interface VPPMapCluster : NSObject <VPPMapCustomAnnotation>

@property (nonatomic, retain) NSMutableArray *annotations;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
