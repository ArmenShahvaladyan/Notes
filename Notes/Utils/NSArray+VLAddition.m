//
//  NSArray+VLAddition.m
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "NSArray+VLAddition.h"

@implementation NSArray (VLAddition)

- (NSArray *)mapObjectsWithBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id mappedObj = block(obj, idx);
        if (mappedObj) {
            [result addObject:mappedObj];
        }
    }];
    return result;
}

@end
