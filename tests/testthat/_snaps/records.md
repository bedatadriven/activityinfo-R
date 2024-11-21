# In extractSchemaFromFields(), form with has duplicate labels can be fixed with useColumnNames = TRUE

    Code
      caseDf
    Output
         Case number A single select column District (from form) Name
      1            1                1_stuff               District 10
      2            2                2_stuff                District 7
      3            3                3_stuff                District 6
      4            4                4_stuff                District 3
      5            5                5_stuff                District 9
      6            6                1_stuff               District 10
      7            7                2_stuff                District 7
      8            8                3_stuff                District 6
      9            9                4_stuff                District 6
      10          10                5_stuff                District 4
         Country (from Form) Name
      1                 Country 1
      2                 Country 2
      3                 Country 1
      4                 Country 2
      5                 Country 2
      6                 Country 1
      7                 Country 2
      8                 Country 1
      9                 Country 1
      10                Country 2

# Can retrieve child form with all reference records using getRecords().

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

---

    Code
      rcrdsMinDf
    Output
          Identifier number A single select column A logical column A date column
      1                   1                1_stuff             True    2021-07-06
      2                   2                2_stuff             True    2021-07-07
      3                   3                3_stuff            False    2021-07-08
      4                   4                4_stuff            False    2021-07-09
      5                   5                5_stuff            False    2021-07-10
      6                   6                1_stuff            False    2021-07-11
      7                   7                2_stuff            False    2021-07-12
      8                   8                3_stuff            False    2021-07-13
      9                   9                4_stuff            False    2021-07-14
      10                 10                5_stuff            False    2021-07-15
      11                 11                1_stuff            False    2021-07-16
      12                 12                2_stuff            False    2021-07-17
      13                 13                3_stuff            False    2021-07-18
      14                 14                4_stuff            False    2021-07-19
      15                 15                5_stuff            False    2021-07-20
      16                 16                1_stuff            False    2021-07-21
      17                 17                2_stuff            False    2021-07-22
      18                 18                3_stuff            False    2021-07-23
      19                 19                4_stuff            False    2021-07-24
      20                 20                5_stuff            False    2021-07-25
      21                 21                1_stuff             True    2021-07-06
      22                 22                2_stuff             True    2021-07-07
      23                 23                3_stuff             True    2021-07-08
      24                 24                4_stuff            False    2021-07-09
      25                 25                5_stuff            False    2021-07-10
      26                 26                1_stuff            False    2021-07-11
      27                 27                2_stuff            False    2021-07-12
      28                 28                3_stuff            False    2021-07-13
      29                 29                4_stuff            False    2021-07-14
      30                 30                5_stuff            False    2021-07-15
      31                 31                1_stuff            False    2021-07-16
      32                 32                2_stuff            False    2021-07-17
      33                 33                3_stuff            False    2021-07-18
      34                 34                4_stuff            False    2021-07-19
      35                 35                5_stuff            False    2021-07-20
      36                 36                1_stuff            False    2021-07-21
      37                 37                2_stuff            False    2021-07-22
      38                 38                3_stuff            False    2021-07-23
      39                 39                4_stuff            False    2021-07-24
      40                 40                5_stuff            False    2021-07-25
      41                 41                1_stuff            False    2021-07-06
      42                 42                2_stuff             True    2021-07-07
      43                 43                3_stuff             True    2021-07-08
      44                 44                4_stuff             True    2021-07-09
      45                 45                5_stuff            False    2021-07-10
      46                 46                1_stuff            False    2021-07-11
      47                 47                2_stuff            False    2021-07-12
      48                 48                3_stuff            False    2021-07-13
      49                 49                4_stuff            False    2021-07-14
      50                 50                5_stuff            False    2021-07-15
      51                 51                1_stuff            False    2021-07-16
      52                 52                2_stuff            False    2021-07-17
      53                 53                3_stuff            False    2021-07-18
      54                 54                4_stuff            False    2021-07-19
      55                 55                5_stuff            False    2021-07-20
      56                 56                1_stuff            False    2021-07-21
      57                 57                2_stuff            False    2021-07-22
      58                 58                3_stuff            False    2021-07-23
      59                 59                4_stuff            False    2021-07-24
      60                 60                5_stuff            False    2021-07-25
      61                 61                1_stuff            False    2021-07-06
      62                 62                2_stuff            False    2021-07-07
      63                 63                3_stuff             True    2021-07-08
      64                 64                4_stuff             True    2021-07-09
      65                 65                5_stuff             True    2021-07-10
      66                 66                1_stuff            False    2021-07-11
      67                 67                2_stuff            False    2021-07-12
      68                 68                3_stuff            False    2021-07-13
      69                 69                4_stuff            False    2021-07-14
      70                 70                5_stuff            False    2021-07-15
      71                 71                1_stuff            False    2021-07-16
      72                 72                2_stuff            False    2021-07-17
      73                 73                3_stuff            False    2021-07-18
      74                 74                4_stuff            False    2021-07-19
      75                 75                5_stuff            False    2021-07-20
      76                 76                1_stuff            False    2021-07-21
      77                 77                2_stuff            False    2021-07-22
      78                 78                3_stuff            False    2021-07-23
      79                 79                4_stuff            False    2021-07-24
      80                 80                5_stuff            False    2021-07-25
      81                 81                1_stuff            False    2021-07-06
      82                 82                2_stuff            False    2021-07-07
      83                 83                3_stuff            False    2021-07-08
      84                 84                4_stuff             True    2021-07-09
      85                 85                5_stuff             True    2021-07-10
      86                 86                1_stuff             True    2021-07-11
      87                 87                2_stuff            False    2021-07-12
      88                 88                3_stuff            False    2021-07-13
      89                 89                4_stuff            False    2021-07-14
      90                 90                5_stuff            False    2021-07-15
      91                 91                1_stuff            False    2021-07-16
      92                 92                2_stuff            False    2021-07-17
      93                 93                3_stuff            False    2021-07-18
      94                 94                4_stuff            False    2021-07-19
      95                 95                5_stuff            False    2021-07-20
      96                 96                1_stuff            False    2021-07-21
      97                 97                2_stuff            False    2021-07-22
      98                 98                3_stuff            False    2021-07-23
      99                 99                4_stuff            False    2021-07-24
      100               100                5_stuff            False    2021-07-25
      101               101                1_stuff            False    2021-07-06
      102               102                2_stuff            False    2021-07-07
      103               103                3_stuff            False    2021-07-08
      104               104                4_stuff            False    2021-07-09
      105               105                5_stuff             True    2021-07-10
      106               106                1_stuff             True    2021-07-11
      107               107                2_stuff             True    2021-07-12
      108               108                3_stuff            False    2021-07-13
      109               109                4_stuff            False    2021-07-14
      110               110                5_stuff            False    2021-07-15
      111               111                1_stuff            False    2021-07-16
      112               112                2_stuff            False    2021-07-17
      113               113                3_stuff            False    2021-07-18
      114               114                4_stuff            False    2021-07-19
      115               115                5_stuff            False    2021-07-20
      116               116                1_stuff            False    2021-07-21
      117               117                2_stuff            False    2021-07-22
      118               118                3_stuff            False    2021-07-23
      119               119                4_stuff            False    2021-07-24
      120               120                5_stuff            False    2021-07-25
      121               121                1_stuff            False    2021-07-06
      122               122                2_stuff            False    2021-07-07
      123               123                3_stuff            False    2021-07-08
      124               124                4_stuff            False    2021-07-09
      125               125                5_stuff            False    2021-07-10
      126               126                1_stuff             True    2021-07-11
      127               127                2_stuff             True    2021-07-12
      128               128                3_stuff             True    2021-07-13
      129               129                4_stuff            False    2021-07-14
      130               130                5_stuff            False    2021-07-15
      131               131                1_stuff            False    2021-07-16
      132               132                2_stuff            False    2021-07-17
      133               133                3_stuff            False    2021-07-18
      134               134                4_stuff            False    2021-07-19
      135               135                5_stuff            False    2021-07-20
      136               136                1_stuff            False    2021-07-21
      137               137                2_stuff            False    2021-07-22
      138               138                3_stuff            False    2021-07-23
      139               139                4_stuff            False    2021-07-24
      140               140                5_stuff            False    2021-07-25
      141               141                1_stuff            False    2021-07-06
      142               142                2_stuff            False    2021-07-07
      143               143                3_stuff            False    2021-07-08
      144               144                4_stuff            False    2021-07-09
      145               145                5_stuff            False    2021-07-10
      146               146                1_stuff            False    2021-07-11
      147               147                2_stuff             True    2021-07-12
      148               148                3_stuff             True    2021-07-13
      149               149                4_stuff             True    2021-07-14
      150               150                5_stuff            False    2021-07-15
      151               151                1_stuff            False    2021-07-16
      152               152                2_stuff            False    2021-07-17
      153               153                3_stuff            False    2021-07-18
      154               154                4_stuff            False    2021-07-19
      155               155                5_stuff            False    2021-07-20
      156               156                1_stuff            False    2021-07-21
      157               157                2_stuff            False    2021-07-22
      158               158                3_stuff            False    2021-07-23
      159               159                4_stuff            False    2021-07-24
      160               160                5_stuff            False    2021-07-25
      161               161                1_stuff            False    2021-07-06
      162               162                2_stuff            False    2021-07-07
      163               163                3_stuff            False    2021-07-08
      164               164                4_stuff            False    2021-07-09
      165               165                5_stuff            False    2021-07-10
      166               166                1_stuff            False    2021-07-11
      167               167                2_stuff            False    2021-07-12
      168               168                3_stuff             True    2021-07-13
      169               169                4_stuff             True    2021-07-14
      170               170                5_stuff             True    2021-07-15
      171               171                1_stuff            False    2021-07-16
      172               172                2_stuff            False    2021-07-17
      173               173                3_stuff            False    2021-07-18
      174               174                4_stuff            False    2021-07-19
      175               175                5_stuff            False    2021-07-20
      176               176                1_stuff            False    2021-07-21
      177               177                2_stuff            False    2021-07-22
      178               178                3_stuff            False    2021-07-23
      179               179                4_stuff            False    2021-07-24
      180               180                5_stuff            False    2021-07-25
      181               181                1_stuff            False    2021-07-06
      182               182                2_stuff            False    2021-07-07
      183               183                3_stuff            False    2021-07-08
      184               184                4_stuff            False    2021-07-09
      185               185                5_stuff            False    2021-07-10
      186               186                1_stuff            False    2021-07-11
      187               187                2_stuff            False    2021-07-12
      188               188                3_stuff            False    2021-07-13
      189               189                4_stuff             True    2021-07-14
      190               190                5_stuff             True    2021-07-15
      191               191                1_stuff             True    2021-07-16
      192               192                2_stuff            False    2021-07-17
      193               193                3_stuff            False    2021-07-18
      194               194                4_stuff            False    2021-07-19
      195               195                5_stuff            False    2021-07-20
      196               196                1_stuff            False    2021-07-21
      197               197                2_stuff            False    2021-07-22
      198               198                3_stuff            False    2021-07-23
      199               199                4_stuff            False    2021-07-24
      200               200                5_stuff            False    2021-07-25
      201               201                1_stuff            False    2021-07-06
      202               202                2_stuff            False    2021-07-07
      203               203                3_stuff            False    2021-07-08
      204               204                4_stuff            False    2021-07-09
      205               205                5_stuff            False    2021-07-10
      206               206                1_stuff            False    2021-07-11
      207               207                2_stuff            False    2021-07-12
      208               208                3_stuff            False    2021-07-13
      209               209                4_stuff            False    2021-07-14
      210               210                5_stuff             True    2021-07-15
      211               211                1_stuff             True    2021-07-16
      212               212                2_stuff             True    2021-07-17
      213               213                3_stuff            False    2021-07-18
      214               214                4_stuff            False    2021-07-19
      215               215                5_stuff            False    2021-07-20
      216               216                1_stuff            False    2021-07-21
      217               217                2_stuff            False    2021-07-22
      218               218                3_stuff            False    2021-07-23
      219               219                4_stuff            False    2021-07-24
      220               220                5_stuff            False    2021-07-25
      221               221                1_stuff            False    2021-07-06
      222               222                2_stuff            False    2021-07-07
      223               223                3_stuff            False    2021-07-08
      224               224                4_stuff            False    2021-07-09
      225               225                5_stuff            False    2021-07-10
      226               226                1_stuff            False    2021-07-11
      227               227                2_stuff            False    2021-07-12
      228               228                3_stuff            False    2021-07-13
      229               229                4_stuff            False    2021-07-14
      230               230                5_stuff            False    2021-07-15
      231               231                1_stuff             True    2021-07-16
      232               232                2_stuff             True    2021-07-17
      233               233                3_stuff             True    2021-07-18
      234               234                4_stuff            False    2021-07-19
      235               235                5_stuff            False    2021-07-20
      236               236                1_stuff            False    2021-07-21
      237               237                2_stuff            False    2021-07-22
      238               238                3_stuff            False    2021-07-23
      239               239                4_stuff            False    2021-07-24
      240               240                5_stuff            False    2021-07-25
      241               241                1_stuff            False    2021-07-06
      242               242                2_stuff            False    2021-07-07
      243               243                3_stuff            False    2021-07-08
      244               244                4_stuff            False    2021-07-09
      245               245                5_stuff            False    2021-07-10
      246               246                1_stuff            False    2021-07-11
      247               247                2_stuff            False    2021-07-12
      248               248                3_stuff            False    2021-07-13
      249               249                4_stuff            False    2021-07-14
      250               250                5_stuff            False    2021-07-15
      251               251                1_stuff            False    2021-07-16
      252               252                2_stuff             True    2021-07-17
      253               253                3_stuff             True    2021-07-18
      254               254                4_stuff             True    2021-07-19
      255               255                5_stuff            False    2021-07-20
      256               256                1_stuff            False    2021-07-21
      257               257                2_stuff            False    2021-07-22
      258               258                3_stuff            False    2021-07-23
      259               259                4_stuff            False    2021-07-24
      260               260                5_stuff            False    2021-07-25
      261               261                1_stuff            False    2021-07-06
      262               262                2_stuff            False    2021-07-07
      263               263                3_stuff            False    2021-07-08
      264               264                4_stuff            False    2021-07-09
      265               265                5_stuff            False    2021-07-10
      266               266                1_stuff            False    2021-07-11
      267               267                2_stuff            False    2021-07-12
      268               268                3_stuff            False    2021-07-13
      269               269                4_stuff            False    2021-07-14
      270               270                5_stuff            False    2021-07-15
      271               271                1_stuff            False    2021-07-16
      272               272                2_stuff            False    2021-07-17
      273               273                3_stuff             True    2021-07-18
      274               274                4_stuff             True    2021-07-19
      275               275                5_stuff             True    2021-07-20
      276               276                1_stuff            False    2021-07-21
      277               277                2_stuff            False    2021-07-22
      278               278                3_stuff            False    2021-07-23
      279               279                4_stuff            False    2021-07-24
      280               280                5_stuff            False    2021-07-25
      281               281                1_stuff            False    2021-07-06
      282               282                2_stuff            False    2021-07-07
      283               283                3_stuff            False    2021-07-08
      284               284                4_stuff            False    2021-07-09
      285               285                5_stuff            False    2021-07-10
      286               286                1_stuff            False    2021-07-11
      287               287                2_stuff            False    2021-07-12
      288               288                3_stuff            False    2021-07-13
      289               289                4_stuff            False    2021-07-14
      290               290                5_stuff            False    2021-07-15
      291               291                1_stuff            False    2021-07-16
      292               292                2_stuff            False    2021-07-17
      293               293                3_stuff            False    2021-07-18
      294               294                4_stuff             True    2021-07-19
      295               295                5_stuff             True    2021-07-20
      296               296                1_stuff             True    2021-07-21
      297               297                2_stuff            False    2021-07-22
      298               298                3_stuff            False    2021-07-23
      299               299                4_stuff            False    2021-07-24
      300               300                5_stuff            False    2021-07-25
      301               301                1_stuff            False    2021-07-06
      302               302                2_stuff            False    2021-07-07
      303               303                3_stuff            False    2021-07-08
      304               304                4_stuff            False    2021-07-09
      305               305                5_stuff            False    2021-07-10
      306               306                1_stuff            False    2021-07-11
      307               307                2_stuff            False    2021-07-12
      308               308                3_stuff            False    2021-07-13
      309               309                4_stuff            False    2021-07-14
      310               310                5_stuff            False    2021-07-15
      311               311                1_stuff            False    2021-07-16
      312               312                2_stuff            False    2021-07-17
      313               313                3_stuff            False    2021-07-18
      314               314                4_stuff            False    2021-07-19
      315               315                5_stuff             True    2021-07-20
      316               316                1_stuff             True    2021-07-21
      317               317                2_stuff             True    2021-07-22
      318               318                3_stuff            False    2021-07-23
      319               319                4_stuff            False    2021-07-24
      320               320                5_stuff            False    2021-07-25
      321               321                1_stuff            False    2021-07-06
      322               322                2_stuff            False    2021-07-07
      323               323                3_stuff            False    2021-07-08
      324               324                4_stuff            False    2021-07-09
      325               325                5_stuff            False    2021-07-10
      326               326                1_stuff            False    2021-07-11
      327               327                2_stuff            False    2021-07-12
      328               328                3_stuff            False    2021-07-13
      329               329                4_stuff            False    2021-07-14
      330               330                5_stuff            False    2021-07-15
      331               331                1_stuff            False    2021-07-16
      332               332                2_stuff            False    2021-07-17
      333               333                3_stuff            False    2021-07-18
      334               334                4_stuff            False    2021-07-19
      335               335                5_stuff            False    2021-07-20
      336               336                1_stuff             True    2021-07-21
      337               337                2_stuff             True    2021-07-22
      338               338                3_stuff             True    2021-07-23
      339               339                4_stuff            False    2021-07-24
      340               340                5_stuff            False    2021-07-25
      341               341                1_stuff            False    2021-07-06
      342               342                2_stuff            False    2021-07-07
      343               343                3_stuff            False    2021-07-08
      344               344                4_stuff            False    2021-07-09
      345               345                5_stuff            False    2021-07-10
      346               346                1_stuff            False    2021-07-11
      347               347                2_stuff            False    2021-07-12
      348               348                3_stuff            False    2021-07-13
      349               349                4_stuff            False    2021-07-14
      350               350                5_stuff            False    2021-07-15
      351               351                1_stuff            False    2021-07-16
      352               352                2_stuff            False    2021-07-17
      353               353                3_stuff            False    2021-07-18
      354               354                4_stuff            False    2021-07-19
      355               355                5_stuff            False    2021-07-20
      356               356                1_stuff            False    2021-07-21
      357               357                2_stuff             True    2021-07-22
      358               358                3_stuff             True    2021-07-23
      359               359                4_stuff             True    2021-07-24
      360               360                5_stuff            False    2021-07-25
      361               361                1_stuff            False    2021-07-06
      362               362                2_stuff            False    2021-07-07
      363               363                3_stuff            False    2021-07-08
      364               364                4_stuff            False    2021-07-09
      365               365                5_stuff            False    2021-07-10
      366               366                1_stuff            False    2021-07-11
      367               367                2_stuff            False    2021-07-12
      368               368                3_stuff            False    2021-07-13
      369               369                4_stuff            False    2021-07-14
      370               370                5_stuff            False    2021-07-15
      371               371                1_stuff            False    2021-07-16
      372               372                2_stuff            False    2021-07-17
      373               373                3_stuff            False    2021-07-18
      374               374                4_stuff            False    2021-07-19
      375               375                5_stuff            False    2021-07-20
      376               376                1_stuff            False    2021-07-21
      377               377                2_stuff            False    2021-07-22
      378               378                3_stuff             True    2021-07-23
      379               379                4_stuff             True    2021-07-24
      380               380                5_stuff             True    2021-07-25
      381               381                1_stuff            False    2021-07-06
      382               382                2_stuff            False    2021-07-07
      383               383                3_stuff            False    2021-07-08
      384               384                4_stuff            False    2021-07-09
      385               385                5_stuff            False    2021-07-10
      386               386                1_stuff            False    2021-07-11
      387               387                2_stuff            False    2021-07-12
      388               388                3_stuff            False    2021-07-13
      389               389                4_stuff            False    2021-07-14
      390               390                5_stuff            False    2021-07-15
      391               391                1_stuff            False    2021-07-16
      392               392                2_stuff            False    2021-07-17
      393               393                3_stuff            False    2021-07-18
      394               394                4_stuff            False    2021-07-19
      395               395                5_stuff            False    2021-07-20
      396               396                1_stuff            False    2021-07-21
      397               397                2_stuff            False    2021-07-22
      398               398                3_stuff            False    2021-07-23
      399               399                4_stuff             True    2021-07-24
      400               400                5_stuff             True    2021-07-25
      401               401                1_stuff             True    2021-07-06
      402               402                2_stuff            False    2021-07-07
      403               403                3_stuff            False    2021-07-08
      404               404                4_stuff            False    2021-07-09
      405               405                5_stuff            False    2021-07-10
      406               406                1_stuff            False    2021-07-11
      407               407                2_stuff            False    2021-07-12
      408               408                3_stuff            False    2021-07-13
      409               409                4_stuff            False    2021-07-14
      410               410                5_stuff            False    2021-07-15
      411               411                1_stuff            False    2021-07-16
      412               412                2_stuff            False    2021-07-17
      413               413                3_stuff            False    2021-07-18
      414               414                4_stuff            False    2021-07-19
      415               415                5_stuff            False    2021-07-20
      416               416                1_stuff            False    2021-07-21
      417               417                2_stuff            False    2021-07-22
      418               418                3_stuff            False    2021-07-23
      419               419                4_stuff            False    2021-07-24
      420               420                5_stuff             True    2021-07-25
      421               421                1_stuff             True    2021-07-06
      422               422                2_stuff             True    2021-07-07
      423               423                3_stuff            False    2021-07-08
      424               424                4_stuff            False    2021-07-09
      425               425                5_stuff            False    2021-07-10
      426               426                1_stuff            False    2021-07-11
      427               427                2_stuff            False    2021-07-12
      428               428                3_stuff            False    2021-07-13
      429               429                4_stuff            False    2021-07-14
      430               430                5_stuff            False    2021-07-15
      431               431                1_stuff            False    2021-07-16
      432               432                2_stuff            False    2021-07-17
      433               433                3_stuff            False    2021-07-18
      434               434                4_stuff            False    2021-07-19
      435               435                5_stuff            False    2021-07-20
      436               436                1_stuff            False    2021-07-21
      437               437                2_stuff            False    2021-07-22
      438               438                3_stuff            False    2021-07-23
      439               439                4_stuff            False    2021-07-24
      440               440                5_stuff            False    2021-07-25
      441               441                1_stuff             True    2021-07-06
      442               442                2_stuff             True    2021-07-07
      443               443                3_stuff             True    2021-07-08
      444               444                4_stuff            False    2021-07-09
      445               445                5_stuff            False    2021-07-10
      446               446                1_stuff            False    2021-07-11
      447               447                2_stuff            False    2021-07-12
      448               448                3_stuff            False    2021-07-13
      449               449                4_stuff            False    2021-07-14
      450               450                5_stuff            False    2021-07-15
      451               451                1_stuff            False    2021-07-16
      452               452                2_stuff            False    2021-07-17
      453               453                3_stuff            False    2021-07-18
      454               454                4_stuff            False    2021-07-19
      455               455                5_stuff            False    2021-07-20
      456               456                1_stuff            False    2021-07-21
      457               457                2_stuff            False    2021-07-22
      458               458                3_stuff            False    2021-07-23
      459               459                4_stuff            False    2021-07-24
      460               460                5_stuff            False    2021-07-25
      461               461                1_stuff            False    2021-07-06
      462               462                2_stuff             True    2021-07-07
      463               463                3_stuff             True    2021-07-08
      464               464                4_stuff             True    2021-07-09
      465               465                5_stuff            False    2021-07-10
      466               466                1_stuff            False    2021-07-11
      467               467                2_stuff            False    2021-07-12
      468               468                3_stuff            False    2021-07-13
      469               469                4_stuff            False    2021-07-14
      470               470                5_stuff            False    2021-07-15
      471               471                1_stuff            False    2021-07-16
      472               472                2_stuff            False    2021-07-17
      473               473                3_stuff            False    2021-07-18
      474               474                4_stuff            False    2021-07-19
      475               475                5_stuff            False    2021-07-20
      476               476                1_stuff            False    2021-07-21
      477               477                2_stuff            False    2021-07-22
      478               478                3_stuff            False    2021-07-23
      479               479                4_stuff            False    2021-07-24
      480               480                5_stuff            False    2021-07-25
      481               481                1_stuff            False    2021-07-06
      482               482                2_stuff            False    2021-07-07
      483               483                3_stuff             True    2021-07-08
      484               484                4_stuff             True    2021-07-09
      485               485                5_stuff             True    2021-07-10
      486               486                1_stuff            False    2021-07-11
      487               487                2_stuff            False    2021-07-12
      488               488                3_stuff            False    2021-07-13
      489               489                4_stuff            False    2021-07-14
      490               490                5_stuff            False    2021-07-15
      491               491                1_stuff            False    2021-07-16
      492               492                2_stuff            False    2021-07-17
      493               493                3_stuff            False    2021-07-18
      494               494                4_stuff            False    2021-07-19
      495               495                5_stuff            False    2021-07-20
      496               496                1_stuff            False    2021-07-21
      497               497                2_stuff            False    2021-07-22
      498               498                3_stuff            False    2021-07-23
      499               499                4_stuff            False    2021-07-24
      500               500                5_stuff            False    2021-07-25
          Children
      1          0
      2          1
      3          0
      4          1
      5          0
      6          1
      7          0
      8          1
      9          0
      10         1
      11         0
      12         1
      13         0
      14         1
      15         0
      16         1
      17         0
      18         1
      19         0
      20         1
      21         0
      22         1
      23         0
      24         1
      25         0
      26         1
      27         0
      28         1
      29         0
      30         1
      31         0
      32         1
      33         0
      34         1
      35         0
      36         1
      37         0
      38         1
      39         0
      40         1
      41         0
      42         1
      43         0
      44         1
      45         0
      46         1
      47         0
      48         1
      49         0
      50         1
      51         0
      52         1
      53         0
      54         1
      55         0
      56         1
      57         0
      58         1
      59         0
      60         1
      61         0
      62         1
      63         0
      64         1
      65         0
      66         1
      67         0
      68         1
      69         0
      70         1
      71         0
      72         1
      73         0
      74         1
      75         0
      76         1
      77         0
      78         1
      79         0
      80         1
      81         0
      82         1
      83         0
      84         1
      85         0
      86         1
      87         0
      88         1
      89         0
      90         1
      91         0
      92         1
      93         0
      94         1
      95         0
      96         1
      97         0
      98         1
      99         0
      100        1
      101        0
      102        1
      103        0
      104        1
      105        0
      106        1
      107        0
      108        1
      109        0
      110        1
      111        0
      112        1
      113        0
      114        1
      115        0
      116        1
      117        0
      118        1
      119        0
      120        1
      121        0
      122        1
      123        0
      124        1
      125        0
      126        1
      127        0
      128        1
      129        0
      130        1
      131        0
      132        1
      133        0
      134        1
      135        0
      136        1
      137        0
      138        1
      139        0
      140        1
      141        0
      142        1
      143        0
      144        1
      145        0
      146        1
      147        0
      148        1
      149        0
      150        1
      151        0
      152        1
      153        0
      154        1
      155        0
      156        1
      157        0
      158        1
      159        0
      160        1
      161        0
      162        1
      163        0
      164        1
      165        0
      166        1
      167        0
      168        1
      169        0
      170        1
      171        0
      172        1
      173        0
      174        1
      175        0
      176        1
      177        0
      178        1
      179        0
      180        1
      181        0
      182        1
      183        0
      184        1
      185        0
      186        1
      187        0
      188        1
      189        0
      190        1
      191        0
      192        1
      193        0
      194        1
      195        0
      196        1
      197        0
      198        1
      199        0
      200        1
      201        0
      202        1
      203        0
      204        1
      205        0
      206        1
      207        0
      208        1
      209        0
      210        1
      211        0
      212        1
      213        0
      214        1
      215        0
      216        1
      217        0
      218        1
      219        0
      220        1
      221        0
      222        1
      223        0
      224        1
      225        0
      226        1
      227        0
      228        1
      229        0
      230        1
      231        0
      232        1
      233        0
      234        1
      235        0
      236        1
      237        0
      238        1
      239        0
      240        1
      241        0
      242        1
      243        0
      244        1
      245        0
      246        1
      247        0
      248        1
      249        0
      250        1
      251        0
      252        1
      253        0
      254        1
      255        0
      256        1
      257        0
      258        1
      259        0
      260        1
      261        0
      262        1
      263        0
      264        1
      265        0
      266        1
      267        0
      268        1
      269        0
      270        1
      271        0
      272        1
      273        0
      274        1
      275        0
      276        1
      277        0
      278        1
      279        0
      280        1
      281        0
      282        1
      283        0
      284        1
      285        0
      286        1
      287        0
      288        1
      289        0
      290        1
      291        0
      292        1
      293        0
      294        1
      295        0
      296        1
      297        0
      298        1
      299        0
      300        1
      301        0
      302        1
      303        0
      304        1
      305        0
      306        1
      307        0
      308        1
      309        0
      310        1
      311        0
      312        1
      313        0
      314        1
      315        0
      316        1
      317        0
      318        1
      319        0
      320        1
      321        0
      322        1
      323        0
      324        1
      325        0
      326        1
      327        0
      328        1
      329        0
      330        1
      331        0
      332        1
      333        0
      334        1
      335        0
      336        1
      337        0
      338        1
      339        0
      340        1
      341        0
      342        1
      343        0
      344        1
      345        0
      346        1
      347        0
      348        1
      349        0
      350        1
      351        0
      352        1
      353        0
      354        1
      355        0
      356        1
      357        0
      358        1
      359        0
      360        1
      361        0
      362        1
      363        0
      364        1
      365        0
      366        1
      367        0
      368        1
      369        0
      370        1
      371        0
      372        1
      373        0
      374        1
      375        0
      376        1
      377        0
      378        1
      379        0
      380        1
      381        0
      382        1
      383        0
      384        1
      385        0
      386        1
      387        0
      388        1
      389        0
      390        1
      391        0
      392        1
      393        0
      394        1
      395        0
      396        1
      397        0
      398        1
      399        0
      400        1
      401        0
      402        1
      403        0
      404        1
      405        0
      406        1
      407        0
      408        1
      409        0
      410        1
      411        0
      412        1
      413        0
      414        1
      415        0
      416        1
      417        0
      418        1
      419        0
      420        1
      421        0
      422        1
      423        0
      424        1
      425        0
      426        1
      427        0
      428        1
      429        0
      430        1
      431        0
      432        1
      433        0
      434        1
      435        0
      436        1
      437        0
      438        1
      439        0
      440        1
      441        0
      442        1
      443        0
      444        1
      445        0
      446        1
      447        0
      448        1
      449        0
      450        1
      451        0
      452        1
      453        0
      454        1
      455        0
      456        1
      457        0
      458        1
      459        0
      460        1
      461        0
      462        1
      463        0
      464        1
      465        0
      466        1
      467        0
      468        1
      469        0
      470        1
      471        0
      472        1
      473        0
      474        1
      475        0
      476        1
      477        0
      478        1
      479        0
      480        1
      481        0
      482        1
      483        0
      484        1
      485        0
      486        1
      487        0
      488        1
      489        0
      490        1
      491        0
      492        1
      493        0
      494        1
      495        0
      496        1
      497        0
      498        1
      499        0
      500        1

# Reference field with shallow reference table should provide field based names

    Code
      personMinimalRefDf
    Output
        Respondent name Children Ref 1 Identifier number
      1             Bob        6                    <NA>
      2           Alice        6                     107

# filter on reference field works

    Code
      filteredRowDf
    Output
        Ref 1 Identifier number Ref 2 Identifier number Ref 3 Identifier number
      1                     107                      NA                      NA
        Respondent name
      1           Alice

