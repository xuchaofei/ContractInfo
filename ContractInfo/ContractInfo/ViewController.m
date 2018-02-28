//
//  ViewController.m
//  ContractInfo
//
//  Created by csm on 2017/12/7.
//  Copyright © 2017年 YiJu. All rights reserved.
//

#import "ViewController.h"
#import "ContractViewController.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "ContractViewController.h"


@interface ViewController (){
    
    NSMutableArray * _contactInfoArray;
    
}
@property (weak, nonatomic) IBOutlet UIButton *contractButton;


@end


@implementation ViewController
- (IBAction)chooseContractNumber:(id)sender {
    
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (systemVersion < 9.0) {
        [self chooseContractInfoPast];
    }else{
        [self chooseContractInfoFuture];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_contactInfoArray) {
        _contactInfoArray = [[NSMutableArray alloc] init];
    }

}



-(void)chooseContractInfoPast{
    
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        NSLog(@"没有授权");
        return;
    }
    
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
    long count = CFArrayGetCount(arrayRef);
    for (int i = 0; i < count; i++) {
        NSMutableDictionary * contactDetailDictionary = [[NSMutableDictionary alloc] init];;

        //获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);
        
        //获取当前联系人的名字
        NSString * firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        
        //获取当前联系人的姓氏
        NSString * lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        NSString * contactName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
        [contactDetailDictionary setObject:contactName forKey:@"contactName"];
        
        
        NSMutableArray * phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        
        for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            
            NSLog(@"phone=%@",phone);
            [phoneArray addObject:phone];
        }
        if (phoneArray.count > 0) {
            [contactDetailDictionary setObject:phoneArray forKey:@"contactPhone"];
        }
        
        NSString * noteStr = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonNoteProperty));
        [contactDetailDictionary setObject:noteStr forKey:@"contactNote"];
        
        [_contactInfoArray addObject:contactDetailDictionary];

    }
    NSLog(@"-------%@",_contactInfoArray);

    ContractViewController * contractVC = [[ContractViewController alloc] init];
    contractVC.contractInfoArray = _contactInfoArray;
    [self presentViewController:contractVC animated:YES completion:nil];
}

-(void)chooseContractInfoFuture{
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        NSLog(@"没有授权");
    }
    
    NSArray * keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactNoteKey];
    
    CNContactFetchRequest * fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    CNContactStore * contractStore = [[CNContactStore alloc] init];
    [contractStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        NSMutableDictionary * contactDetailDictionary = [[NSMutableDictionary alloc] init];
        NSString * givenName = contact.givenName;
        NSString * familyName = contact.familyName;

        NSString * contactName = [NSString stringWithFormat:@"%@%@",familyName,givenName];
        [contactDetailDictionary setObject:contactName forKey:@"contactName"];

        NSMutableArray * phoneArray = [[NSMutableArray alloc] init];
        NSArray * phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue * labelValue in phoneNumbers) {

            CNPhoneNumber * phoneNumber = labelValue.value;
            [phoneArray addObject:phoneNumber.stringValue];

        }
        [contactDetailDictionary setObject:phoneArray forKey:@"contactPhone"];
        
        NSString * noteStr = contact.note;
        [contactDetailDictionary setObject:noteStr forKey:@"contactNote"];
        [_contactInfoArray addObject:contactDetailDictionary];

    }];
    
    NSLog(@"---------%@",_contactInfoArray);
    ContractViewController * contractVC = [[ContractViewController alloc] init];
    contractVC.contractInfoArray = _contactInfoArray;
    [self presentViewController:contractVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
