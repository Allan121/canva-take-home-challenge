//
//  AsynchronousOperation.m
//  PhotoMosaic
//
//  Created by Allan Poole on 31/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import "AsynchronousBlockOperation.h"

@interface AsynchronousBlockOperation()

@property (atomic, assign) BOOL _executing;
@property (atomic, assign) BOOL _finished;

@end

@implementation AsynchronousBlockOperation

- (void)start {
    
    if ([self isCancelled]) {
        
        [self willChangeValueForKey:@"isFinished"];
        self._finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
 
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self._executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    
    if ([self isCancelled]) {
        
        return;
    }
    
    for (void (^executionBlock)(void) in self.executionBlocks) {
        
        executionBlock();
    }
}

- (BOOL)isAsynchronous {
    
    return YES;
}

- (BOOL)isExecuting {
    
    return self._executing;
}

- (BOOL)isFinished {
    
    return self._finished;
}

- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    self._executing = NO;
    self._finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end

