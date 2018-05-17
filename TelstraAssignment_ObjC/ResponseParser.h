//
//  ResponseParser.h
//  TelstraAssignment_ObjC
//
//  Created by Yash on 17/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseParser : NSObject

+(NSMutableArray *)imageDataFromJson:(NSMutableArray *)json;

@end
