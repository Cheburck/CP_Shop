from django.contrib import admin
from .models import City

class CityAdmin(admin.ModelAdmin):
    list_display = ['name', 'days_deliver']
admin.site.register(City, CityAdmin)
