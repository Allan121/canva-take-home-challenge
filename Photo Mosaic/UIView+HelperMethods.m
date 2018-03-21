//
//  UIView+HelperMethods.m
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "UIView+HelperMethods.h"

@implementation UIView (HelperMethods)

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

@end
