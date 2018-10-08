FROM praekeltfoundation/django-bootstrap:py3.7-stretch

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_message_sender.settings
ENV CELERY_APP seed_message_sender

RUN django-admin collectstatic --noinput

CMD ["seed_message_sender.wsgi:application"]
