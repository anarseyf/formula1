
# Formula 1 World Champions

    ## # A tibble: 142 x 5
    ## # Groups:   raceId [71]
    ##    raceId driverId points position  wins
    ##     <int>    <int>  <dbl>    <int> <int>
    ##  1     17       18     95        1     6
    ##  2     17       20     84        2     4
    ##  3     35        1     98        1     5
    ##  4     35       13     97        2     6
    ##  5     52        8    110        1     6
    ##  6     52        1    109        2     4
    ##  7     70        4    134        1     7
    ##  8     70       30    121        2     7
    ##  9     89        4    133        1     7
    ## 10     89        8    112        2     7
    ## # ... with 132 more rows

    ## # A tibble: 71 x 5
    ## # Groups:   raceId [71]
    ##    raceId  year num_rounds championId runnerupId
    ##     <int> <int>      <int>      <int>      <int>
    ##  1   1047  2020         17          1        822
    ##  2   1030  2019         21          1        822
    ##  3   1009  2018         21          1         20
    ##  4    988  2017         20          1         20
    ##  5    968  2016         21          3          1
    ##  6    945  2015         19          1          3
    ##  7    918  2014         19          1          3
    ##  8    899  2013         19         20          4
    ##  9    879  2012         20         20          4
    ## 10    859  2011         19         20         18
    ## # ... with 61 more rows

    ## # A tibble: 196 x 8
    ## # Groups:   year [10]
    ##     year raceId round num_rounds driverId championId runnerupId won_by  
    ##    <int>  <int> <int>      <int>    <int>      <int>      <int> <chr>   
    ##  1  2020   1047    17         17      830          1        822 other   
    ##  2  2020   1046    16         17      815          1        822 other   
    ##  3  2020   1045    15         17        1          1        822 champion
    ##  4  2020   1044    14         17        1          1        822 champion
    ##  5  2020   1043    13         17        1          1        822 champion
    ##  6  2020   1042    12         17        1          1        822 champion
    ##  7  2020   1041    11         17        1          1        822 champion
    ##  8  2020   1040    10         17      822          1        822 runnerup
    ##  9  2020   1039     9         17        1          1        822 champion
    ## 10  2020   1038     8         17      842          1        822 other   
    ## # ... with 186 more rows

    ## # A tibble: 10 x 2
    ##     year     n
    ##    <int> <int>
    ##  1  2020    11
    ##  2  2019    11
    ##  3  2018    11
    ##  4  2017     9
    ##  5  2016     9
    ##  6  2015    10
    ##  7  2014    11
    ##  8  2013    13
    ##  9  2012     5
    ## 10  2011    11

    ## # A tibble: 10 x 4
    ## # Groups:   raceId [10]
    ##    raceId  year firstname lastname
    ##     <int> <int> <chr>     <chr>   
    ##  1   1047  2020 Lewis     Hamilton
    ##  2   1030  2019 Lewis     Hamilton
    ##  3   1009  2018 Lewis     Hamilton
    ##  4    988  2017 Lewis     Hamilton
    ##  5    968  2016 Nico      Rosberg 
    ##  6    945  2015 Lewis     Hamilton
    ##  7    918  2014 Lewis     Hamilton
    ##  8    899  2013 Sebastian Vettel  
    ##  9    879  2012 Sebastian Vettel  
    ## 10    859  2011 Sebastian Vettel

    ## # A tibble: 10 x 4
    ## # Groups:   raceId [10]
    ##    raceId  year firstname lastname
    ##     <int> <int> <chr>     <chr>   
    ##  1   1047  2020 Valtteri  Bottas  
    ##  2   1030  2019 Valtteri  Bottas  
    ##  3   1009  2018 Sebastian Vettel  
    ##  4    988  2017 Sebastian Vettel  
    ##  5    968  2016 Lewis     Hamilton
    ##  6    945  2015 Nico      Rosberg 
    ##  7    918  2014 Nico      Rosberg 
    ##  8    899  2013 Fernando  Alonso  
    ##  9    879  2012 Fernando  Alonso  
    ## 10    859  2011 Jenson    Button

![](formula1_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

    ## # A tibble: 75 x 4
    ##        n circuitRef     location         country
    ##    <int> <chr>          <chr>            <chr>  
    ##  1    71 monza          "Monza"          Italy  
    ##  2    67 monaco         "Monte-Carlo"    Monaco 
    ##  3    56 silverstone    "Silverstone"    UK     
    ##  4    54 spa            "Spa"            Belgium
    ##  5    41 nurburgring    "N\u00fcrburg"   Germany
    ##  6    40 villeneuve     "Montreal"       Canada 
    ##  7    38 interlagos     "S\u00e3o Paulo" Brazil 
    ##  8    37 hockenheimring "Hockenheim"     Germany
    ##  9    36 hungaroring    "Budapest"       Hungary
    ## 10    32 suzuka         "Suzuka"         Japan  
    ## # ... with 65 more rows

## Credit

Inspired by
<https://github.com/gkaramanis/tidytuesday/tree/master/2020/2020-week15>.
