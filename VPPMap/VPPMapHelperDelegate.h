//
//  VPPMapHelperDelegate.h
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


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/** This protocol defines a set of optional methods that you can use to receive
 mapHelper update messages. */


@protocol VPPMapHelperDelegate <MKMapViewDelegate>

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
