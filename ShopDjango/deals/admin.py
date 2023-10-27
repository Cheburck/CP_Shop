from django.contrib import admin
from .models import Step
from .models import Buy_Step
from .models import Sold

class StepAdmin(admin.ModelAdmin):
    list_display = ['name']
admin.site.register(Step, StepAdmin)

class Buy_StepAdmin(admin.ModelAdmin):
    list_display = ['step', 'buy', 'step_date_beg', 'step_date_end']
admin.site.register(Buy_Step, Buy_StepAdmin)

class SoldAdmin(admin.ModelAdmin):
    list_display = ('purchase_date', 'product_name', 'unit_price', 'quantity')
admin.site.register(Sold, SoldAdmin)