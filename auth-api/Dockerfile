FROM praekeltfoundation/django-bootstrap:py3.6

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_auth_api.settings

RUN django-admin collectstatic --noinput

CMD ["seed_auth_api.wsgi:application"]
