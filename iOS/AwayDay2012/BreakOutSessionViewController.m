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
#import "RNFrostedSidebar.h"

#define HEADER_HEIGHT 100

@interface BreakOutSessionViewController ()<RNFrostedSidebarDelegate,InviteFriendsSectionHeaderViewDelegate>

{
    CustomSlider *slider;
}
@property (nonatomic, assign) NSInteger openSectionIndex;


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
    
    for(int i=1;i<=5;i++)
    {
        [emailCellRowHeights addObject:[NSNumber numberWithFloat:70]];
    }
    [trackOneInfo setObject:emailCellRowHeights forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackOneInfo];
    
    
    NSMutableDictionary *trackTwoInfo=[[NSMutableDictionary alloc]init];
    [trackTwoInfo setObject:[sectionHeaderText objectAtIndex:1] forKey:@"sectionHeaderName"];
    NSMutableArray *telephoneCellrowHeight=[[NSMutableArray alloc]init];
    for(int i=0;i<=5;i++)
        [telephoneCellrowHeight addObject:[NSNumber numberWithFloat:70]];
    
    [trackTwoInfo setObject:telephoneCellrowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackTwoInfo];
    
    
    
    NSMutableDictionary *trackThreeInfo=[[NSMutableDictionary alloc]init];
    [trackThreeInfo setObject:[sectionHeaderText objectAtIndex:3] forKey:@"sectionHeaderName"];
    NSMutableArray *byConnectingCellrowHeight=[[NSMutableArray alloc]init];
    for(int i=0;i<=5;i++)
        [byConnectingCellrowHeight addObject:[NSNumber numberWithFloat:70]];
    
    [trackThreeInfo setObject:byConnectingCellrowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackThreeInfo];
    
    
    NSMutableDictionary *trackFourInfo=[[NSMutableDictionary alloc]init];
    [trackFourInfo setObject:[sectionHeaderText objectAtIndex:4] forKey:@"sectionHeaderName"];
    NSMutableArray *discoverFriendsRowHeight=[[NSMutableArray alloc]init];
    
    for(int i=0;i<=5;i++)
        [discoverFriendsRowHeight addObject:[NSNumber numberWithFloat:70]];
    [trackFourInfo setObject:discoverFriendsRowHeight forKey:@"rowHeights"];
    [self.sectionInfoDictionary addObject:trackFourInfo];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Break_out"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSLog(@"%@",data);
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    
    
    NSLog(@"%@",json);
    
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
    return 4;
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
    
    
    return cell;
    
}




-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		NSString *playName = [sectionInfo.play valueForKey:@"sectionHeaderName"];
        sectionInfo.headerView = [[BreakOutSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.breakOutSessionTableView.bounds.size.width, HEADER_HEIGHT) title:playName coordinator:@" s hxasxjksa " section:section delegate:self];
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
        // previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [[previousOpenSection.play valueForKey:@"rowHeights"]count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    // UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationFade;
        // deleteAnimation = UITableViewRowAnimationFade;
    }
    else {
        insertAnimation = UITableViewRowAnimationFade;
        // deleteAnimation = UITableViewRowAnimationFade;
    }
    
    // Apply the updates.
    [self.breakOutSessionTableView beginUpdates];
    [self.breakOutSessionTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    // [self.fullProfileTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.breakOutSessionTableView endUpdates];
    // self.openSectionIndex = sectionOpened;
    
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
    //self.openSectionIndex = NSNotFound;
}


- (void)viewDidUnload {
    
    [self setBreakOutSessionTableView:nil];
    [super viewDidUnload];
}





#pragma mark - RNFrostedSidebar delegate.
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
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


#pragma mark - action ethod.
- (IBAction)sideMenuTapped:(id)sender {
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

@end
