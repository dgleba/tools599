"""
edit xml's - find text then replace it.

"""
from pathlib import Path
from xml.etree import ElementTree as et

# replace text using find 

# edit path to look in...
p = Path('in')

for i in p.glob('**/*.xml'):
    print(i.name)
    tree = et.parse(i)

    # set width 300 if 0
    elts = tree.findall(".//width")
    for elt in elts:
        # if there is text
        if (elt.text):
          if len(elt.text) == 1:
            print(elt.text)
            elt.text = elt.text.replace("0", "300")
            
    # set height if 0
    elts = tree.findall(".//height")
    for elt in elts:
        # if there is text
        if (elt.text):
          if len(elt.text) == 1:
            print(elt.text)
            elt.text = elt.text.replace("0", "7990")
            
    # set depth = 3 in all cases without checking what it was.
    tree.find('.//depth').text = '3'
            
    tree.write(i)
    


"""
notes:

tree = ET.parse(input_file)
root = tree.getroot()
name_elts = root.findall(".//name")    # we find all 'name' elements
for elt in name_elts:
    elt.text = elt.text.replace("bicycle", "bike")
tree.write(output_file)



eg:
    tree.find('.//width').text = '267'

input:
		<width>xx</width>

output:

<annotation>
	<folder>rim_chips</folder>
	<size>
		<width>267</width>
	</size>
  
  

grep -rin "<width>300</width>" *
grep -rin "<width></width>" *
grep -rin "<width>0</width>" *
grep -rin "<depth" *
  
  
"""
