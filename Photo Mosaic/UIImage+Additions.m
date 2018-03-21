//
//  UIImage+Additions.m
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)resizedImageForBaseImage:(UIImage *)image size:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)croppedImageForBaseImage:(UIImage *)image croppingRect:(CGRect)croppingRect {
    
    if (image.scale > 1.f) {
        
        croppingRect = CGRectMake(croppingRect.origin.x * image.scale,
                          croppingRect.origin.y * image.scale,
                          croppingRect.size.width * image.scale,
                          croppingRect.size.height * image.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, croppingRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return croppedImage;
}

- (UIColor *)averageColor {
    
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                     green:data[1] / 255.0f
                                      blue:data[0] / 255.0f
                                     alpha:1];
    
    UIGraphicsEndImageContext();
    
    return color;
}
@end
