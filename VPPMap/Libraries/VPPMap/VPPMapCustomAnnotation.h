//
//  VPPMapCustomAnnotation.h
//  VPPLibraries
//
//  Created by Víctor on 31/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/** This protocol can be used to customize an annotation.
 
 VPPMapHelper will detect if a MKAnnotation conforms to VPPMapCustomAnnotation
 protocol, and in that case would read its customization. */
 

@protocol VPPMapCustomAnnotation <MKAnnotation>

/** ---
 @name Required properties
 */

@required
/** Specifies the annotation's color. */
@property (nonatomic, assign) MKPinAnnotationColor pinAnnotationColor;
/** Indicates whether the annotation's callout should be opened when the 
 annotation is dropped or not. */
@property (nonatomic, assign) BOOL opensWhenShown;

@optional
/** If set, the annotation will show this image rather than the usual pin. */
@property (nonatomic, retain) UIImage *image;
/** If set to YES, the annotation will be placed on the map with an animation. 
 Otherwise the annotation will "magically" appear on the map.
 
 There will never be an animation if the annotation has an image set, no mather
 the value of this property.
 */
@property (nonatomic, assign) BOOL animatesDrop;
/** If set to YES, the annotation will not be included in any cluster. */
@property (nonatomic, assign) BOOL avoidsClusters;
/** If set to YES, the annotation will show a callout when pressed. */
@property (nonatomic, assign) BOOL canShowCallout;
/** If set to YES, the annotation will show a disclosure button in its callout. */
@property (nonatomic, assign) BOOL showsDisclosureButton;

@end
