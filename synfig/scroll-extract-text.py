#!python

import sys
import codecs

filename = sys.argv[1]
f = codecs.open(filename, 'r', encoding='utf-8')
contents = f.readlines()
f.close()

output=[]
text_layer=False
heading=False
multiline_text=False
for line in contents:
    # text
    if "<layer" in line and 'type="text"' in line and 'active="true"' in line:
	text_layer=True
    if multiline_text:
	output[-1]+="\n"+line.strip().replace("</string>","")
	if "</string>" in line:
	    multiline_text=False
    elif "<string>" in line and text_layer:
	output.append(line.strip().replace("<string>","").replace("</string>",""))
	if not "</string>" in line:
	    multiline_text=True
    if "</layer>" in line and text_layer:
	text_layer=False
    # linebreak
    if "<layer" in line and 'type="translate"' in line and 'active="true"' in line:
	output.append("\n")
	
output="".join(reversed(output))
print output
