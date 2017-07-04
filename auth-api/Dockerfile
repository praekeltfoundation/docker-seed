FROM praekeltfoundation/django-bootstrap:py2

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_auth_api.settings
ENV CELERY_APP seed_auth_api

RUN django-admin collectstatic --noinput

CMD ["seed_auth_api.wsgi:application"]
