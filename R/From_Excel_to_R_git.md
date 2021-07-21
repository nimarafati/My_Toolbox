From Excel to R
================
Nima Rafati
12/25/2020

  - [Introduction](#introduction)
  - [Vector and Matrix and data
    frames](#vector-and-matrix-and-data-frames)
  - [Summary statistics](#summary-statistics)

# Introduction

In this tutorial we will learn how to use R by using examples fro excel
environment. Many of us have been using excel for any different
purposes. With excel we can organise the data, plot, and even do some
statistical analysis. However, there are some limitations. We cannot run
some complex analysis such as running linear models, or creating
multipanel plots,….. Using VBA you can force excel to use some of the
statistical models but you need to code in visual basic environment and
it is not meant to do only statistical model. Moreover, it may become
more complicated. From reproducibility point of view R has definitely
more potential than excel. Last but not least when it comes to
publication, sharing the analysis by any codes (inculding R) is more
popular.  
\# Data type Regardless of which tool we use, we can categorize data in
following groups:  
\- Integer: Numbers  
\- Logical: True or False  
\- Character: text (Names)

We store our data in variables which dependent on data format we can
save it as vector, matrix, data frame, or list which you will learn
about them in next section.

# Vector and Matrix and data frames

In an excel sheet you have rows and columns. Since begining of 2000s
excel sheet has 1048576 rows and 16384 columns. If you do not remember
it used to be much less cells available in older versions. Although it
is a big number but sometimes we may have larger files which we cannot
use excel. Although such files may be large to load in R but still there
are some solutions for that. As an alternative to R you can use python,
perl,…. by which you do not need to load any file.  
Now let’s have an example in excel and try to replicate it in R. As you
know an excel sheet is like a big matrix. Columns are named by letters
and rows by numbers.

<div class="figure">

<img src="Figures/Excel_matrice_20_4.png" alt="A matrix with 20 rows (without header row) and five columns." width="30%" />

<p class="caption">

A matrix with 20 rows (without header row) and five columns.

</p>

</div>

Now we create four vectors (Name, Gender, Age, Height, Grade) and save
them as four variables. We can create variable as follows using
assignment operator (\<-), which you can replace by equal (=) but in
order not to confuse them when we set parameters in functions it’s
better to use assignment operator (\<-).

``` r
Name <- c("Alex",   "Nona", "Behdad",   "Aida", "Nima", "Nickan",   "Jenny",    "Angela",   "Martin",   "Donald",   "Saeed",    "Sara", "Farnaz",   "Leif", "Anders",   "Mahmoud",  "Lili", "Fatima",   "Elvin",    "Liam")
Gender <- c("M",    "F",    "M",    "F",    "M",    "M",    "F",    "F",    "M",    "M",    "M",    "F",    "F",    "M",    "M",    "M",    "F",    "F",    "M",    "M")
Age <- c(58,    63, 67, 55, NA, 40, 57, 36, 22, 31, 51, 22, 21, 32, 60, 59, 64, 36, 34, 26)
Height <- c(168,    163,    151,    187,    184,    185,    163,    162,    172,    160,    167,    155,    158,    152,    200,    159,    161,    173,    155,    170)
Grade <- c(55,  78, 59, 82, 96, 68, 69, 93, 99, NA, 67, 71, 78, 86, 52, 59, 60, 55, 66, 55)
```

It is important to look into summary statistic of our data such as
frequency, average, standard deviation,…..  
We first check the nummber of observation in each vector.

``` r
Name
```

    ##  [1] "Alex"    "Nona"    "Behdad"  "Aida"    "Nima"    "Nickan"  "Jenny"  
    ##  [8] "Angela"  "Martin"  "Donald"  "Saeed"   "Sara"    "Farnaz"  "Leif"   
    ## [15] "Anders"  "Mahmoud" "Lili"    "Fatima"  "Elvin"   "Liam"

``` r
length(Name) 
```

    ## [1] 20

You can always check the help of functions in R by `?length`.  
**Quetion** What is the data type in *Name* vector?

``` r
class(Name)
```

    ## [1] "character"

``` r
typeof(Name)
```

    ## [1] "character"

Now, it is time to create a matrix where we can put together all of the
vectors. Frist we create a matrix with 20 rows and five columns.

``` r
my_matrix <- matrix(data = 1:20, nrow = 20, ncol = 5, byrow = F)
my_matrix
```

    ##       [,1] [,2] [,3] [,4] [,5]
    ##  [1,]    1    1    1    1    1
    ##  [2,]    2    2    2    2    2
    ##  [3,]    3    3    3    3    3
    ##  [4,]    4    4    4    4    4
    ##  [5,]    5    5    5    5    5
    ##  [6,]    6    6    6    6    6
    ##  [7,]    7    7    7    7    7
    ##  [8,]    8    8    8    8    8
    ##  [9,]    9    9    9    9    9
    ## [10,]   10   10   10   10   10
    ## [11,]   11   11   11   11   11
    ## [12,]   12   12   12   12   12
    ## [13,]   13   13   13   13   13
    ## [14,]   14   14   14   14   14
    ## [15,]   15   15   15   15   15
    ## [16,]   16   16   16   16   16
    ## [17,]   17   17   17   17   17
    ## [18,]   18   18   18   18   18
    ## [19,]   19   19   19   19   19
    ## [20,]   20   20   20   20   20

**Question** Try matrix function by setting `byrow = T`, what is the
difference?

Similar to excel each cell/element has an adress in a matrix. Rows have
numbers and columns, unlike excel sheet, have too. For instance to look
the content of the cell/element located in first row and first column we
use `my_matrix[1,1]`.

``` r
my_matrix[1,1]
```

    ## [1] 1

**Question** Extract fifth element of each column, in other words what
are the values in fifth row in all columns?

**Question** Replace following elements: \[1,1\], \[1,5\] ,\[20,2\], all
elements in second *row*? Can you also replace all the values in 4th
*column*?

Now we want to replace the data with vectors we created. First check the
data type of *my\_matrix*.

``` r
my_matrix[,1] <- Name
my_matrix[,2] <- Gender
my_matrix[,3] <- Age
my_matrix[,4] <- Height
my_matrix[,5] <- Grade
my_matrix
```

    ##       [,1]      [,2] [,3] [,4]  [,5]
    ##  [1,] "Alex"    "M"  "58" "168" "55"
    ##  [2,] "Nona"    "F"  "63" "163" "78"
    ##  [3,] "Behdad"  "M"  "67" "151" "59"
    ##  [4,] "Aida"    "F"  "55" "187" "82"
    ##  [5,] "Nima"    "M"  NA   "184" "96"
    ##  [6,] "Nickan"  "M"  "40" "185" "68"
    ##  [7,] "Jenny"   "F"  "57" "163" "69"
    ##  [8,] "Angela"  "F"  "36" "162" "93"
    ##  [9,] "Martin"  "M"  "22" "172" "99"
    ## [10,] "Donald"  "M"  "31" "160" NA  
    ## [11,] "Saeed"   "M"  "51" "167" "67"
    ## [12,] "Sara"    "F"  "22" "155" "71"
    ## [13,] "Farnaz"  "F"  "21" "158" "78"
    ## [14,] "Leif"    "M"  "32" "152" "86"
    ## [15,] "Anders"  "M"  "60" "200" "52"
    ## [16,] "Mahmoud" "M"  "59" "159" "59"
    ## [17,] "Lili"    "F"  "64" "161" "60"
    ## [18,] "Fatima"  "F"  "36" "173" "55"
    ## [19,] "Elvin"   "M"  "34" "155" "66"
    ## [20,] "Liam"    "M"  "26" "170" "55"

**Question** Now check data type of *my\_matrix*. What do you see?

For multidimonsional data we can create data frame. Another advantage of
data.frame is that we can assign column names when creating the
data.frame.

``` r
df <- data.frame(Name = Name,
                 Gender = Gender,
                 AGE = Age,
                 Heigth = Height,
                 Grade = Grade)
df
```

    ##       Name Gender AGE Heigth Grade
    ## 1     Alex      M  58    168    55
    ## 2     Nona      F  63    163    78
    ## 3   Behdad      M  67    151    59
    ## 4     Aida      F  55    187    82
    ## 5     Nima      M  NA    184    96
    ## 6   Nickan      M  40    185    68
    ## 7    Jenny      F  57    163    69
    ## 8   Angela      F  36    162    93
    ## 9   Martin      M  22    172    99
    ## 10  Donald      M  31    160    NA
    ## 11   Saeed      M  51    167    67
    ## 12    Sara      F  22    155    71
    ## 13  Farnaz      F  21    158    78
    ## 14    Leif      M  32    152    86
    ## 15  Anders      M  60    200    52
    ## 16 Mahmoud      M  59    159    59
    ## 17    Lili      F  64    161    60
    ## 18  Fatima      F  36    173    55
    ## 19   Elvin      M  34    155    66
    ## 20    Liam      M  26    170    55

We can change the header by *colnames*.

``` r
colnames(df)
```

    ## [1] "Name"   "Gender" "AGE"    "Heigth" "Grade"

``` r
colnames(df)[3] <- 'Age'
colnames(df)
```

    ## [1] "Name"   "Gender" "Age"    "Heigth" "Grade"

We can access each column of a data.frame by “$”.

``` r
df$Gender
```

    ##  [1] "M" "F" "M" "F" "M" "M" "F" "F" "M" "M" "M" "F" "F" "M" "M" "M" "F" "F" "M"
    ## [20] "M"

``` r
df$Name
```

    ##  [1] "Alex"    "Nona"    "Behdad"  "Aida"    "Nima"    "Nickan"  "Jenny"  
    ##  [8] "Angela"  "Martin"  "Donald"  "Saeed"   "Sara"    "Farnaz"  "Leif"   
    ## [15] "Anders"  "Mahmoud" "Lili"    "Fatima"  "Elvin"   "Liam"

# Summary statistics

We continue with checking the statsitics of our data. We start by taking
average of *Height* by doing it manually before using *mean* function.
We know that there are 20 observations/samples. Thus we first sum the
values and divide them by 20.  
\[\sum_{n=1}^{20} n / 20 \]. 

``` r
sum(Height)/length(Height)
```

    ## [1] 167.25

Now let’s use *mean* function.

``` r
mean(Height)
```

    ## [1] 167.25

**Question** What is the average value for Age, Grade? Do you get “NA”
instead? Why?

``` r
mean(Age, na.rm = T)
```
