from django.conf import settings
from django.shortcuts import get_object_or_404
from .models import Step
import time
from shop.products import Product

class Deals(object):
    def __init__(self, request):
        """
        Инициализируем сделки
        """
        self.session = request.session
        deals = self.session.get(settings.DEALS_SESSION_ID)
        if not deals:
            deals = self.session[settings.DEALS_SESSION_ID] = {}
        self.deals = deals

    def add(self, order, days, quantity=1):
        """
        Добавить сделку или обновим их количество.
        """
        order_id = str(order.id)
        if order_id not in self.deals:
            self.deals[order_id] = {'quantity': 0, 'total_price': str(0.0)}

        self.deals[order_id]['quantity'] += quantity
        self.deals[order_id]['total_price'] = str(order.get_total_cost())
        self.deals[order_id]['start_time'] = time.time()
        self.deals[order_id]['days_deliver'] = days
        self.deals[order_id]['bool_add_col'] = False
        self.save()

    def save(self):
        # Обновление сессии deals
        self.session[settings.DEALS_SESSION_ID] = self.deals
        # Отметить сеанс как "измененный"
        self.session.modified = True

    def remove(self, Order_id):
        """
        Удаление сделок.
        """
        order_id = str(Order_id)
        if order_id in self.deals:
            del self.deals[order_id]
            self.save()

    def __iter__(self):

        """
        Перебор элементов в сделках
        """

        order_ids = self.deals.keys()
        for order_id in order_ids:
            self.deals[str(order_id)]['order_id'] = str(order_id)

        for item in self.deals.values():
            time_val1 = time.time() - item['start_time']
            time_val2 = item['days_deliver'] * 5 + 14 * 86400
            if (time_val1 >= time_val2):
                self.remove(item['order_id'])

        for item in self.deals.values():
            time_val1 = time.time() - item['start_time']
            time_val2 = item['days_deliver'] * 5
            if (time_val1 >= time_val2):
                step = get_object_or_404(Step, id='4')
                item['bool_add_col'] = True
            elif (time_val1 < item['days_deliver'] * 5) and (time_val1 >= 30.0):
                step = get_object_or_404(Step, id='3')
            elif (time_val1 < 30.0) and (time_val1 >= 10.0):
                step = get_object_or_404(Step, id='2')
            else:
                step = get_object_or_404(Step, id='1')
            item['step'] = step.name
            yield item

    def __len__(self):
        """
        Подсчет всех сделок.
        """
        return len(self.deals.values())


    def clear(self):
        # удаление сделок из сессии
        del self.session[settings.DEALS_SESSION_ID]
        self.session.modified = True
