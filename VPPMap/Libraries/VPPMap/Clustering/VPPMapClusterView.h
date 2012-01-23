//
//  VPPMapClusterView.h
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VPPMapClusterView : MKAnnotationView {
@private
    UILabel *_label;
}

@property (nonatomic, retain) NSString *title;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;


@end
