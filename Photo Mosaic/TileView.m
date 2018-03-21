//
//  TileView.m
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "TileView.h"
#import "UIImage+Additions.h"
#import "ServicesAPI.h"

@interface TileView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TileView

- (instancetype)initWithFrame:(CGRect)frame baseImage:(UIImage *)baseImage {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];

        [self loadDisplayImageWithRepresentativeColour:[baseImage averageColor]];
    }
    
    return self;
}

- (void)loadDisplayImageWithRepresentativeColour:(UIColor *)color {
    
    if (color) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [[ServicesAPI sharedInstance] fetchTileForColor:color size:self.frame.size completion:^(UIImage *image, NSError *error) {
                
                if (image) {
                    
                    self.imageView.image = image;
                    
                } else if (error) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                                                        message:[error localizedDescription]
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        });
    }
}

@end

