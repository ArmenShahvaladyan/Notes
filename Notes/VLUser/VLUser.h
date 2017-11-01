//
//  VLUser.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Realm/Realm.h>
#import "VLNote.h"

RLM_ARRAY_TYPE(VLNote)
@interface VLUser : RLMObject

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSData *encryptPassword;
@property RLMArray<VLNote *><VLNote> *notes;

@end
