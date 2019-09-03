FROM praekeltfoundation/django-bootstrap:py3.6

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_control_interface_service.settings
ENV CELERY_APP seed_control_interface_service

RUN django-admin collectstatic --noinput

CMD ["seed_control_interface_service.wsgi:application"]
