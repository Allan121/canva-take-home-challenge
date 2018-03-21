//
//  ServicesAPI.h
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * An interface between the client and the mosaic tile server. Creates and manages an operation queue for incoming requests
 **/
@interface ServicesAPI : NSObject

/**
 * The singleton for the services API.
 **/
+ (instancetype)sharedInstance;

/**
 * API for fetching a tile based on supplied colour and size.
 *
 * @param color The color that the returned tile represents.
 * @param size The size of the tile being requested.
 * @param completion The completion blocked called once the tile request has completed
 */
- (void)fetchTileForColor:(UIColor *)color size:(CGSize)size completion:(void(^)(UIImage *image, NSError *error))completion;

/**
 * Cancels all currently executing tile operations
 */
- (void)cancellAllTileOperations;

@end
