from django import forms
from .models import Buy, City
from django.forms import widgets

class OrderCreateForm(forms.ModelForm, forms.Form):
    class Meta:
        model = Buy
        fields = ['FIO', 'email', 'address', 'postal_code']

    CITY_CHOICES = []
    for itew in City.objects.all():
        CITY_CHOICES.append([itew.id, itew.name])
    quantity = forms.TypedChoiceField(choices=CITY_CHOICES, coerce=str, widget=widgets.Select(attrs={'style': 'font-size: medium'}))
