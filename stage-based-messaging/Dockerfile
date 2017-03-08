FROM praekeltfoundation/django-bootstrap:py2

ENV DJANGO_SETTINGS_MODULE seed_stage_based_messaging.settings

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

RUN django-admin collectstatic --noinput

CMD ["seed_stage_based_messaging.wsgi:application"]
