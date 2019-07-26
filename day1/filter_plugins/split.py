#/usr/bin/python3.6

def split(mystr,delimiter):
	return mystr.split(delimiter)
	


class FilterModule(object):

    def filters(self):
        return {
        	'split': split
        }