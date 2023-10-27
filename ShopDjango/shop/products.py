from django.conf import settings
from decimal import Decimal
from shop.models import Product as Pr

class Product(object):
    def __init__(self, request):
        self.session = request.session
        products = self.session.get(settings.PRODUCTS_SESSION_ID)
        if not products:
            products = self.session[settings.PRODUCTS_SESSION_ID] = {}
        self.products = products

    def add(self, Cprod_id, mark, quantity=1):
        cprod_id = str(Cprod_id)
        if cprod_id not in self.products:
            self.products[cprod_id] = {'votes': 0, 'overal_marks': 0.0}

        self.products[cprod_id]['votes'] += quantity
        self.products[cprod_id]['overal_marks'] += mark

        pr = Pr.objects.filter(id__in=cprod_id)[0]
        pr.product_rate = Decimal(self.products[cprod_id]['overal_marks'] / self.products[cprod_id]['votes'])
        self.save()

    def save(self):
        self.session[settings.PRODUCTS_SESSION_ID] = self.products
        # Отметить сеанс как "измененный"
        self.session.modified = True


    def clear(self):
        # удаление сделок из сессии
        del self.session[settings.PRODUCTS_SESSION_ID]
        self.session.modified = True