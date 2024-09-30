
"""
edit xml's

"""
from pathlib import Path
from xml.etree import ElementTree as et

# set text using find - set it regardless of what is was before.
p = Path('in')
for i in p.glob('**/*.xml'):
    print(i.name)
    tree = et.parse(i)
    tree.find('.//width').text = '267'
    tree.write(i)
    


"""

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
  
"""
