//
//  VPPMapCustomAnnotation.h
//  VPPLibraries
//
//  Created by Víctor on 31/10/11.

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
