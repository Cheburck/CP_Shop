from django.shortcuts import render, redirect
from django.views.decorators.http import require_POST
from .deals import Deals
from .forms import ProductAddMarkForm
from shop.products import Product
from makeorders.models import Buy_Product

@require_POST
def deals_add(request, order_id):
    buy_product = Buy_Product.objects.filter(order_id=order_id)
    form = ProductAddMarkForm(request.POST)
    if form.is_valid():
        cd = form.cleaned_data
        for i, itew in enumerate(buy_product):
            product = Product(request)
            product.add(Cprod_id=itew.product_id,
                        mark=cd['quantity'])  # оценка идет всем продуктам
    return redirect('deals:deals_detail')
def deals_remove(request, order_id):
    deals = Deals(request)
    pr = Product(request)
    deals.remove(order_id)
    return redirect('deals:deals_detail')

def deals_detail(request):
    deals = Deals(request)
    product_mark_form = ProductAddMarkForm()
    return render(request, 'deals/detail.html', {'deals': deals,
                                                 'product_mark_form': product_mark_form})


