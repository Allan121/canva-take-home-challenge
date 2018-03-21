//
//  ViewController.m
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsPopoverViewController.h"
#import "TileView.h"
#import "UIImage+Additions.h"
#import "UIView+HelperMethods.h"
#import "ServicesAPI.h"

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, SettingsPopoverViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIView *tileContainerView;
@property (nonatomic, strong) UIImage *displayImage;

@property (nonatomic, strong) NSArray *currentTiles;
@property (nonatomic, assign) ImageTileType currentTileType;

- (IBAction)choosePhotoButtonTapped:(id)sender;

@end

@implementation MainViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.image = [UIImage imageNamed:@"downarrow"];
    [self.containerView addSubview:self.photoView];
    
    self.tileContainerView = [[UIView alloc] init];
    self.tileContainerView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.tileContainerView.layer.borderWidth = 2.f;
    [self.containerView addSubview:self.tileContainerView];
    
    self.currentTileType = ImageTileTypeDefault;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

    if ([self isPortaitMode]) {
        
        CGFloat width = [self adjustValueForCurrentTileType:self.containerView.width];
        CGFloat height = [self adjustValueForCurrentTileType:width * [self aspectRatio]];
        
        if (height > self.containerView.height) {
            
            height = [self adjustValueForCurrentTileType:self.containerView.height];
        }
        
        self.photoView.frame = CGRectMake(0.f, 0.f, width, height);
        
    } else {
        
        CGFloat height = [self adjustValueForCurrentTileType:self.containerView.height];
        
        CGFloat width = [self adjustValueForCurrentTileType:self.containerView.height * [self aspectRatio]];
        
        if (width > self.containerView.width) {
            
            width = [self adjustValueForCurrentTileType:self.containerView.width];
        }
        
        self.photoView.frame = CGRectMake(0.f, 0.f, width, height);
    }
    
    if (self.displayImage) {
        
        if (self.displayImage.size.width > self.photoView.width && self.displayImage.size.height > self.photoView.height) {
            
            self.photoView.image = [UIImage resizedImageForBaseImage:self.displayImage size:self.photoView.frame.size];
            
        } else {
            
            self.photoView.frame = CGRectMake(0.f, 0.f, self.displayImage.size.width, self.displayImage.size.height);
            self.photoView.image = self.displayImage;
        }
        
        self.currentTiles = [self createTilesForImage:self.photoView.image tileType:self.currentTileType];
    }
    
    self.photoView.center = CGPointMake(self.containerView.width / 2.f, self.containerView.height / 2.f);
    
    self.tileContainerView.frame = self.photoView.frame;
}

#pragma mark - Property management

- (void)setCurrentTiles:(NSArray *)currentTiles {
    
    //Remove any exiting (old) tiles
    if (self.currentTiles) {
        
        for (TileView *tile in self.currentTiles) {
            
            [tile removeFromSuperview];
        }
    }
    
    _currentTiles = currentTiles;
}

#pragma mark - UI Methods

- (IBAction)choosePhotoButtonTapped:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"popoverSegue"]) {
        
        SettingsPopoverViewController *popoverViewController = segue.destinationViewController;
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        popoverViewController.delegate = self;
        popoverViewController.popoverPresentationController.delegate = self;
        
        UIButton *settingsButton = (UIButton *)sender;
        
        popoverViewController.popoverPresentationController.sourceView = self.view;
        popoverViewController.popoverPresentationController.sourceRect = settingsButton.frame;
    }
}

#pragma mark - Helper Methods

- (CGFloat)adjustValueForCurrentTileType:(CGFloat)value {
    
    return value - fmod(value, [self sizeForImageTileType:self.currentTileType].width);
}

- (CGSize)sizeForImageTileType:(ImageTileType)tileType {
    
    CGSize size;
    
    switch (tileType) {
            
        case ImageTileTypeLargeSquare:
            size = CGSizeMake(64.f, 64.f);
            break;
            
        case ImageTileTypeSmallSquare:
            size = CGSizeMake(16.f, 16.f);
            break;
            
        case ImageTileTypeDefault:
        default:
            size = CGSizeMake(32.f, 32.f);
            break;
    }
    
    return size;
}

- (CGFloat)aspectRatio {
    
    if (!self.displayImage) {
        
        return 1.f;
    }
    
    if ([self isPortaitMode]) {
        
        return self.displayImage.size.height / self.displayImage.size.width;
        
    } else {
        
        return self.displayImage.size.width / self.displayImage.size.height;
    }
}

- (BOOL)isPortaitMode {
    
    return self.containerView.height > self.containerView.width;
}

- (NSArray *)createTilesForImage:(UIImage *)image tileType:(ImageTileType)tileType {
    
    [[ServicesAPI sharedInstance] cancellAllTileOperations];
    
    NSMutableArray *tiles = [NSMutableArray new];
    
    CGSize tileSize = [self sizeForImageTileType:tileType];
    
    CGRect currentTileFrame = CGRectMake(0.f, 0.f, tileSize.width, tileSize.height);
    
    for (int row = 0; row < image.size.height/tileSize.height; row++) {
        
        for (int col = 0; col < image.size.width/tileSize.width; col++) {
            
            UIImage *tileImage = [UIImage croppedImageForBaseImage:image croppingRect:currentTileFrame];
            TileView *tile = [[TileView alloc] initWithFrame:currentTileFrame baseImage:tileImage];
            [tiles addObject:tile];
            [self.tileContainerView addSubview:tile];
            
            currentTileFrame.origin.x += tileSize.width;
        }
        
        currentTileFrame.origin.x = 0;
        currentTileFrame.origin.y += tileSize.height;
    }
    
    return tiles;
}

#pragma mark - SettingsPopoverViewControllerDelegate

- (void)settingsPopoverViewController:(SettingsPopoverViewController *)settingsPopoverViewcontroller tileTypeSelected:(ImageTileType)tileType {
    
    self.currentTileType = tileType;
    [self.view setNeedsLayout];
}

- (void)settingsPopoverViewController:(SettingsPopoverViewController *)settingsPopoverViewcontroller showOriginalImageValueChanged:(BOOL)showOriginalImage {
    
    self.photoView.hidden = !showOriginalImage;
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.displayImage = info[UIImagePickerControllerOriginalImage];

    [self.view setNeedsLayout];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Size Class Methods

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.currentTiles = nil;
    
    [self.view setNeedsLayout];
}

@end
