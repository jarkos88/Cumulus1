/*
    Copyright (c) 2013, Salesforce.com Foundation
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
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
public with sharing class TDTM_TriggerActionHelper {
    
    public static TDTM_Runnable.Action determineTriggerAction(Boolean isBefore, Boolean isAfter, Boolean isInsert,
    Boolean isUpdate, Boolean isDelete, Boolean isUnDelete) {
        if (isBefore) {
            if (isInsert) return TDTM_Runnable.Action.BeforeInsert;
            else if (isUpdate) return TDTM_Runnable.Action.BeforeUpdate;
            else return TDTM_Runnable.Action.BeforeDelete;
        } else {
            if (isInsert) return TDTM_Runnable.Action.AfterInsert;
            else if (isUpdate) return TDTM_Runnable.Action.AfterUpdate;
            else if (isDelete) return TDTM_Runnable.Action.AfterDelete;
            else return TDTM_Runnable.Action.AfterUndelete;
        }
    }
    
    public static TDTM_Runnable.Action getTriggerActionFromName(String name) {
        TDTM_Runnable.Action ta;
    
        if (name == TDTM_Runnable.Action.BeforeInsert.name())
           ta = TDTM_Runnable.Action.BeforeInsert;
        else if(name == TDTM_Runnable.Action.BeforeUpdate.name())
           ta = TDTM_Runnable.Action.BeforeUpdate;
        else if(name == TDTM_Runnable.Action.BeforeDelete.name())
           ta = TDTM_Runnable.Action.BeforeDelete;
        else if(name == TDTM_Runnable.Action.AfterInsert.name())
           ta = TDTM_Runnable.Action.AfterInsert;
        else if(name == TDTM_Runnable.Action.AfterUpdate.name())
           ta = TDTM_Runnable.Action.AfterUpdate;
        else if(name == TDTM_Runnable.Action.AfterDelete.name())
           ta = TDTM_Runnable.Action.AfterDelete;
        else if(name == TDTM_Runnable.Action.AfterUndelete.name())
           ta = TDTM_Runnable.Action.AfterUndelete;
        return ta;
    }
    
    //@TODO: this method should be moved into a general utilities class
    public static Schema.DescribeSObjectResult getDescribeObjectByName(String objectName) {
    	Schema.DescribeSObjectResult objResult;
        for(Schema.SObjectType t : Schema.getGlobalDescribe().values()){
            if (t.getDescribe().getName() == objectName){
                objResult = t.getDescribe();
                break;
            }
        }
        return objResult;
    }
}