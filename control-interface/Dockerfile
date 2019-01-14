FROM praekeltfoundation/django-bootstrap:py2

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ENV DJANGO_SETTINGS_MODULE seed_control_interface.settings

RUN django-admin collectstatic --noinput

CMD ["seed_control_interface.wsgi:application"]
