/*
    Copyright (c) 2011, Salesforce.com Foundation
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this List of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this List of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Salesforce.com Foundation nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.com Foundation
* @date 2011 (1.x)
* @description Provides automated generation of unit test data for tests throughout the org 
*/

public class UTIL_UnitTestData_TEST { 

// create data for use in unit tests
// should not be referenced by production code
    public static string closedWonStage;
    public static string closedLostStage;
    public static string openStage;
    
    public static String getClosedWonStage(){
        if (closedWonStage == null){
            List<OpportunityStage> closedWonStages = [select masterlabel from opportunitystage where isActive = true and iswon = true];
            
            if(closedWonStages.size()>0){
                closedWonStage = closedWonStages[0].masterlabel;
            } else {
                closedWonStage = '';
            }
        }
        
        return closedWonStage;
    }
    /*
    public static String getClosedLostStage(){
        if (closedLostStage == null){
            List<OpportunityStage> closedLostStages = [select masterlabel from opportunitystage where isActive = true and iswon = false and isClosed = true];
            
            if(closedLostStages.size()>0){
                closedLostStage = closedLostStages[0].masterlabel;
            } else {
                closedLostStage = '';
            }
        }
        
        return closedLostStage;
    }
    */
    public static String getOpenStage(){
        if (openStage == null){
            List<OpportunityStage> openStages = [select masterlabel from opportunitystage where isActive = true and iswon = false];
            
            if(openStages.size()>0){
                openStage = openStages[0].masterlabel;
            } else {
                openStage = '';
            }
        }
        
        return openStage;
    }
    
    public static Contact getContact() {
    	return new Contact (
                FirstName = CAO_Constants.CONTACT_FIRSTNAME_FOR_TESTS,
                LastName = CAO_Constants.CONTACT_LASTNAME_FOR_TESTS,
                npe01__Private__c = false,
                npe01__WorkEmail__c = CAO_Constants.CONTACT_EMAIL_FOR_TESTS, 
                npe01__Preferred_Email__c = CAO_Constants.CONTACT_PREFERRED_EMAIL_FOR_TESTS,
                npe01__WorkPhone__c = CAO_Constants.CONTACT_PHONE_FOR_TESTS,
                npe01__PreferredPhone__c = CAO_Constants.CONTACT_PREFERRED_PHONE_FOR_TESTS,
                OtherCity = 'Seattle'
            );
    }
    
    public static List<Contact> CreateMultipleTestContacts (integer n) {
        
        List<contact> ContactsToAdd = New List<contact> ();
        
        for (integer i=0;i<n;i++) {
            Contact newCon = New Contact (
                FirstName= CAO_Constants.CONTACT_FIRSTNAME_FOR_TESTS + i,
                LastName= CAO_Constants.CONTACT_LASTNAME_FOR_TESTS,
                npe01__Private__c=false,
                npe01__WorkEmail__c = CAO_Constants.CONTACT_EMAIL_FOR_TESTS, 
                npe01__Preferred_Email__c = CAO_Constants.CONTACT_PREFERRED_EMAIL_FOR_TESTS,
                npe01__WorkPhone__c = CAO_Constants.CONTACT_PHONE_FOR_TESTS,
                npe01__PreferredPhone__c = CAO_Constants.CONTACT_PREFERRED_PHONE_FOR_TESTS,
                OtherCity = 'Seattle'
            );
            ContactsToAdd.add (newCon);
        }
        
        // testing doing the insert in the calling code - will maybe reinstate this
        //insert ContactsToAdd;
        
        return ContactsToAdd;
    }
    /*
    public static List<Contact> CreateMultipleTestContactsInHouseholds (List<Contact> firstContactList) {
        
        List<contact> ContactsToAdd = New List<contact> ();
        
        for (integer i=0;i<firstContactList.size();i++) {
            Contact newCon = New Contact (
                FirstName= CAO_Constants.CONTACT_FIRSTNAME_FOR_TESTS + i,
                LastName= CAO_Constants.CONTACT_LASTNAME_FOR_TESTS,
                npe01__Private__c=false,
                npe01__WorkEmail__c = CAO_Constants.CONTACT_EMAIL_FOR_TESTS, 
                npe01__Preferred_Email__c = CAO_Constants.CONTACT_PREFERRED_EMAIL_FOR_TESTS,
                npe01__WorkPhone__c = CAO_Constants.CONTACT_PHONE_FOR_TESTS,
                npe01__PreferredPhone__c = CAO_Constants.CONTACT_PREFERRED_PHONE_FOR_TESTS,
                OtherCity = 'Seattle',
                Household__c = firstContactList[i].Household__c
            );
            ContactsToAdd.add (newCon);
        }
        
        // testing doing the insert in the calling code - will maybe reinstate this
        //insert ContactsToAdd;
        
        return ContactsToAdd;
    }
    */

    public static List<Opportunity> OppsForContactList (List<Contact> Cons, id CampId, string Stage, date Close, double Amt, string rectype, string oppType) {
     
        // given a List of Contacts,
        // add one Opp per contact w/ the specified data
        // TBD should allow specifying rectype (optional)
    
        List<Opportunity> OppsToAdd = new List<Opportunity> ();
        id rtid = UTIL_RecordTypes.GetRecordTypeId ('Opportunity',rectype);
        UTIL_Debug.debug('recordtypeintest: ' + rtid);

        for ( Contact thisCon : Cons ) {
            Opportunity newOpp = New Opportunity (
                Name = 'Test Opp ' + thisCon.FirstName + thisCon.LastName,
                Amount = Amt,
                CloseDate = Close,
                StageName = Stage,
                CampaignId = CampId,
                npe01__Contact_Id_for_Role__c = thisCon.Id,
                type = oppType
            );
            if(rtid != null){
                newOpp.put('RecordTypeId',rtid);
            }
            oppsToAdd.add (newOpp);
        }
        return oppsToAdd;
    }
    
    public static List<Opportunity> OppsForAccountList (List<Account> listAcc, id CampId, string Stage, date Close, double Amt, string rectype, string oppType) {
     
        // given a List of Accounts,
        // add one Opp per Account w/ the specified data
    
        List<Opportunity> OppsToAdd = new List<Opportunity> ();
        id rtid = UTIL_RecordTypes.GetRecordTypeId ('Opportunity',rectype);
        UTIL_Debug.debug('recordtypeintest: ' + rtid);

        for (Account acc : listAcc) {
            Opportunity newOpp = New Opportunity (
                Name = 'Test Opp ' + acc.Name,
                AccountId = acc.Id,
                Amount = Amt,
                CloseDate = Close,
                StageName = Stage,
                CampaignId = CampId,
                type = oppType
            );
            if (rtid != null){
                newOpp.put('RecordTypeId',rtid);
            }
            oppsToAdd.add (newOpp);
        }
        return oppsToAdd;
    }

    public static List<Account> CreateMultipleTestAccounts (integer n, string strType) {
        
        List<Account> AcctsToAdd = New List<Account> ();
        
        for (integer i=0;i<n;i++) {
            Account newAcct = New Account (
                Name = 'Yet Another Org ' + i,
                npe01__SYSTEM_AccountType__c = strType
            );
            if (strType != null) {
            	newAcct.npe01__SYSTEMIsIndividual__c = true;
            	if (strType == CAO_Constants.BUCKET_ORGANIZATION_TYPE)
            	   newAcct.name = CAO_Constants.BUCKET_ACCOUNT_NAME;
            }
            AcctsToAdd.add (newAcct);
        }
        
        return AcctsToAdd;
    }

    public static User CreateNewUserForTests(string strUsername) {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        User u;	
        // to work around mixed DML errors during tests, you must
        // create user account in its own transaction.  got this
        // hack from the web.
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {        
	        u = new User(alias = 'jsmith', email='jsmith@acme.com', 
	            emailencodingkey='UTF-8', lastname='Smith', 
	            languagelocalekey='en_US', 
	            localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
	            timezonesidkey='America/Los_Angeles', 
	            username=strUsername);
	        insert u;
        }
        return u;
    }
    
    
/*
        public static List<Opportunity> OppsForAccountList (List<Account> Accts, id CampId, string Stage, date Close, double Amt, string rectype) {
    
        // given a List of accounts,
        // add one Opp per acct w/ the specified data
    
        List<Opportunity> OppsToAdd = new List<Opportunity> ();
        
        // look up the id for the specified rectype
        id rtid = UTIL_RecordTypes.GetRecordTypeId ('Opportunity',rectype);
        
        for ( Account thisAcct : Accts) {
            Opportunity newOpp = New Opportunity (
                AccountId = thisAcct.id,
                Name = 'Test Opp ' + thisAcct.Name,
                Amount = Amt,
                CloseDate = Close,
                StageName = Stage,
                CampaignId = CampId,
                RecordTypeId = rtid
            );  
            OppsToAdd.add (newOpp);
        }
        
        return OppsToAdd;
        
    }
    */
    
    
  /*  
    public Static CampaignMember CreateCampaignMember (id CampId, id ConId, string CMStatus) {
    
        CampaignMember newCM = new CampaignMember (
            CampaignId = CampId,
            ContactId = ConId,
            Status = CMStatus
        );
        
        insert newCM;
        return newCm;           
    }
*/
}