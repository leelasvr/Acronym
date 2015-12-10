//
//  NetworkManager.m
//  Acronym
//
//  Created by Raidu on 09/12/15.
//  Copyright (c) 2015 Raidu. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NetworkManager


+ (id)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)searchForAcronymsOnServer: (NSString*)enteredText completionBlock:(Completion)completion {
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                enteredText, @"sf", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSArray* jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        completion(jsonObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
