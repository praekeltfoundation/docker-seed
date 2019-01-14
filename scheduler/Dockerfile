FROM praekeltfoundation/django-bootstrap:py3.6-stretch

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_scheduler.settings
ENV CELERY_APP seed_scheduler

RUN django-admin collectstatic --noinput

CMD ["seed_scheduler.wsgi:application"]
