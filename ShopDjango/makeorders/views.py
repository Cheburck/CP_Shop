from django.shortcuts import render, redirect, get_object_or_404
from .models import Buy_Product, Client, City
from .forms import OrderCreateForm
from cart.cart import Cart
from deals.deals import Deals
from shop.models import Product
from deals.models import Buy, Buy_Step, Step, Sold
import datetime

def order_create(request):
    cart = Cart(request)
    deals = Deals(request)
    if request.method == 'POST':
        form = OrderCreateForm(request.POST)
        if form.is_valid():
            client_search = Client.objects.filter(name__in=form['FIO'].value())
            city_found = City.objects.filter(id__in=form.cleaned_data['quantity'])[0]
            if (len(client_search) == 0):
                Client.objects.create(name=form['FIO'].value(),
                                      city=city_found)
            order = form.save()
            quant_total = 0

            start_date = datetime.datetime.now().replace(microsecond=0)

            for item in cart:
                quant_total += item['quantity']
                Buy_Product.objects.create(order=order,
                                         product=Product.objects.filter(id__in=item['prod_id'])[0],
                                         price=item['price'],
                                         quantity=item['quantity'])
                Sold.objects.create(purchase_date=start_date,
                                    product_name=Product.objects.filter(id__in=item['prod_id'])[0],
                                    unit_price=item['price'],
                                    quantity=item['quantity'])
            # очистка корзины
            cart.clear()

            deals = Deals(request)
            order = get_object_or_404(Buy, id=order.id)
            step = get_object_or_404(Step, id='1')
            
            Buy_Step.objects.create(buy=order,
                                    step=step,
                                    step_date_beg=start_date,
                                    step_date_end=start_date + datetime.timedelta(seconds=5*city_found.days_deliver))

            deals.add(order, city_found.days_deliver, quant_total)
            return render(request, 'orders/order/created.html',
                          {'order': order})
    else:
        form = OrderCreateForm

    return render(request, 'orders/order/create.html',
                  {'cart': cart, 'form': form})
