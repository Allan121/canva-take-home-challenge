//
//  ServicesAPI.m
//  Photo Mosaic
//
//  Created by Allan Poole on 30/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "ServicesAPI.h"
#import <TakeHomeTask/TakeHomeTask.h>
#import "AsynchronousBlockOperation.h"

@interface ServicesAPI()

@property (nonatomic, strong) MosaicTileServer *tileServer;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation ServicesAPI

+ (instancetype)sharedInstance {
    
    static ServicesAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.tileServer = [[MosaicTileServer alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 75;
    }
    
    return self;
}

- (void)fetchTileForColor:(UIColor *)color size:(CGSize)size completion:(void(^)(UIImage *image, NSError *error))completion {
    
    AsynchronousBlockOperation *operation = [[AsynchronousBlockOperation alloc] init];

    __weak AsynchronousBlockOperation *weakOperation = operation;
    
    [weakOperation addExecutionBlock:^{
        
        if (![weakOperation isCancelled]) {
            
            [self.tileServer fetchTileForColor:color size:size success:^(UIImage * _Nonnull image) {
                
                completion(image, nil);
                [weakOperation completeOperation];
                
            } failure:^(NSError * _Nonnull error) {
                
                completion(nil, error);
                [weakOperation completeOperation];
            }];
        }
    }];
    
    [self.operationQueue addOperation:operation];
}

- (void)cancellAllTileOperations {
    
    [self.operationQueue cancelAllOperations];
}

@end
