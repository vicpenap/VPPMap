//
//  VPPMapClusterView.m
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

//this view is based on https://github.com/RVLVR/REVClusterMap

#import "VPPMapClusterView.h"
#import "VPPMapCluster.h"
#import <QuartzCore/QuartzCore.h>

@implementation VPPMapClusterView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self addSubview:_label];
        if ([annotation isKindOfClass:[VPPMapCluster class]]) {
            self.title = [NSString stringWithFormat:@"%d",[[(VPPMapCluster*)annotation annotations] count]];
        }
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor grayColor];
        _label.font = [UIFont boldSystemFontOfSize:11]; 
        _label.textAlignment = UITextAlignmentCenter;
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(0,-1);
        _label.layer.cornerRadius = 10;
        _label.layer.borderWidth = 2;
        _label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
    return self;
}

- (void) dealloc {
    if (_label != nil) {
        [_label release];
    }
}

- (void) setTitle:(NSString *)title {
    _label.text = title;
}

- (NSString *) title {
    return _label.text;
}

@end
