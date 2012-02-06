//
//  VPPMapClusterView.m
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.

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
