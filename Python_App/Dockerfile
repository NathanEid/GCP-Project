FROM python:3.7
WORKDIR /application
COPY . .
RUN pip install -r requirements.txt
ENV ENVIRONMENT=DEV
ENV HOST=localhost
ENV PORT=8000
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV REDIS_DB=0
EXPOSE 8000
CMD [ "python3", "hello.py" ]
