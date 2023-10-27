from django.contrib import admin
from .models import Step

class StepAdmin(admin.ModelAdmin):
    list_display = ['name']
admin.site.register(Step, StepAdmin)
