//
//  NetworkManager.h
//  Acronym
//
//  Created by Raidu on 09/12/15.
//  Copyright (c) 2015 Raidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(NSArray *response);

@interface NetworkManager : NSObject

+ (id)sharedManager;
- (void)searchForAcronymsOnServer: (NSString*)enteredText completionBlock:(Completion)completion;


@end
