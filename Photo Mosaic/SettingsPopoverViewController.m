//
//  SettingsPopoverViewController.m
//  PhotoMosaic
//
//  Created by Allan Poole on 31/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "SettingsPopoverViewController.h"

typedef enum {
    SettingsButtonTypeSmall = 1,
    SettingsButtonTypeMedium = 2,
    SettingsButtonTypeLarge = 3
    
} SettingsButtonType;

@interface SettingsPopoverViewController ()
- (IBAction)tileSizeButtonTapped:(id)sender;
- (IBAction)showOriginalImageSwitchValueChanged:(id)sender;

@end

@implementation SettingsPopoverViewController

- (IBAction)tileSizeButtonTapped:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(settingsPopoverViewController:tileTypeSelected:)]) {
        
        UIButton *button = sender;
        
        ImageTileType tileType;
        
        switch (button.tag) {
                
            case SettingsButtonTypeSmall:
                tileType = ImageTileTypeSmallSquare;
                break;
                
            case SettingsButtonTypeMedium:
                tileType = ImageTileTypeDefault;
                break;
                
            case SettingsButtonTypeLarge:
                tileType = ImageTileTypeLargeSquare;
                break;
                
            default:
                break;
        }
        
        [self.delegate settingsPopoverViewController:self tileTypeSelected:tileType];
    }
}

- (IBAction)showOriginalImageSwitchValueChanged:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(settingsPopoverViewController:showOriginalImageValueChanged:)]) {
        
        UISwitch *imageSwitch = sender;
        
        [self.delegate settingsPopoverViewController:self showOriginalImageValueChanged:imageSwitch.on];
    }
    
}
@end
