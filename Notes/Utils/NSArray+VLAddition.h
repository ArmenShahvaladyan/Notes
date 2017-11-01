//
//  NSArray+VLAddition.h
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VLAddition)

- (NSArray *)mapObjectsWithBlock:(id (^)(id obj, NSUInteger idx))block;

@end
