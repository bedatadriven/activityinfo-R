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

