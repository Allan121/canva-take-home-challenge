//
//  AsynchronousOperation.h
//  PhotoMosaic
//
//  Created by Allan Poole on 31/07/2016.
//  Copyright © 2016 Allan Poole. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Subclass of NSBlockOperation that includes extra functionality to support asynchornous tasks, 
 * and manual operation completion.
 */
@interface AsynchronousBlockOperation : NSBlockOperation

/**
 * Manually trigger operation completion.
 */
- (void)completeOperation;

@end
