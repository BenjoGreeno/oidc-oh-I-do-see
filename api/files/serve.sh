# serve.sh
#!/bin/sh
# run with gunicorn (http://docs.gunicorn.org/en/stable/run.html#gunicorn)
exec gunicorn --chdir /home/app -b :5000 api:app