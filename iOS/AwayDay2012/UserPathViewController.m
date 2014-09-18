//
//  UserActivityViewControllerViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPathViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "AppHelper.h"
#import "RNFrostedSidebar.h"
#import "CustomSlider.h"
#import "CFShareCircleView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <Social/Social.h>

#define tag_view_table_child_view   10001
#define tag_view_table_path_image   tag_view_table_child_view+1
#define tag_req_delete_path     1001

@interface UserPathViewController()<RNFrostedSidebarDelegate,CFShareCircleViewDelegate>
{
    CustomSlider *slider;
}
    @property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) CFShareCircleView *shareCircleView;
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

    if(self.pathList==nil){
        NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:0];
        self.pathList=list;
    }
    
    if(self.operationQueue==nil){
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        self.operationQueue=queue;
    }
    [self.operationQueue setMaxConcurrentOperationCount:5];

    [self buildUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserActivity];
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
//        [self authorizeWeibo];
    }
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
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

#pragma mark -RNFrostedSidebar delegate method.
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0: {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;
            
        case 1:
        {
            [slider showAgendaScreen];
            [sidebar dismiss];
            
        }
            break;
        case 2 :
        {
            [slider showSpeakersScreen];
            [sidebar dismiss];
            
        }
            break;
        case 3 :
        {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
            
            
            
        }
            break;
        case 4 :
        {
            [slider showMyEventsScreen];
            [sidebar dismiss];
            
        }
            break;
        case 5 :
        {
            [slider showNotificationScreen];
            [sidebar dismiss];
        }
            break;
        case 6 :
        {
            [slider showHomeScreen];
            [sidebar dismiss];

        }
            break;
        case 7:
        {
            [sidebar dismiss];
            // Do any additional setup after loading the view, typically from a nib.
             [slider showGameInfoSCreen];
        }
            break;
        default:
            break;
    }
    
}


- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer
{
    NSLog(@"Selected sharer: %@", sharer.name);
    if([sharer.name isEqualToString:@"Twitter"])
        [self postOnTWitterWall];
    else
        [self postOnFacebookWall];
    
}

- (void)shareCircleCanceled:(NSNotification *)notification{
    NSLog(@"Share circle view was canceled.");
}



-(void)postOnFacebookWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013!";
        [mySLComposerSheet setInitialText:shareText];
        
        //        [mySLComposerSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50.jpg"]]]];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
}

-(void)postOnTWitterWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013 (27 & 28th September)! ";
        [mySLComposerSheet setInitialText:shareText];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
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
    [timeLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0f]];
    [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [cell addSubview:timeLabel];
    
    [formatter setDateFormat:@"MM-dd"];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 50, 20)];
    [dateLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0f]];
    [dateLabel setTag:tag_view_table_child_view];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTextAlignment:UITextAlignmentRight];
    [dateLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [cell addSubview:dateLabel];
    
    
    UIView *seperator=[[UIView alloc]initWithFrame:CGRectMake(65, 0, 1, 70)];
    if(path.hasImage!=nil && path.hasImage.boolValue && path.pathContent!=nil && path.pathContent.length>0){
        [seperator setFrame:CGRectMake(65, 0, 1, 120)];
    }
    [seperator setTag:tag_view_table_child_view];
    [seperator setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5f]];
    [cell addSubview:seperator];
    
    int y=5;
    
    if(path.pathContent!=nil && path.pathContent.length>0){
        UITextView *pathContent=[[UITextView alloc]initWithFrame:CGRectMake(67, y, 250, 50)];
        [pathContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"path_content_back.png"]]];
        [pathContent setText:path.pathContent];
        [pathContent setTag:tag_view_table_child_view];
        [pathContent setUserInteractionEnabled:NO];
        [pathContent setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
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



@end
