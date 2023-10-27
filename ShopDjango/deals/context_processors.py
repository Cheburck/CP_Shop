from .deals import Deals

def deals(request):
    return {'deals': Deals(request)}
