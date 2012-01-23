//
//  VPPMapHelperDelegate.h
//  VPPLibraries
//
//  Created by Víctor on 20/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/** This protocol defines a set of optional methods that you can use to receive
 mapHelper update messages. */


@protocol VPPMapHelperDelegate

@optional

/** ---
 @name Requiring annotation details
 */

/** Tells the delegate the user has pressed the annotation callout's
 disclosure button.
 */
- (void) open:(id<MKAnnotation>)annotation;

/** 
 Tells the delegate the user has just dropped an annotation. In this method's 
 implementation the delegate can modify all the annotation's properties.
 
 The delegate must return YES if the annotation's callout should be opened. 
 Otherwise return NO. */
- (BOOL) annotationDroppedByUserShouldOpen:(id<MKAnnotation>)annotation;

@end
