#import <UIKit/UIKit.h>
#import "MenuItemSourceTextBar.h"
#import "MenuItemSourceCell.h"

@class Blog;
@class MenuItem;

@protocol MenuItemSourceViewDelegate;

@interface MenuItemSourceView : UIView <MenuItemSourceTextBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id <MenuItemSourceViewDelegate> delegate;
@property (nonatomic, strong) MenuItem *item;

/* A stackView for adding any views that aren't cells before the tableView, Ex. searchBar, label, design views
 */
@property (nonatomic, strong, readonly) UIStackView *stackView;

/* A tableView for inserting cells of data relating to the source
 */
@property (nonatomic, strong, readonly) UITableView *tableView;

/* Configurable fetchedResultsController for populating the tableView with source data.
 */
@property (nonatomic, strong) NSFetchedResultsController *resultsController;

/* Searchbar created and implemented via insertSearchBarIfNeeded
 */
@property (nonatomic, strong) MenuItemSourceTextBar *searchBar;

/* The blog the view is working with.
 */
- (Blog *)blog;

/* The managedObjectContext the view is working with.
 */
- (NSManagedObjectContext *)managedObjectContext;

/* Configurable fetchRequest within subclasses for the resultsController to initialize with.
 */
- (NSFetchRequest *)fetchRequest;

- (NSString *)fetechedResultsControllerSectionNameKeyPath;

/* Handles performing the fetchRequest on the resultsController and any errors that occur.
 */
- (void)performResultsControllerFetchRequest;

/* Method for subclasses to handle the cell configuraton based on the data being used for that subclass.
 */
- (void)configureSourceCell:(MenuItemSourceCell *)cell forIndexPath:(NSIndexPath *)indexPath;

/* Adds the custom searchBar view to the stackView, if not already added.
 */
- (void)insertSearchBarIfNeeded;

@end

@protocol MenuItemSourceViewDelegate <NSObject>

- (void)sourceViewDidBeginEditingWithKeyBoard:(MenuItemSourceView *)sourceView;
- (void)sourceViewDidEndEditingWithKeyboard:(MenuItemSourceView *)sourceView;

@end