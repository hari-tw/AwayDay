//
//  UserActivityViewControllerViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPathViewController.h"
#import "AppDelegate.h"
#import "DBService.h"
#import "AppConstant.h"
#import "UserPath.h"
#import "AppHelper.h"
#import "ASIFormDataRequest.h"
#import "RNFrostedSidebar.h"
#import "SpeakersViewController.h"

#define tag_view_table_child_view   10001
#define tag_view_table_path_image   tag_view_table_child_view+1
#define key_timer_table_cell        @"timer_key_cell"
#define key_timer_user_path         @"timer_key_path"
#define key_timer_path_image        @"timer_key_path_image"
#define tag_req_delete_path     1001

@interface UserPathViewController()
    @property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation UserPathViewController
@synthesize pathList=_pathList;
@synthesize userPathTable=_userPathTable;
@synthesize userNameLabel=_userNameLabel;
@synthesize userRecordsCountLabel=_userRecordsCountLabel;
@synthesize operationQueue=_operationQueue;
@synthesize postShareViewController=_postShareViewController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.optionIndices = [[NSMutableIndexSet alloc]init];
    if(self.pathList==nil){
        NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:0];
        self.pathList=list;
    }
    
    if(self.operationQueue==nil){
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        self.operationQueue=queue;
    }
    [self.operationQueue setMaxConcurrentOperationCount:5];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserActivity];
    [self buildUI];
}

#pragma mark - UIAction method
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)addPathButtonPressed:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([appDelegate.userState objectForKey:kUserWeiboTokenKey]) {
        [self displayPostShareVC];
    } else {
        [self authorizeWeibo];
    }
}

- (void)authorizeWeibo {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"email,direct_messages_write";
    [WeiboSDK sendRequest:request];
}

- (void)displayPostShareVC {
    if(self.postShareViewController==nil){
        PostShareViewController *psvc=[[PostShareViewController alloc]initWithNibName:@"PostShareViewController" bundle:nil];
        self.postShareViewController=psvc;
    }
    [self.navigationController pushViewController:self.postShareViewController animated:YES];
}

-(IBAction)pathImageButtonPressed:(id)sender{
    UIButton *button=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[button superview];
    int index=[self.userPathTable indexPathForCell:cell].row;
    UserPath *userPath=[self.pathList objectAtIndex:index];
    UIImage *image=[userPath loadLocalPathImage];
    if(image!=nil){
        UIView *largeImageView=[[UIView alloc]initWithFrame:self.view.frame];
        
        UIView *back=[[UIView alloc]initWithFrame:self.view.frame];
        [back setBackgroundColor:[UIColor blackColor]];
        [back setAlpha:0.7f];
        [largeImageView addSubview:back];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:image];
        [imageView setUserInteractionEnabled:YES];
        [imageView setMultipleTouchEnabled:YES];
        [largeImageView addSubview:imageView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [largeImageView addGestureRecognizer:tap];
        
        [self.view addSubview:largeImageView];
    }
}

-(IBAction)handleTapGesture:(UITapGestureRecognizer *)sender{
    [sender.view removeFromSuperview];
}

- (IBAction)sideMenuTapped:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"agenda"],
                        [UIImage imageNamed:@"speaker_icon"],
                        [UIImage imageNamed:@"map"],
                        [UIImage imageNamed:@"my_schedule"],
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];

    
    
    
}

#pragma mark - util method
-(void)loadUserActivity{
    [self.pathList removeAllObjects];
    NSMutableArray *list=[UserPath getAllUserPath];
    if(list!=nil && list.count>0){
        [self.pathList removeAllObjects];
        [self.pathList addObjectsFromArray:list];
    }
}

-(void)buildUI{
    [self.userNameLabel.layer setMasksToBounds:YES];
    [self.userNameLabel.layer setCornerRadius:15.0f];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *userName=[appDelegate.userState objectForKey:kUserNameKey];
    [self.userNameLabel setText:userName];
    [self.userRecordsCountLabel setText:[NSString stringWithFormat:@"has %d records", self.pathList.count]];
    [self.userPathTable reloadData];
}

-(void)buildPathCell:(UITableViewCell *)cell withPath:(UserPath *)path{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
    [timeLabel setTextAlignment:UITextAlignmentRight];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTag:tag_view_table_child_view];
    [timeLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [timeLabel setTextColor:[UIColor colorWithRed:31/255.0 green:206/255.0 blue:217/255.0 alpha:1.0f]];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cell addSubview:timeLabel];
    
    [formatter setDateFormat:@"MM-dd"];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 50, 20)];
    [dateLabel setTextColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f]];
    [dateLabel setTag:tag_view_table_child_view];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTextAlignment:UITextAlignmentRight];
    [dateLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [cell addSubview:dateLabel];
    
    
    UIView *seperator=[[UIView alloc]initWithFrame:CGRectMake(65, 0, 2, 70)];
    if(path.hasImage!=nil && path.hasImage.boolValue && path.pathContent!=nil && path.pathContent.length>0){
        [seperator setFrame:CGRectMake(65, 0, 2, 120)];
    }
    [seperator setTag:tag_view_table_child_view];
    [seperator setBackgroundColor:[UIColor colorWithRed:186/255.0 green:233/255.0 blue:236/255.0 alpha:1.0f]];
    [cell addSubview:seperator];
    
    int y=5;
    
    if(path.pathContent!=nil && path.pathContent.length>0){
        UITextView *pathContent=[[UITextView alloc]initWithFrame:CGRectMake(67, y, 250, 50)];
        [pathContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"path_content_back.png"]]];
        [pathContent setText:path.pathContent];
        [pathContent setTag:tag_view_table_child_view];
        [pathContent setUserInteractionEnabled:NO];
        [pathContent setFont:[UIFont systemFontOfSize:14.0f]];
        [pathContent setTextColor:[UIColor blackColor]];
        [cell addSubview:pathContent];
        y=57;
    }
    
    if(path.hasImage!=nil && path.hasImage.boolValue){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button.imageView setClipsToBounds:YES];
        [button setFrame:CGRectMake(70, y, 240,60)];
        [button setTag:tag_view_table_path_image];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button setAdjustsImageWhenHighlighted:NO];
        [cell addSubview:button];
        
        UIImage *image=[path loadLocalPathImage];
        if(image!=nil){
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pathImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //to load the image from server
        }
    }
}

-(void)deleteUserPathOnServer:(UserPath *)userPath{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]initWithCapacity:0];
    
    [param setObject:[AppHelper macaddress] forKey:kDeviceIDKey];
    [param setObject:userPath.pathID forKey:kTimastampKey];
//    SBJsonWriter *jsonWriter=[[SBJsonWriter alloc]init];
    NSString *paramString;//=[jsonWriter stringWithObject:param];

    //I'm here
    ASIFormDataRequest *req=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kServiceUserPath]];
    [req setRequestMethod:@"DELETE"];
    [req addPostValue:paramString forKey:nil];
    [req setTag:tag_req_delete_path];
    [req setDelegate:self];
    [req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"done response:%@", request.responseString);
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"fail response:%@", request.responseString);
}

#pragma mark - UITableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pathList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
    if(userPath.hasImage!=nil && userPath.hasImage.boolValue && userPath.pathContent!=nil && userPath.pathContent.length>0){
        return 120.0f;
    }
    return 70.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in cell.subviews){
        if(view.tag==tag_view_table_child_view || view.tag==tag_view_table_path_image){
            [view removeFromSuperview];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
    [self buildPathCell:cell withPath:userPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle==UITableViewCellEditingStyleDelete){
        UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
        [self deleteUserPathOnServer:userPath];
        [userPath drop];
        [self.pathList removeObjectAtIndex:indexPath.row];
        [self.userPathTable reloadData];
        [self.userRecordsCountLabel setText:[NSString stringWithFormat:@"has %d records", self.pathList.count]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.operationQueue cancelAllOperations];
}


#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    if(index==0)
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[AgendaViewController alloc]initWithNibName:@"RootViewController" bundle:nil ]] animated:YES];
        [sidebar dismiss];
        
        
    }
    
    else if(index==1)
    {
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SpeakersViewController *speakerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"speakersViewIdentifier"];
        [self.navigationController pushViewController:speakerViewController animated:YES];
        
        
        
        [sidebar dismiss];
    }
    else if(index==2)
    {
//        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude, 12.969034,77.745137];
//        
//        NSString *escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSURL *url=[NSURL URLWithString:escapedString];
//        [[UIApplication sharedApplication]openURL:url];
        
        
    }
    else if(index==3)
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.userPathViewController] animated:YES];
        [sidebar dismiss];
    }
    
    
    
}




@end
