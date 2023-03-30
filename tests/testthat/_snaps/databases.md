# getDatabases() works

    Code
      databases
    Output
      # A tibble: 2 x 6
        billingAccountId databaseId description label              ownerId    suspen~1
      * <chr>            <chr>      <chr>       <chr>              <chr>      <lgl>   
      1 <id value>       <id value> <NA>        My first database  <id value> FALSE   
      2 <id value>       <id value> <NA>        My second database <id value> FALSE   
      # ... with abbreviated variable name 1: suspended

# getDatabaseTree() works

    structure(list(billingAccountId = "<id value>", continuousTranslation = FALSE, 
        databaseId = "<id value>", description = "", grants = list(), 
        label = "My first database", language = "", languages = list(), 
        locks = list(), originalLanguage = "", ownerRef = list(email = "<id value>", 
            id = "<id value>", name = "Bob"), publishedTemplate = FALSE, 
        resources = list("Empty resources until we can ensure a sort order in the API."), 
        role = list(id = "<id value>", parameters = list(), resources = list()), 
        roles = list(list(filters = list(), grantBased = FALSE, grants = list(), 
            id = "<id value>", label = "Data Entry", parameters = list(), 
            permissions = list(list(filter = NULL, operation = "VIEW", 
                securityCategories = list()), list(filter = NULL, 
                operation = "EDIT_RECORD", securityCategories = list()), 
                list(filter = NULL, operation = "ADD_RECORD", securityCategories = list()), 
                list(filter = NULL, operation = "DELETE_RECORD", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "EXPORT_RECORDS", securityCategories = list())), 
            version = 0), list(filters = list(), grantBased = FALSE, 
            grants = list(), id = "<id value>", label = "Read only", 
            parameters = list(), permissions = list(list(filter = NULL, 
                operation = "VIEW", securityCategories = list())), 
            version = 0), list(filters = list(), grantBased = FALSE, 
            grants = list(), id = "<id value>", label = "Administrator", 
            parameters = list(), permissions = list(list(filter = NULL, 
                operation = "VIEW", securityCategories = list()), 
                list(filter = NULL, operation = "ADD_RECORD", securityCategories = list()), 
                list(filter = NULL, operation = "EDIT_RECORD", securityCategories = "reviewer"), 
                list(filter = NULL, operation = "MANAGE_REFERENCE_DATA", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "DELETE_RECORD", securityCategories = list()), 
                list(filter = NULL, operation = "BULK_DELETE", securityCategories = list()), 
                list(filter = NULL, operation = "EXPORT_RECORDS", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "MANAGE_USERS", securityCategories = list()), 
                list(filter = NULL, operation = "LOCK_RECORDS", securityCategories = list()), 
                list(filter = NULL, operation = "ADD_RESOURCE", securityCategories = list()), 
                list(filter = NULL, operation = "EDIT_RESOURCE", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "DELETE_RESOURCE", securityCategories = list()), 
                list(filter = NULL, operation = "MANAGE_COLLECTION_LINKS", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "AUDIT", securityCategories = list()), 
                list(filter = NULL, operation = "SHARE_REPORTS", 
                    securityCategories = list()), list(filter = NULL, 
                    operation = "PUBLISH_REPORTS", securityCategories = list()), 
                list(filter = NULL, operation = "MANAGE_ROLES", securityCategories = list()), 
                list(filter = NULL, operation = "MANAGE_TRANSLATIONS", 
                    securityCategories = list())), version = 0)), 
        securityCategories = list(list(id = "<id value>", label = "Reviewer only")), 
        storage = "", suspended = FALSE, thirdPartyTranslation = FALSE, 
        translationFromDbMemory = FALSE, userId = "<id value>", version = "3"), class = "databaseTree")

# getDatabaseResources() works

    Code
      dbResources
    Output
      # A tibble: 2 x 5
        id        label       parentId  type     visibility
      * <chr>     <chr>       <chr>     <chr>    <chr>     
      1 c10000005 Person form c10000003 FORM     PRIVATE   
      2 c10000006 Children    c10000005 SUB_FORM PRIVATE   

# addDatabaseUser() and deleteDatabaseUser() and getDatabaseUsers() and getDatabaseUser() and getDatabaseUser2() work

    list(list(added = TRUE, user = list(activationStatus = "PENDING", 
        databaseId = "<id value>", deliveryStatus = "UNKNOWN", email = "<id value>", 
        grants = list(), inviteTime = "<date or time value>", lastLoginTime = "<date or time value>", 
        name = "Test database user", role = list(id = "<id value>", 
            parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        userId = "<id value>", version = 1)), list(added = TRUE, 
        user = list(activationStatus = "PENDING", databaseId = "<id value>", 
            deliveryStatus = "UNKNOWN", email = "<id value>", grants = list(), 
            inviteTime = "<date or time value>", lastLoginTime = "<date or time value>", 
            name = "Test database user", role = list(id = "<id value>", 
                parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
            userId = "<id value>", version = 1)))

---

    list(list(databaseId = "<id value>", deliveryStatus = "UNKNOWN", 
        email = "<id value>", inviteAccepted = FALSE, inviteDate = "<date or time value>", 
        name = "Test database user", role = list(id = "<id value>", 
            parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        userId = "<id value>", version = 1), list(databaseId = "<id value>", 
        deliveryStatus = "UNKNOWN", email = "<id value>", inviteAccepted = FALSE, 
        inviteDate = "<date or time value>", name = "Test database user", 
        role = list(id = "<id value>", parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        userId = "<id value>", version = 1))

