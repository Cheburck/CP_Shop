from django.db import models
from makeorders.models import Buy
from datetime import timedelta
class Step(models.Model):
    name = models.CharField(max_length=30, db_index=True)

    class Meta:
        ordering = ('name',)
        verbose_name = 'Шаг'

    def __str__(self):
        return self.name

class Buy_Step(models.Model):
    step = models.ForeignKey(Step, related_name='buy_step_step', on_delete=models.CASCADE)
    buy = models.ForeignKey(Buy, related_name='buy_step_buy', on_delete=models.CASCADE)
    step_date_beg = models.DateTimeField()
    step_date_end = models.DateTimeField()

    class Meta:
        ordering = ('-step_date_beg',)
        verbose_name = 'Заказ'
        verbose_name_plural = 'Заказы'


