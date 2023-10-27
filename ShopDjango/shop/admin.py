from django.contrib import admin
from .models import Category, Product, Supplier


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug']
    prepopulated_fields = {'slug': ('name',)}
admin.site.register(Category, CategoryAdmin)

class SupplierAdmin(admin.ModelAdmin):
    list_display = ['name']
admin.site.register(Supplier, SupplierAdmin)

class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'price', 'amount', 'available', 'created', 'updated']
    list_filter = ['available', 'created', 'updated']
    list_editable = ['price', 'amount', 'available',]
    prepopulated_fields = {'slug': ('name',)}
admin.site.register(Product, ProductAdmin)
