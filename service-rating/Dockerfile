FROM praekeltfoundation/django-bootstrap:py2

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_service_rating.settings
ENV CELERY_APP seed_service_rating

RUN django-admin collectstatic --noinput

CMD ["seed_service_rating.wsgi:application"]
