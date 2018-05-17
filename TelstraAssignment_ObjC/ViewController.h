//
//  ViewController.h
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomeTableViewCell.h"


@interface ViewController : UIViewController < UITableViewDataSource , UITableViewDelegate>

//MARK:- Properties
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *fetchedData;

@property (strong, nonatomic) UIRefreshControl *refreshCtrl;
@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (strong, nonatomic) NSURLSession *session;

@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;


@end

