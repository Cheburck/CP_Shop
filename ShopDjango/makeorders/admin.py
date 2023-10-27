from django.contrib import admin
from .models import City
from .models import Buy_Product

class CityAdmin(admin.ModelAdmin):
    list_display = ['name', 'days_deliver']
admin.site.register(City, CityAdmin)

class Buy_ProductAdmin(admin.ModelAdmin):
    list_display = ['order', 'product', 'price', 'quantity', 'product_rate']
admin.site.register(Buy_Product, Buy_ProductAdmin)
