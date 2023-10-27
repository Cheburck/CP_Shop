from django import forms

class ProductAddMarkForm(forms.Form):
    PRODUCT_MARK_CHOICES = [(i, str(i)) for i in range(1, 6)]
    quantity = forms.TypedChoiceField(choices=PRODUCT_MARK_CHOICES, coerce=int)