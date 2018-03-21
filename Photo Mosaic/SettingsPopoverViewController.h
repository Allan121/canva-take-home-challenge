//
//  SettingsPopoverViewController.h
//  PhotoMosaic
//
//  Created by Allan Poole on 31/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"

@class SettingsPopoverViewController;

/**
 *  Protocol for the `SettingsPopoverViewController`
 **/
@protocol SettingsPopoverViewControllerDelegate <NSObject>

/**
 * Delegate method to return the selected tile type.
 *
 * @param settingsPopoverViewcontroller The instance of `SettingsPopoverViewController`.
 * @param tileType The tile type selected.
 */
- (void)settingsPopoverViewController:(SettingsPopoverViewController *)settingsPopoverViewcontroller tileTypeSelected:(ImageTileType)tileType;

/**
 * Delegate method to return whether or not to show the original image 
 * in the background.
 *
 * @param settingsPopoverViewcontroller The instance of `SettingsPopoverViewController`.
 * @param showOriginalImage bool representing whether or not to display the original image
 */
- (void)settingsPopoverViewController:(SettingsPopoverViewController *)settingsPopoverViewcontroller showOriginalImageValueChanged:(BOOL)showOriginalImage;

@end

/**
 *  Popover viewcontroller used to display tile type settings
 **/
@interface SettingsPopoverViewController : UIViewController

/**
 *  `SettingsPopoverViewControllerDelegate` instance
 **/
@property (nonatomic, weak) id<SettingsPopoverViewControllerDelegate> delegate;

@end
