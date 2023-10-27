from django.db import models
from shop.models import Product

class City(models.Model):
    name = models.CharField(max_length=100, db_index=True)
    days_deliver = models.PositiveIntegerField()

    class Meta:
        ordering = ('name',)
        verbose_name = 'Город'
        verbose_name_plural = 'Города'


class Client(models.Model):
    city = models.ForeignKey(City, related_name='client_city', on_delete=models.CASCADE)
    name = models.CharField(max_length=100, db_index=True)
    birthday = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ('name',)
        verbose_name = 'Клиент'
        verbose_name_plural = 'Клиенты'

class Buy(models.Model):
    FIO = models.CharField(max_length=100, verbose_name='ФИО')
    email = models.EmailField(verbose_name='email')
    address = models.CharField(max_length=250, verbose_name='Адрес')
    postal_code = models.CharField(max_length=20, verbose_name='Почтовый индекс')
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('-created',)
        verbose_name = 'Заказ'
        verbose_name_plural = 'Заказы'

    def __str__(self):
        return 'Заказ {}'.format(self.id)

    def get_total_cost(self):
        return sum(item.get_cost() for item in self.buy_product_buy.all())


class Buy_Product(models.Model):
    order = models.ForeignKey(Buy, related_name='buy_product_buy', on_delete=models.CASCADE)
    product = models.ForeignKey(Product, related_name='buy_product_product', on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=1)
    product_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)

    def __str__(self):
        return '{}'.format(self.id)

    def get_cost(self):
        return self.price * self.quantity

    class Meta:
        verbose_name = 'Купленный продукт'
        verbose_name_plural = 'Купленные продукты'
