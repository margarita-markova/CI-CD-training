#/usr/bin/python3.6

def find_by(mylist,mykey):
	'''Find in dict value by key'''

	for key in mylist:
		if key == mykey:
			return True
	return False
	


class FilterModule(object):

    def filters(self):
        return {
        	'find_by': find_by
        }