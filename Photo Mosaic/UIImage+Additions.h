//
//  UIImage+Additions.h
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Adds additional functionality for UIImage including resizing, cropping, and calculating an average colour
 */
@interface UIImage (Additions)

/**
 * Class method that resizes a given image.
 *
 * @param image The image to be resized.
 * @param newSize The desired size for the image.
 * @return The newly resized image.
 */
+ (UIImage *)resizedImageForBaseImage:(UIImage *)image size:(CGSize)newSize;

/**
 * Class method that crops a given image.
 *
 * @param image The image to be cropped.
 * @param croppingRect The rect to be used for the image cropping.
 * @return The cropped image.
 */
+ (UIImage *)croppedImageForBaseImage:(UIImage *)image croppingRect:(CGRect)croppingRect;

/**
 * Calculates the representative or average colour for the image.
 */
- (UIColor *)averageColor;

@end
