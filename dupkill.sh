#!/bin/bash
# find duplicate .txt files in a folder hierarchy

# Creator : Erin Dahlgren
# January 18th 2012





files=$( find $1 -type f -name \*.txt | xargs ls )

openssl dgst -md5 $files |  
sed '
    /^MD5(/s/// 
    /)=/s///  
' | 
sort -k2n,2 |
awk ' 
    { names[NR] = $1 }
    { hex[NR] = $2 }
    END {
        for (x in hex) {
            if (hex[x] == hex[x-1]) {
                printf("%s is a duplicate with %s\n", names[x], names[x-1])
            }
        }
    }
'





















