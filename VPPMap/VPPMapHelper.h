//
//  VPPMapHelper.h
//  VPPLibraries
//
//  Created by Víctor on 20/10/11.
//  Copyright 2011 Víctor Pena Placer. All rights reserved.
//


/** 
 This library simplifies the creation and management of a MKMapView. Features:
 
 - Automatic annotations management with their views and callouts. 
 - Map region centering based on the current visible annotations. 
 - Automatic annotation clustering.
 - Easy management of pins dropped by user.
 
 Using VPPMapCustomAnnotation protocol (instead of MKAnnotation protocol)
 would allow a higher annotation customization, although this is optional.
 
 @warning **Important** This library depends on MapKit framework and
 CoreLocation framework.
 */




#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "VPPMapHelperDelegate.h"

// specifies initial zoom, used when no mapRegionSpan property is defined
#define kVPPMapHelperLongitudeDelta 0.08f
#define kVPPMapHelperLatitudeDelta 0.0020f
#define kVPPMapHelperDistanceBetweenPoints 40

@interface VPPMapHelper : NSObject <MKMapViewDelegate> {
@private
	NSMutableArray *_userPins;
    
    NSMutableArray *_unfilteredPins;
    NSMutableArray *_pinsToRemove;
    
    float _currentZoom;
}




/** ---
 @name Initializating a Map Helper 
 */

/** Creates and returns a new autoreleased instance with the specified configuration. */
+ (VPPMapHelper*) VPPMapHelperForMapView:(MKMapView*)mapView 
                      pinAnnotationColor:(MKPinAnnotationColor)annotationColor 
                   centersOnUserLocation:(BOOL)centersOnUserLocation 
                   showsDisclosureButton:(BOOL)showsDisclosureButton 
                                delegate:(id<VPPMapHelperDelegate>)delegate;





/** ---
 @name Accesing the map view
 */
/// Holds reference to the managed map view
@property (nonatomic, readonly) MKMapView *mapView;

/** ---
 @name Accesing the delegate 
*/

/// Holds reference to VPPMapHelperDelegate
@property (nonatomic, retain) id<VPPMapHelperDelegate> delegate;



/** ---
 @name Map helper properties
 */

/** Sets if user can drop a pin by longpressing the map in any point.
 */
@property (nonatomic, assign) BOOL userCanDropPin;

/** Sets if user can drop more than one pin by longpressing on the map.
 needs userCanDropPin to be set to YES. */
@property (nonatomic, assign) BOOL allowMultipleUserPins;

/** Holds reference to the pin's class that will be used when user longpresses. 
 It must implement MKAnnotation protocol */
@property (nonatomic, assign) Class pinDroppedByUserClass;

/** Indicates if pins should be grouped in clusters. 
 
 This only applies to those pins added **after** this property has been set to YES
 using the methods addMapAnnotations: or setMapAnnotations: */
@property (nonatomic, assign) BOOL shouldClusterPins;

/** Indicates distance between pins to cluster them. */
@property (nonatomic, assign) float distanceBetweenPins;




/** ---
 @name Default annotation properties
 */

/** Indicates if the annotations' view should show a disclosure button.
 This property can be overriden for each annotation by VPPCustomAnnotation. */
@property (nonatomic, assign) BOOL showsDisclosureButton;


/** Indicates pins color. Red if none is assigned.
 This property can be overriden for each annotation by VPPCustomAnnotation. */
@property (nonatomic, assign) MKPinAnnotationColor pinAnnotationColor;




/** ---
 @name Managing annotations
 */

/** Removes all previous annotations and sets the given ones.
 They must conform to MKAnnotation protocol, or optionally to
 VPPMapCustomAnnotation. 
 
 Invoking this method will center the map automatically. If you want to
 avoid that feature, remove by hand all the existing annotations and use
 addMapAnnotations: instead.
 
 If shouldClusterPins is set to YES, given annotations will be automatically 
 clustered.
 */
- (void)setMapAnnotations:(NSArray*)mapAnnotations;

/** Adds more map annotations to the already existing ones. They must
 conform to MKAnnotation protocol, or optionally to VPPMapCustomAnnotation. 
 
 If shouldClusterPins is set to YES, given annotations will be automatically 
 clustered.
 */
- (void)addMapAnnotations:(NSArray*)mapAnnotations;


/** ---
 @name Centering the map 
 */


/** Indicates whether the map view should be centered on user location or not.
 
 
mapView.showsUserLocation property is independent of this one.
 */
@property (nonatomic, assign) BOOL centersOnUserLocation;


/** Indicates the amount of zoom used when centering the map.
 */
@property (nonatomic, assign) MKCoordinateSpan mapRegionSpan;

/** Calcultates the best map's region to be shown and centers the map view to
 fit that region.
 
 If centersOnUserLocation is set to YES, mapView will be centered on it
 with the mapRegionSpan indicated.
 
 If centersOnUserLocation is set to NO, mapView will be centered around the 
 current annotations, with the needed span to let all annotations to be shown.
 */
- (void) centerMap;

@end
