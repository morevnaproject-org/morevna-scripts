#!/usr/bin/env python

import os
import sys

# print fix
try:
  Print = eval("print") # python 3.0 case
except SyntaxError:
  try:
    D = dict()
    exec("from __future__ import print_function\np=print", D)
    Print = D["p"] # 2.6 case
    del D
  except SyntaxError:
    del D
    def Print(*args, **kwd): # 2.4, 2.5, define our own Print function
      fout = kwd.get("file", sys.stdout)
      w = fout.write
      if args:
        w(str(args[0]))
        sep = kwd.get("sep", " ")
        for a in args[1:]:
          w(sep)
          w(str(a))
      w(kwd.get("end", "\n"))

def check_substring(data, substring):
	s = "\n".join(data);
	if substring in s:
			return True

	return False
	
def merge_defs():
	defs=False
	for l in f1_contents:
		if defs:
			if not "</defs>" in l:
				f2.write(l)
			else:
				break
		elif "<defs>" in l:
			defs=True


if len(sys.argv) < 3:
	Print('Usage: %s stickman.sif file.sif' % sys.argv[0])
	Print('    (first stickman file will be merged into second)')
	sys.exit()

f1_filename = sys.argv[1]
f2_filename = sys.argv[2]

# TODO: check version of first file

f1 = open(f1_filename, 'r')
f1_contents = f1.readlines()
f1.close()
f2 = open(f2_filename, 'r')
f2_contents = f2.readlines()
f2.close()

f2 = open(f2_filename, 'w')

num=1
while check_substring(f2_contents, '(stk%s' % num):
	num+=1

for i, line in enumerate(f1_contents):
	f1_contents[i] = line.replace('(stk','(stk%s' % num)

defs_found=False
for line in f2_contents:
	if "</defs>" in line:
		defs_found=True
		merge_defs()
	if line == "</canvas>\n":
		if not defs_found:
			f2.write("<defs>\n")
			merge_defs()
			f2.write("</defs>\n")
		canvas=False
		for l in f1_contents:
			if canvas:
				if not l == "</canvas>\n":
					f2.write(l)
				else:
					break
			elif "</defs>" in l:
				canvas=True
	f2.write(line)

f2.close()
