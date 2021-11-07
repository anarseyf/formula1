
# Formula 1 World Champions

<img src="formula1_files/figure-gfm/main-1.png" width="100%" />

## Data notes

### Multiple P1 entries for some races

These races have more than one entry in `results.csv` for pole-sitter
(`grid = 1`):

       raceId polesitterId
    1     717          374
    2     717          373
    3     780          479
    4     785          608
    5     791          608
    6     792          642
    7     792          427
    8     814          633
    9     815          697
    10    824          475
    11    828          786

The reasons are kind of wild. See for example:

-   Race ID 792:
    <https://en.wikipedia.org/wiki/1955_Argentine_Grand_Prix>
-   Race ID 717:
    <https://en.wikipedia.org/wiki/1964_United_States_Grand_Prix>

### Pole position based on starting grid

The dataset does not contain qualy times for over half of all the 1000+
races. I am using starting grid position P1 instead.

## Credit

Inspired by
<https://github.com/gkaramanis/tidytuesday/tree/master/2020/2020-week15>.
