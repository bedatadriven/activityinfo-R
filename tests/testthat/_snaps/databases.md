# getDatabases() works

    Code
      databasesDf
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

# resourcePermissions() and synonym permissions() helper works

    Code
      defaultPermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      [[1]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoResourcePermissions" "list"                           

---

    Code
      reviewerPermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      [[1]]$securityCategories
      list()
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      [[2]]$securityCategories
      [[2]]$securityCategories[[1]]
      [1] "reviewer"
      
      
      
      [[3]]
      [[3]]$operation
      [1] "DISCOVER"
      
      [[3]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoResourcePermissions" "list"                           

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

# databasePermissions() works

    Code
      defaultDatabasePermissions
    Output
      list()
      attr(,"class")
      [1] "activityInfoDatabasePermissions" "list"                           

---

    Code
      enhancedDatabasePermissions
    Output
      [[1]]
      [[1]]$operation
      [1] "MANAGE_AUTOMATIONS"
      
      [[1]]$securityCategories
      list()
      
      
      [[2]]
      [[2]]$operation
      [1] "MANAGE_USERS"
      
      [[2]]$securityCategories
      list()
      
      
      [[3]]
      [[3]]$operation
      [1] "MANAGE_ROLES"
      
      [[3]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoDatabasePermissions" "list"                           

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
      
      [[1]]$securityCategories
      list()
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      [[2]]$securityCategories
      list()
      
      
      [[3]]
      [[3]]$operation
      [1] "EDIT_RECORD"
      
      [[3]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoResourcePermissions" "list"                           
      
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
      [1] "activityInfoDatabasePermissions" "list"                           
      
      $grants
      $grants[[1]]
      $resourceId
      [1] "cq9xyz1552"
      
      $operations
      [[1]]
      [[1]]$operation
      [1] "VIEW"
      
      [[1]]$securityCategories
      list()
      
      [[1]]$filter
      [1] "ck5dxt1712 == @user.partner"
      
      
      [[2]]
      [[2]]$operation
      [1] "EDIT_RECORD"
      
      [[2]]$securityCategories
      list()
      
      [[2]]$filter
      [1] "ck5dxt1712 == @user.partner"
      
      
      [[3]]
      [[3]]$operation
      [1] "EXPORT_RECORDS"
      
      [[3]]$securityCategories
      list()
      
      
      [[4]]
      [[4]]$operation
      [1] "DISCOVER"
      
      [[4]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoResourcePermissions" "list"                           
      
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
      
      [[1]]$securityCategories
      list()
      
      
      [[2]]
      [[2]]$operation
      [1] "ADD_RECORD"
      
      [[2]]$securityCategories
      list()
      
      
      [[3]]
      [[3]]$operation
      [1] "DISCOVER"
      
      [[3]]$securityCategories
      list()
      
      
      attr(,"class")
      [1] "activityInfoResourcePermissions" "list"                           
      
      $optional
      [1] TRUE
      
      attr(,"class")
      [1] "activityInfoGrant" "list"             
      
      
      $grantBased
      [1] TRUE
      
      attr(,"class")
      [1] "activityInfoRole" "list"            

# roleAssignment() works

    Code
      roleAssignment(roleId = "rp", roleParameters = list(partner = "test:test"),
      roleResources = list("resource1", "resource2", "resource3"))
    Output
      $id
      [1] "rp"
      
      $parameters
      $parameters$partner
      [1] "test:test"
      
      
      $resources
      $resources[[1]]
      [1] "resource1"
      
      $resources[[2]]
      [1] "resource2"
      
      $resources[[3]]
      [1] "resource3"
      
      
      attr(,"class")
      [1] "activityInfoRoleAssignment" "list"                      

