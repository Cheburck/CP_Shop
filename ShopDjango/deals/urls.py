from django.urls import re_path
from django.urls import path
from . import views


urlpatterns = [
    re_path(r'^$', views.deals_detail, name='deals_detail'),
    re_path(r'^add/(?P<order_id>\d+)/$', views.deals_add, name='deals_add'),
    re_path(r'^remove/(?P<order_id>\d+)/$', views.deals_remove, name='deals_remove'),
]
