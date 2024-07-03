FROM python:3.10-slim

WORKDIR /app

COPY api/* /app/ 

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python3", "api.py"]
