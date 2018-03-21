//
//  UIView+HelperMethods.h
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Adds additional functionality to UIView to assist with frame modification
 **/
@interface UIView (HelperMethods)

- (CGFloat)height;
- (CGFloat)width;

- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;

@end
