"""
Extract passwords from a KDE kwalletmanager wallet exported as xml.
Each password is written unencrypted to the current directory, 
where the name matches the name in the wallet.

Note that file data remains on disk even after you "delete" it from
the filesystem.  Therefore, please use an encrypted disk, or a ram disk.

Then, in bash, starting in the same directory, run pwm, and enter the hidden
"encrypt_db" command; it will encrypt each file and write it to 
subdirectory "pwmdb".  If you like the result, copy those files
into your main pwmdb dirctory.
"""

import xml.etree.ElementTree as ET
import re

tree = ET.parse('kwallet.xml')

for pw in tree.findall("./folder[@name='Passwords']/password"):
    key = re.sub('[ /]','_',pw.get('name'))
    print(key)
    f = open(key,'w')
    f.write(str(pw.text))
    f.close()
