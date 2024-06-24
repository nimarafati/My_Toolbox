AWK
================
Nima Rafati
1/17/2022

# Introduction

Before using **awk** try to solve it by **sed** or **grep**; If it was
not possible then it’s time to use **awk**.  
But what is **awk**?

*The AWK language is a data-driven scripting language consisting of a
set of actions to be taken against streams of textual data - either run
directly on files or used as part of a pipeline - for purposes of
extracting or transforming text, such as producing formatted reports.
The language extensively uses the string datatype, associative arrays
(that is, arrays indexed by key strings), and regular expressions.*
(wikipedia.org)

# General notes about awk

-   You should always use single quote **’** not double quote **"**.  
-   awk command syntax:

``` bash
awk '/pattern/' {commands} fileA fileB ... fileZ  
```

# Simple example

``` bash
echo "gold     1    1986  USA                 American Eagle
gold     1    1908  Austria-Hungary     Franz Josef 100 Korona
silver  10    1981  USA                 ingot
gold     1    1984  Switzerland         ingot
gold     1    1979  RSA                 Krugerrand
gold     0.5  1981  RSA                 Krugerrand
gold     0.1  1986  PRC                 Panda - silver lined
silver   1    1986  USA                 Liberty dollar
gold     0.25 1986  USA                 Liberty 5-dollar piece
silver   0.5  1986  USA                 Liberty 50-cent piece
silver   1    1987  USA                 Constitution dollar
gold     0.25 1987  USA                 Constitution 5-dollar piece
gold     1    1988  Canada              Maple Leaf
" > coins.txt
```

Q: How many “gold” you can find in the file?

``` bash
awk '/gold/' coins.txt  
```

    ## gold     1    1986  USA                 American Eagle
    ## gold     1    1908  Austria-Hungary     Franz Josef 100 Korona
    ## gold     1    1984  Switzerland         ingot
    ## gold     1    1979  RSA                 Krugerrand
    ## gold     0.5  1981  RSA                 Krugerrand
    ## gold     0.1  1986  PRC                 Panda - silver lined
    ## gold     0.25 1986  USA                 Liberty 5-dollar piece
    ## gold     0.25 1987  USA                 Constitution 5-dollar piece
    ## gold     1    1988  Canada              Maple Leaf

Q: Extract coins before 1910.

``` bash
awk '$3 < 1910' coins.txt
```

    ## gold     1    1908  Austria-Hungary     Franz Josef 100 Korona

# Math

Save the following information into a file

``` bash
echo "10 20 30 
40 50 60 My_Toolbox" > data
```

Q: Print each line and this operation (column1 + coulm2 \* column3):

``` bash
awk '{print $0, ":", $1 + $2 * $3}' data
```

    ## 10 20 30  : 610
    ## 40 50 60 My_Toolbox : 3040

Q: What happens if you sum column4 where you have text (My\_Toolbox)?

``` bash
awk '{print $0, ":", $1 + $2 * $3 + $4}' data
```

    ## 10 20 30  : 610
    ## 40 50 60 My_Toolbox : 3040

Awk does not complain about the txt and just return the math without
column 4 which is only present in second line?  
Q: What happens if you multiply column4 by **one** where you have text
(My\_Toolbox)?

``` bash
awk '{print $0, ":", $4 * 1}' data
```

    ## 10 20 30  : 0
    ## 40 50 60 My_Toolbox : 0

awk returns zero! Imagin you have scientific numbers (10e6) it returns
10! So be aware of behaviour of awk with text in math commands.

Q: How many coulmns we have in **data** file?

``` bash
awk '{print NF}' data
```

    ## 3
    ## 4

**NF: number of fields**  
Q: You have different number of columns; how can you print the last
column?

``` bash
awk '{print $NF}' data 
```

    ## 30
    ## My_Toolbox

by **$NF** you print last column of each line regardless differences in
number of fields (columns).

Q: Print third to the last field.

``` bash
awk '{print $(NF-2)}' data
```

    ## 10
    ## 50

Q: Print number of rows

``` bash
awk '{print "row number"NR,":", $0}' data
```

    ## row number1 : 10 20 30 
    ## row number2 : 40 50 60 My_Toolbox

**NR: number of rows**  
\# Formating the content of the file You can do that by `printf()`

``` bash
awk '{printf("%10s\n",$1)}' coins.txt
```

    ##       gold
    ##       gold
    ##     silver
    ##       gold
    ##       gold
    ##       gold
    ##       gold
    ##     silver
    ##       gold
    ##     silver
    ##     silver
    ##       gold
    ##       gold
    ## 

You aligned column1 by 10 spaces.  
**%** is a format specifier for `printf()`.  
**s** space.  
\*\*\* newline.  
Now left alignment

``` bash
awk '{printf("%-10s|\n",$1)}' coins.txt
```

    ## gold      |
    ## gold      |
    ## silver    |
    ## gold      |
    ## gold      |
    ## gold      |
    ## gold      |
    ## silver    |
    ## gold      |
    ## silver    |
    ## silver    |
    ## gold      |
    ## gold      |
    ##           |

You can read more about formatting
[here](https://www.gnu.org/software/gawk/manual/html_node/Index.html)

# Create tables

You can create frequency table by awk. Let’s count number of countries
in coins file.

``` bash
awk '{country[$4]++} END {for (i in country) print "Country: " i," count: ", country[i]}' coins.txt
```

    ## Country:   count:  1
    ## Country: Austria-Hungary  count:  1
    ## Country: USA  count:  7
    ## Country: Canada  count:  1
    ## Country: Switzerland  count:  1
    ## Country: PRC  count:  1
    ## Country: RSA  count:  2

We save countries name in an array called **country** and the iterate
through the array and print the counts.  
**++** means to add the previous value every time you see
country\[$4\].  
You can also save the command in a bash file.

``` bash
#!/usr/bin/awk -f
{ country[$4]++ }

END {
  for (i in country) print "Country: " i," count: ", country[i]
} 
```

You can force awk to do perform some commands in the beginning and
ending reading the file:  
- **BEGIN**: you can for example define variable(s).  
- **END**: perform some calculation or print the variable(s).

Converting the chopped **Distance** matrix in **gaussian.out** file.

``` bash
#!/usr/bin/awk -f
{ country[$4]++ }

END {
  country['USA']='TEST'
  for (i in country) print "Country: " i," count: ", country[i]
}
```

# Multidimonsional arrays in awk

# Multiline file to single line (e.g. fasta)

``` bash
echo ">1
ACGT
SVGT
SVHT
>2
TCGAAAA
TCGAAAA
TCGAAAA" >fasta.fasta
```

Step1- Fetch the header line

``` bash
awk '/^>/{printf("\n%s\n", $0)}' fasta.fasta
```

    ## 
    ## >1
    ## 
    ## >2

Step2- glue together next lines (which do not start with **&gt;**)

``` bash
awk '/^>/{printf("\n%s\n", $0)} !/^>/{printf("%s",$0)}' fasta.fasta
```

    ## 
    ## >1
    ## ACGTSVGTSVHT
    ## >2
    ## TCGAAAATCGAAAATCGAAAA

Step3- print newline at the end

``` bash
awk '/^>/{printf("\n%s\n", $0)} !/^>/{printf("%s",$0)} END{printf("\n",$0)} ' fasta.fasta
```

    ## 
    ## >1
    ## ACGTSVGTSVHT
    ## >2
    ## TCGAAAATCGAAAATCGAAAA

# Summary of arguments used in awk

**NR** number of rows  
**NF** number of fields **FILENAME** file name to pass to awk  
**FS** field separator  
**OFS** output field separator (default = space; you can for example set
to tab “)  
**system** calling unix command (e.g. system(”date")) **next** You can
skip a line  
**exit** You can exit the loop or command
