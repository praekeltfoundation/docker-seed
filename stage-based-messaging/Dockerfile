FROM praekeltfoundation/django-bootstrap:py3.6-stretch

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_stage_based_messaging.settings
ENV CELERY_APP seed_stage_based_messaging

RUN django-admin collectstatic --noinput

CMD ["seed_stage_based_messaging.wsgi:application"]
