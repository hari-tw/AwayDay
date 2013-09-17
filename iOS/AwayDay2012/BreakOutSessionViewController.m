//
//  BreakOutSessionViewController.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "BreakOutSessionViewController.h"
#import "CustomBreakOutSessionCell.h"
#import "BreakOutSectionHeaderView.h"
#import "BreakOutSectionInfo.h"
#import "CustomSlider.h"

#import "BreakOutSession.h"
#import "RNFrostedSidebar.h"

#define HEADER_HEIGHT 60

@interface BreakOutSessionViewController ()<RNFrostedSidebarDelegate,InviteFriendsSectionHeaderViewDelegate,UIScrollViewDelegate>

{
    NSMutableArray *sectionImages;
    CustomSlider *slider;
}

@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic,strong) NSMutableArray *breakOutSessionDetails;

@end

@implementation BreakOutSessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)loadInfo
{
    
    NSMutableArray *sectionHeaderText=[[NSMutableArray alloc]initWithObjects:@"Track1",@"Track2",@"Track3",@"Track4",@"Track5",nil];
    self.sectionInfoDictionary=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *trackOneInfo=[[NSMutableDictionary alloc]init];
    [trackOneInfo setObject:[sectionHeaderText objectAtIndex:0] forKey:@"sectionHeaderName"];
    NSMutableArray *emailCellRowHeights=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[[[self.breakOutSessionDetails objectAtIndex:0] topics]count];i++)
    {
        [emailCellRowHeights addObject:[NSNumber numberWithFloat:45]];
    }
    [trackOneInfo setObject:emailCellRowHeights forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackOneInfo];
    
    
    NSMutableDictionary *trackTwoInfo=[[NSMutableDictionary alloc]init];
    [trackTwoInfo setObject:[sectionHeaderText objectAtIndex:1] forKey:@"sectionHeaderName"];
    NSMutableArray *telephoneCellrowHeight=[[NSMutableArray alloc]init];
    for(int i=0;i<[[[self.breakOutSessionDetails objectAtIndex:1] topics]count];i++)
        [telephoneCellrowHeight addObject:[NSNumber numberWithFloat:45]];
    
    [trackTwoInfo setObject:telephoneCellrowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackTwoInfo];
    
    
    
    NSMutableDictionary *trackThreeInfo=[[NSMutableDictionary alloc]init];
    [trackThreeInfo setObject:[sectionHeaderText objectAtIndex:3] forKey:@"sectionHeaderName"];
    NSMutableArray *byConnectingCellrowHeight=[[NSMutableArray alloc]init];
    for(int i=0;i<[[[self.breakOutSessionDetails objectAtIndex:2] topics]count];i++)
        [byConnectingCellrowHeight addObject:[NSNumber numberWithFloat:45]];
    
    [trackThreeInfo setObject:byConnectingCellrowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackThreeInfo];
    
    
    NSMutableDictionary *trackFourInfo=[[NSMutableDictionary alloc]init];
    [trackFourInfo setObject:[sectionHeaderText objectAtIndex:4] forKey:@"sectionHeaderName"];
    NSMutableArray *discoverFriendsRowHeight=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[[[self.breakOutSessionDetails objectAtIndex:3] topics]count];i++)
        [discoverFriendsRowHeight addObject:[NSNumber numberWithFloat:45]];
    [trackFourInfo setObject:discoverFriendsRowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackFourInfo];
    
    
    
    NSMutableDictionary *trackFiveInfo=[[NSMutableDictionary alloc]init];
    [trackFiveInfo setObject:[sectionHeaderText objectAtIndex:4] forKey:@"sectionHeaderName"];
    NSMutableArray *tarckFiveHeight=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[[[self.breakOutSessionDetails objectAtIndex:4] topics]count];i++)
        [tarckFiveHeight addObject:[NSNumber numberWithFloat:45]];
    [trackFiveInfo setObject:tarckFiveHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackFiveInfo];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sectionImages = [[NSMutableArray alloc]initWithObjects:@"open-our-eyes 2.png",@"south-globe.png",@"Impact 2.png",@"relavance_c.png",@"innovation 3.png",nil];
    
    self.breakOutSessionDetails=[[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Break_out"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSLog(@"%@",data);
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    
    
    NSLog(@"%@",json);
    
    for(NSDictionary *dict in json)
    {
        
        BreakOutSession *session = [[BreakOutSession alloc]init];
        
        NSLog(@"%@",[dict valueForKey:@"captainName"]);
        NSLog(@"%@",[dict valueForKey:@"trackTopic"]);
        session.captainName= [dict valueForKey:@"captainName"];
        session.trackTopic= [dict valueForKey:@"trackTopic"];
        session.topics = [dict valueForKey:@"topics"];
        [self.breakOutSessionDetails addObject:session];
        
    }
    
    [self loadInfo];
    self.openSectionIndex = NSNotFound;
    
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.breakOutSessionTableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (NSMutableArray *array in self.sectionInfoDictionary) {
			
			BreakOutSectionInfo *sectionInfo = [[BreakOutSectionInfo alloc] init];
			sectionInfo.play = array;
			sectionInfo.open = NO;
			
            //  NSNumber *defaultRowHeight = [NSNumber numberWithInteger:160];
			NSInteger countOfTeamNames = [[sectionInfo.play valueForKey:@"rowHeights"]count];
			for (NSInteger i = 0; i < countOfTeamNames; i++) {
				[sectionInfo insertObject:[[sectionInfo.play valueForKey:@"rowHeights"] objectAtIndex:i] inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}
    
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}


#pragma mark -table view data source method.

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    //  return [self.plays count];
    return self.breakOutSessionDetails.count;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    NSLog(@"%@",sectionInfo);
	NSInteger numStoriesInSection = [[sectionInfo.play valueForKey:@"rowHeights"] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    
    static NSString *emailListIdentifier = @"breakOutCellIdentifier";
    
    CustomBreakOutSessionCell *cell = (CustomBreakOutSessionCell*)[tableView dequeueReusableCellWithIdentifier:emailListIdentifier];
    
    BreakOutSession *session = [self.breakOutSessionDetails objectAtIndex:indexPath.section];
    
    
    cell.topicTextLabel.text= [NSString stringWithFormat:@"%@",[[session.topics objectAtIndex:indexPath.row] valueForKey:@"topic_name"]];
    cell.topicSpeakerNameTextLabel.text= [NSString stringWithFormat:@"%@",[[session.topics objectAtIndex:indexPath.row] valueForKey:@"topic_speaker"]];
    cell.timeTextLabel.text= [NSString stringWithFormat:@"%@",[[session.topics objectAtIndex:indexPath.row] valueForKey:@"time"]];
    
    
    
    
    
    return cell;
    
}




-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		//NSString *playName = [sectionInfo.play valueForKey:@"sectionHeaderName"];
        sectionInfo.headerView = [[BreakOutSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.breakOutSessionTableView.bounds.size.width, HEADER_HEIGHT) title:[[self.breakOutSessionDetails objectAtIndex:section] trackTopic]  coordinator:[[self.breakOutSessionDetails objectAtIndex:section] captainName] image:[sectionImages objectAtIndex:section]  section:section delegate:self];
    }
    
    return sectionInfo.headerView;
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    //	AMGInviteFriendsSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    //    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    
    return [[[[self.sectionInfoDictionary objectAtIndex:indexPath.section] valueForKey:@"rowHeights"]objectAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
    
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


//#pragma mark Section header delegate

-(void)sectionHeaderView:(BreakOutSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
    NSLog(@"%d",sectionOpened);
    
    
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [[sectionInfo.play valueForKey:@"rowHeights"]count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		BreakOutSectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [[previousOpenSection.play valueForKey:@"rowHeights"]count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    for(NSIndexPath *index in indexPathsToDelete)
        NSLog(@"%@",index);
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation=nil;
    UITableViewRowAnimation deleteAnimation=nil;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex)
    {
        insertAnimation = UITableViewRowAnimationFade;
        deleteAnimation = UITableViewRowAnimationFade;
    }
    else {
        insertAnimation = UITableViewRowAnimationFade;
        deleteAnimation = UITableViewRowAnimationFade;
    }
    
    // Apply the updates.
    [self.breakOutSessionTableView beginUpdates];
    //    [self.breakOutSessionTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:insertAnimation];
    [self.breakOutSessionTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.breakOutSessionTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.breakOutSessionTableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
}
//
//
-(void)sectionHeaderView:(BreakOutSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.breakOutSessionTableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.breakOutSessionTableView
         deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
    self.openSectionIndex = NSNotFound;
}


- (void)viewDidUnload {
    
    [self setBreakOutSessionTableView:nil];
    [super viewDidUnload];
}





#pragma mark - RNFrostedSidebar delegate.
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    NSLog(@"%d",index);
    
    switch (index) {
        case 0:
        {
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
            [slider showMapScreen];
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
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
            
        }
            break;
        case 6 :
        {
            [slider showVideoScreen];
            [sidebar dismiss];
            
        }
            break;
            
            
            
        default:
            break;
    }
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // Fades out top and bottom cells in table view as they leave the screen
//    NSArray *visibleCells = [self.breakOutSessionTableView visibleCells];
//    NSLog(@"%d",visibleCells.count);
//
//    CGPoint offset = self.breakOutSessionTableView.contentOffset;
//    CGRect bounds = self.breakOutSessionTableView.bounds;
//    CGSize size = self.breakOutSessionTableView.contentSize;
//    UIEdgeInsets inset = self.breakOutSessionTableView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//
//
//    if (y > h) {
//        //self.breakOutSessionTableView.alpha = 1 - (y/h - 1)*4;
//        for (CustomBreakOutSessionCell *cell in visibleCells) {
//            cell.contentView.alpha = 0.0;//- (y/h - 1)*4;
//        }
//    } else {
//        for (CustomBreakOutSessionCell *cell in visibleCells) {
//            cell.contentView.alpha = 1;
//        }
//       // self.breakOutSessionTableView.alpha = 1;
//    }
//}
//



#pragma mark - action ethod.
- (IBAction)sideMenuTapped:(id)sender {
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

@end
