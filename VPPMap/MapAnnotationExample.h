//
//  MapAnnotation.h
//  VPPLibraries
//
//  Created by Víctor on 20/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "VPPMapCustomAnnotation.h"

@interface MapAnnotationExample : NSObject <VPPMapCustomAnnotation> {

}

// if you implement VPPMapCustomAnnotation you can customize the annotation
// as much as you want.

// pin's coordinates (only required property)
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// pin's title
@property (nonatomic, copy) NSString *title;
// pin's subtitle
@property (nonatomic, copy) NSString *subtitle;


@end
