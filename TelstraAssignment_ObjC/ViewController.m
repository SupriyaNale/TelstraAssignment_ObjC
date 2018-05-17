//
//  ViewController.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIAlertController+show.h"
#import "ResponseParser.h"
#import "DataModel.h"

@interface ViewController ()
{
    Reachability *internetReachableFoo;
}
@end

@implementation ViewController

#pragma Mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = title;
    
    //initialize Activity Indicators
    self.activityView = [[UIActivityIndicatorView alloc] init];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView = [[UIActivityIndicatorView alloc] init];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    // fetch data
    [self fetch];
    
    //Initialize tableview
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //Initialize Properties
    self.cache = [[NSCache alloc] init];
    self.session = [NSURLSession sharedSession];
    self.task = [[NSURLSessionDownloadTask alloc] init];
    
    [self drawTable];
    [self pullToRefresh];

}

-(void)viewDidLayoutSubviews {
    [self drawTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchedData.count > 0)
        return self.fetchedData.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self designWithIndex:indexPath cell:cell];
    
    return cell;
}

#pragma mark - UITableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark -Pull tp refresh
-(void)pullToRefresh {
    self.refreshCtrl = [[UIRefreshControl alloc] init];
    [self.refreshCtrl addTarget:self action:@selector(fetch) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshCtrl;
}

#pragma mark - UI Related Methods
-(void)drawTable {
    //Table View
    
    self.tableView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[CustomeTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - design

-(void)designWithIndex:(NSIndexPath *)indexPath  cell:(CustomeTableViewCell *)cell {
    self.navigationItem.title = title;
    
    DataModel *data = self.fetchedData[indexPath.row];
    [cell.titleLabel setText:([data.title  isEqualToString: @""] ? @"No Data Found" : data.title)];
    [cell.descLabel setText:([data.desc  isEqualToString: @""] ? @"No Data Found" : data.desc)];
    [cell.imageview setImage:[UIImage imageNamed:@"placeholder"]];
    
    self.activityView.center = cell.imageView.center;
    [cell.imageView addSubview:self.activityView];
    [self.activityView startAnimating];
    [self downloadImage:indexPath cell:cell];
}

-(void)downloadImage:(NSIndexPath *)indexPath cell:(CustomeTableViewCell *)cell {
    DataModel *data = self.fetchedData[indexPath.row];
    if([self.cache objectForKey:data.imageURL] != nil) {
        // Use cache
        [self.activityView stopAnimating];
        UIImage *img = [self.cache objectForKey:data.imageURL];
        [cell.imageview setImage:img];
    } else {
        NSURL *imageUrl = [NSURL URLWithString:data.imageURL];
        NSLog(@"image URL : %@",imageUrl);
        //download using URL session
        self.task = [[NSURLSession sharedSession] downloadTaskWithURL:imageUrl completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageview setImage:downloadedImage];
            });
        }];
        
        [self.task resume];
    }
}

#pragma mark - Get Data
-(void)fetch {
    self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height/2 - 60, 100, 100);
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.loadingView startAnimating];
    [self.tableView addSubview:self.loadingView];
    
    if([self connected]) {
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:baseURL]];
        
        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                NSData *finalData = [newStr dataUsingEncoding:NSUTF8StringEncoding];

                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:finalData options:0 error:&parseError];
                NSLog(@"The response is - %@",responseDictionary);
                // its array of dictionary
                NSMutableArray *imageData = responseDictionary[@"rows"];
                NSString *titleData = responseDictionary[@"title"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    title = titleData;
                    self.fetchedData = [NSMutableArray arrayWithArray:[ResponseParser imageDataFromJson:imageData]];
                    [self.tableView reloadData];
                    [self.refreshCtrl endRefreshing];

                });
            }
            else
            {
                NSLog(@"Error");     
            }
        }];
        [dataTask resume];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            [UIAlertController showAlertMessage:networkError];
        });
    }
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
