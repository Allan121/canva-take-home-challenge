//
//  TileView.h
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The type of a tile, which represents the desired size and shape.
 **/
typedef enum {
    ImageTileTypeDefault,
    ImageTileTypeSmallSquare,
    ImageTileTypeLargeSquare
} ImageTileType;

/**
 * A view used to display mosaic tile images
 **/
@interface TileView : UIView

/**
 * Default init method.
 *
 * @param frame The desired frame for the view.
 * @param baseImage The image that will be used to determine an average colour, and eventually fetch the corresponding tile.
 * @return the TileView instance
 */
- (instancetype)initWithFrame:(CGRect)frame baseImage:(UIImage *)baseImage;

/**
 * Loads the display image, or tile for the TileView given a representative color
 *
 * @param color The color used to fetch the corresponding tile.
 */
- (void)loadDisplayImageWithRepresentativeColour:(UIColor *)color;

@end
