#/usr/bin/python3.6

def parse(mylist,mykey):
	'''Find in dict value by key'''

	for mydict in mylist:
		if mydict['name'] == mykey:
			return mydict['id']
	return mykey + " is not found"
	


class FilterModule(object):

    def filters(self):
        return {
        	'parse': parse
        }