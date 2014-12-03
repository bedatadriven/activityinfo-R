

test.indicatorValues <- function() {
  
  df <- getIndicatorValueTable(1843)

  # Check Adrar
  checkIdentical(subset(df, locationName == 'Adrar' & month == '2015-01')$value, 3000)
  checkIdentical(subset(df, locationName == 'Adrar' & month == '2015-02')$value, 10)
  checkIdentical(subset(df, locationName == 'Adrar' & month == '2015-02')$partnerName, "NRC")
  checkIdentical(subset(df, locationName == 'Adrar' & month == '2015-02')$partnerName, "NRC")
  
  # Check the point
  meridja <- subset(df, locationName == 'Meridja')
  checkTrue( all( meridja$partnerName == "NRC") )
  checkTrue( all( meridja$comments == "OncePoint comments") )
  checkIdentical( subset(meridja, indicatorName == 'OP1')$value, 500)
  checkIdentical( subset(meridja, indicatorName == 'OP2')$value, 25)
  checkIdentical( subset(meridja, indicatorName == 'OP2')$units, "%")
  checkIdentical( subset(meridja, indicatorName == 'OP3')$value, 125)
  
  # Check the category name appears
  checkTrue( all(subset(df, activityName == 'MonthlyFormPoint')$activityCategory == "CategoryPoint"))
  
}