//
//  QBUserHomeViewController.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBUserHomeViewController.h"
#import "QBContact.h"
#import "QBContactGroup.h"
#import "QBLoginViewController.h"

#define CONNECTION_TAG_BACKUP 1001
#define CONNECTION_TAG_FETCH_BY_ID 1002
#define CONNECTION_TAG_LOGOUT 1003
#define CONNECTION_TAG_UPDATE_ID 1004

@interface QBUserHomeViewController () {
    NSArray *_contactsArray;
    NSMutableArray *_insertedContactsArray;
    NSOperationQueue *_operationQueue;
    CNContactStore *_addressbook;
    NSArray *_keysToFetch;
    NSInteger _operationCount;
    IBOutlet UIButton *_logoutButton;
    IBOutlet UIButton *_backupButton;
    IBOutlet UIButton *_restoreButton;

}

@end

@implementation QBUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CNContactStore class]) {
        _addressbook = [[CNContactStore alloc] init];
        _keysToFetch = @[CNContactEmailAddressesKey,
                         CNContactFamilyNameKey,
                         CNContactGivenNameKey,
                         CNContactPhoneNumbersKey,
                         CNContactPostalAddressesKey,
                         CNContactIdentifierKey,
                         CNContactOrganizationNameKey];
    }
   
    self.title = [NSString stringWithFormat:@"Welcome %@!", [QBAppContext sharedInstance].currentUser.firstName];
    
    _backupButton.layer.borderColor = [UIColor grayColor].CGColor;
    _backupButton.layer.cornerRadius = 2.0f;
    _restoreButton.layer.borderColor = [UIColor grayColor].CGColor;
    _restoreButton.layer.cornerRadius = 2.0f;
    _logoutButton.exclusiveTouch = YES;
    _backupButton.exclusiveTouch = YES;
    _restoreButton.exclusiveTouch = YES;

}


#pragma mark - IBActions
- (IBAction)backupButtonAction:(id)sender {
    self.showActivityIndicator = YES;

    QBWebServiceHandler *connection = [[QBWebServiceHandler alloc] init];
    connection.delegate = self;
    connection.procedureName = @"backupContacts";
    connection.connectionTag = CONNECTION_TAG_BACKUP;
    NSArray *contacts = [self fetchContactsFromDeviceToDictionary:YES];
    
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token, @"contacts" : contacts};
    [connection connect];
    
}

- (IBAction)restoreButtonAction:(id)sender {
    self.showActivityIndicator = YES;
    QBWebServiceHandler *connection = [[QBWebServiceHandler alloc] init];
    connection.delegate = self;
    connection.procedureName = @"fetchContactsById";
    connection.connectionTag = CONNECTION_TAG_FETCH_BY_ID;
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token};
    [connection connect];
    
}

- (IBAction)logoutButtonAction:(id)sender {
    if ([QBAppContext sharedInstance].currentUser) {
        self.showActivityIndicator = YES;
        
        QBWebServiceHandler *connection = [[QBWebServiceHandler alloc] init];
        connection.delegate = self;
        connection.procedureName = @"logout";
        connection.connectionTag = CONNECTION_TAG_LOGOUT;
        connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token};
        [connection connect];
    } else {
        [self dismissCurrentPage];
    }
    
}

- (void)dismissCurrentPage {
    if ([QBAppSettings sharedInstance].isUserAlreadyLoggedIn) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        QBLoginViewController *rootViewController = (QBLoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"QBLoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
        
    }
    else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (NSArray*)fetchContactsFromDeviceToDictionary:(BOOL)convertToDictionary {
    NSMutableArray *contacts = [NSMutableArray array];
    if ([CNContactStore class]) {
        //Class Exists
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:_keysToFetch];
        [_addressbook enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            QBContact *group = [[QBContact alloc] init];
            group.firstName = contact.givenName;
            group.lastName = contact.familyName;
            group.contactId = contact.identifier;
            
            NSMutableArray *phoneArray = [NSMutableArray array];
            for (CNLabeledValue *value in contact.phoneNumbers) {
                CNPhoneNumber *phoneNumber = value.value;
                QBContactLabelValue *labelValue = [[QBContactLabelValue alloc] init];
                labelValue.label = value.label;
                labelValue.value = phoneNumber.stringValue;
                [phoneArray addObject:labelValue];
            }
            
            group.phoneNumbersArray = phoneArray;
            
            NSMutableArray *emailArray = [NSMutableArray array];
            
            for (CNLabeledValue *value in contact.emailAddresses) {
                QBContactLabelValue *labelValue = [[QBContactLabelValue alloc] init];
                labelValue.label = value.label;
                labelValue.value = value.value;
                [emailArray addObject:labelValue];
                
            }
            group.emailAddresses = emailArray;
            
            NSMutableArray *addresses = [NSMutableArray array];
            for (CNLabeledValue *value in contact.postalAddresses) {
                QBPostalAddress *labelValue = [[QBPostalAddress alloc] init];
                labelValue.label = value.label;
                CNPostalAddress *add = value.value;
                
                labelValue.street = add.street;
                labelValue.city = add.city;
                labelValue.state = add.state;
                labelValue.postalCode = add.postalCode;
                labelValue.country = add.country;
                labelValue.ISOCountryCode = add.ISOCountryCode;

                [addresses addObject:labelValue];
            }
            
            group.addresses = addresses;
            group.company = contact.organizationName;
            [contacts addObject:(convertToDictionary ? group.dictionary : group)];
            
        }];
        
    }
    
    return contacts;
}

- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary *)response {

    if (connectionTag == CONNECTION_TAG_BACKUP) {
        self.showActivityIndicator = NO;

        //Backup
        [self handleSuccessForBackupWithResponse:response];
        
    } else if (connectionTag == CONNECTION_TAG_FETCH_BY_ID) {
        //Fetch By Id
        [self handleSuccessForFetchByIdWithResponse:response];
    } else if (connectionTag == CONNECTION_TAG_LOGOUT) {
        //Logout
        self.showActivityIndicator = NO;
        [[QBAppContext sharedInstance] userDidLogout];
        
        [self dismissCurrentPage];
        
    } else if (connectionTag == CONNECTION_TAG_UPDATE_ID) {
        self.showActivityIndicator = NO;
        //All contacts inserted successfully
        [self showOKAlertWithMessage:@"Contacts Restored successfully"];

    } else {
        self.showActivityIndicator = NO;

    }
    
}



- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString *)error {
    self.showActivityIndicator = NO;
    [self showOKAlertWithMessage:error];
}

- (void)handleSuccessForBackupWithResponse:(NSDictionary*)response {
    //Backup successful
    [self showOKAlertWithMessage:@"Data back up successful."];
}

- (void)handleSuccessForFetchByIdWithResponse:(NSDictionary*)response {
    NSArray *deviceContacts = [self fetchContactsFromDeviceToDictionary:NO];
    NSArray *responseContacts = response[@"contacts"];
    NSMutableArray *serverContacts = [NSMutableArray array];
    for (NSDictionary *dict in responseContacts) {
        QBContact *group = [[QBContact alloc] initWithDictionary:dict];
        [serverContacts addObject:group];
    }
    
    if (responseContacts.count == 0) {
        self.showActivityIndicator = NO;

        //No contacts in server
        [self showOKAlertWithMessage:@"No data available to restore."];
        
        
    } else if (deviceContacts.count == 0) {
        //No contacts in device - save all contacts from server in device
        [self initializeOperationQueue];
        [self saveContactsInDevice:serverContacts];
    } else {
        //Contacts available in server
        NSMutableArray<QBContact*> *nonMatchingContacts = [NSMutableArray array];
        NSMutableArray<QBContact*> *updatedContacts = [NSMutableArray array];

        for (QBContact *contactInServer in serverContacts) {
            NSError *error;
            CNContact *contact = [_addressbook unifiedContactWithIdentifier:contactInServer.contactId keysToFetch:_keysToFetch error:&error];
            
            if (contact) {
                //Contact found
                [contact setValue:contactInServer.firstName forKey:CNContactGivenNameKey];
                contactInServer.deviceContact = contact.mutableCopy;
                [contactInServer updateContactData:contactInServer.deviceContact];
                
                [updatedContacts addObject:contactInServer];
                
            } else {
                //No Contact found
                [nonMatchingContacts addObject:contactInServer];
            }
        }
        
        [self saveContactsInDevice:nonMatchingContacts];
        [self updateContactsInDevice:updatedContacts];
        
    }
}

- (void)initializeOperationQueue {
    if (!_operationQueue) {
        _operationQueue = [NSOperationQueue new];
        
    }
    [_operationQueue cancelAllOperations];
    _operationCount = 0;
}

- (void) saveContactsInDevice:(NSArray*)contacts {
    _insertedContactsArray = [NSMutableArray array];
    NSError *error;
    QBContact *faultyContact;
    for (QBContact *contact in contacts) {
        error = [self insertContactInDevice:contact];
        if (error) {
            faultyContact = contact;
            break;
        }
    }
    
    if (!error) {
        self.showActivityIndicator = NO;
        [self updateContactIdsInServerForContacts:_insertedContactsArray];
        
    } else if (faultyContact) {
        self.showActivityIndicator = NO;
        NSLog(@"Error while saving contact:\n%@\n%@", faultyContact.dictionary, error.localizedDescription);
        [self showOKAlertWithMessage:error.localizedDescription];
        
    } else {
        self.showActivityIndicator = NO;
        NSLog(@"Error while saving contact:\n%@", error.localizedDescription);
        [self showOKAlertWithMessage:error.localizedDescription];
    }
    
    
   
}

- (void)updateContactsInDevice:(NSArray*)contacts {
    NSError *error;
    QBContact *faultyContact;
    for (QBContact *contact in contacts) {
         error = [self updateContactInDevice:contact];
        if (error) {
            faultyContact = contact;
            break;
        }
    }
    
    if (!error) {
        self.showActivityIndicator = NO;
        //All contacts inserted successfully
        [self showOKAlertWithMessage:@"Contacts Restored successfully"];

    } else if (faultyContact) {
        self.showActivityIndicator = NO;
        NSLog(@"Error while saving contact:\n%@\n%@", faultyContact.dictionary, error.localizedDescription);
        [self showOKAlertWithMessage:error.localizedDescription];
        
    } else {
        self.showActivityIndicator = NO;
        NSLog(@"Error while saving contact:\n%@", error.localizedDescription);
        [self showOKAlertWithMessage:error.localizedDescription];
    }
    
}

- (NSError*)insertContactInDevice:(QBContact*)contact {
    
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact.mutableContact toContainerWithIdentifier:nil];
    NSError *error;
    [_addressbook executeSaveRequest:saveRequest error:&error];
    _operationCount --;
    
    if(!error) {
        [_insertedContactsArray addObject:@{@"contactId": contact.contactId, @"newContactId": contact.mutableContact.identifier}];
        contact.contactId = contact.mutableContact.identifier;

    }
    
    return error;

}

- (void)updateContactIdsInServerForContacts:(NSArray*)contacts {
    if (_insertedContactsArray.count > 0) {
        self.showActivityIndicator = YES;
        QBWebServiceHandler *connection = [[QBWebServiceHandler alloc] init];
        connection.delegate = self;
        connection.procedureName = @"updateContactIds";
        connection.connectionTag = CONNECTION_TAG_UPDATE_ID;
        connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token, @"contacts": contacts};
        [connection connect];
    } else {
        [self showOKAlertWithMessage:@"Contacts Restored successfully"];

    }
    
}

- (NSError*)updateContactInDevice:(QBContact*)contact {
    
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest updateContact:contact.deviceContact];
    NSError *error;
    [_addressbook executeSaveRequest:saveRequest error:&error];

    return error;
}

@end
