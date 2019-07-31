def numbers(mylist):
    list_of_numbers = []
    for el in mylist:
        try:
            list_of_numbers.append(int(el))
        except ValueError:
            pass
    return list_of_numbers
    


class FilterModule(object):

    def filters(self):
        return {
            'numbers': numbers
        }