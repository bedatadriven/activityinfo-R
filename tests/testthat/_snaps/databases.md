# getDatabases() works

    Code
      databases
    Output
      # A tibble: 2 x 6
        billingAccountId databaseId description label              ownerId   suspended
      * <chr>            <chr>      <chr>       <chr>              <chr>     <lgl>    
      1 <id value>       <id value> <NA>        My first database  <id valu~ FALSE    
      2 <id value>       <id value> <NA>        My second database <id valu~ FALSE    

# getDatabaseResources() works

    Code
      dbResources
    Output
      # A tibble: 2 x 5
        id        label       parentId  type     visibility
      * <chr>     <chr>       <chr>     <chr>    <chr>     
      1 c10000004 Person form c10000002 FORM     PRIVATE   
      2 c10000005 Children    c10000004 SUB_FORM PRIVATE   

# addDatabaseUser() and deleteDatabaseUser() and getDatabaseUsers() and getDatabaseUser() and getDatabaseUser2() work and expected fields are present

    list(list(activationStatus = "PENDING", databaseId = "<id value>", 
        deliveryStatus = "UNKNOWN", email = "<id value>", inviteTime = "<date or time value>", 
        lastLoginTime = "<date or time value>", name = "Test database user", 
        userId = "<id value>"), list(activationStatus = "PENDING", 
        databaseId = "<id value>", deliveryStatus = "UNKNOWN", email = "<id value>", 
        inviteTime = "<date or time value>", lastLoginTime = "<date or time value>", 
        name = "Test database user", userId = "<id value>"))

---

    list(list(activationStatus = "PENDING", databaseId = "<id value>", 
        deliveryStatus = "UNKNOWN", email = "<id value>", inviteAccepted = FALSE, 
        inviteDate = "<date or time value>", lastLoginDate = "<date or time value>", 
        name = "Test database user", userId = "<id value>", userLicenseType = "BASIC"), 
        list(activationStatus = "PENDING", databaseId = "<id value>", 
            deliveryStatus = "UNKNOWN", email = "<id value>", inviteAccepted = FALSE, 
            inviteDate = "<date or time value>", lastLoginDate = "<date or time value>", 
            name = "Test database user", userId = "<id value>", userLicenseType = "BASIC"))

# permissions() helper works

    Code
      defaultPermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      
      attr(,"class")
      [1] "activityInfoPermissions" "list"                   

---

    Code
      reviewerPermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      [[2]]$securityCategories
      [[2]]$securityCategories[[1]]
      [1] "reviewer"
      
      
      
      [[3]]
      [[3]]$operation
      [1] "DISCOVER"
      
      
      attr(,"class")
      [1] "activityInfoPermissions" "list"                   

# parameter() works

    Code
      param
    Output
      $parameterId
      [1] "partner"
      
      $label
      [1] "Reporting partner"
      
      $range
      [1] "ck5dxt1712"
      
      attr(,"class")
      [1] "activityInfoParameter" "list"                 

# adminPermissions() works

    Code
      defaultAdminPermissions
    Output
      list()
      attr(,"class")
      [1] "activityInfoManagementPermissions" "list"                             

---

    Code
      enhancedAdminPermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "MANAGE_AUTOMATIONS"
      
      
      [[2]]
      [[2]]$operation
      [1] "MANAGE_USERS"
      
      
      [[3]]
      [[3]]$operation
      [1] "MANAGE_ROLES"
      
      
      attr(,"class")
      [1] "activityInfoManagementPermissions" "list"                             

# grant() works

    Code
      optionalGrant
    Output
      $resourceId
      [1] "ck5dxt1552"
      
      $operations
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      
      [[3]]
      [[3]]$operation
      [1] "EDIT_RECORD"
      
      
      attr(,"class")
      [1] "activityInfoPermissions" "list"                   
      
      $optional
      [1] TRUE
      
      attr(,"class")
      [1] "activityInfoGrant" "list"             

# roleFilter() works

    Code
      roleLevelFilter
    Output
      $id
      [1] "partner"
      
      $label
      [1] "Partner is user's partner"
      
      $filter
      [1] "ck5dxt1712 == @user.partner"
      
      attr(,"class")
      [1] "activityInfoRoleFilter" "list"                  

# role() works

    Code
      grantBasedRole
    Output
      $id
      [1] "rp"
      
      $label
      [1] "Reporting Partner"
      
      $parameters
      $parameters[[1]]
      $parameterId
      [1] "partner"
      
      $label
      [1] "Partner"
      
      $range
      [1] "ck5dxt1712"
      
      attr(,"class")
      [1] "activityInfoParameter" "list"                 
      
      
      $permissions
      list()
      attr(,"class")
      [1] "activityInfoManagementPermissions" "list"                             
      
      $grants
      $grants[[1]]
      $resourceId
      [1] "cq9xyz1552"
      
      $operations
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      [[1]]$filter
      [1] "ck5dxt1712 == @user.partner"
      
      
      [[2]]
      [[2]]$operation
      [1] "EDIT_RECORD"
      
      [[2]]$filter
      [1] "ck5dxt1712 == @user.partner"
      
      
      [[3]]
      [[3]]$operation
      [1] "EXPORT_RECORDS"
      
      
      [[4]]
      [[4]]$operation
      [1] "DISCOVER"
      
      
      attr(,"class")
      [1] "activityInfoPermissions" "list"                   
      
      $optional
      [1] FALSE
      
      attr(,"class")
      [1] "activityInfoGrant" "list"             
      
      $grants[[2]]
      $resourceId
      [1] "cz55555555"
      
      $operations
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      
      [[3]]
      [[3]]$operation
      [1] "DISCOVER"
      
      
      attr(,"class")
      [1] "activityInfoPermissions" "list"                   
      
      $optional
      [1] TRUE
      
      attr(,"class")
      [1] "activityInfoGrant" "list"             
      
      
      $filters
      $filters[[1]]
      $id
      [1] "partner"
      
      $label
      [1] "Partner is user's partner"
      
      $filter
      [1] "ck5dxt1712 == @user.partner"
      
      attr(,"class")
      [1] "activityInfoRoleFilter" "list"                  
      
      
      $grantBased
      [1] TRUE
      
      attr(,"class")
      [1] "activityInfoRole" "list"            

