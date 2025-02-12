FROM python:3.9-slim

WORKDIR /app

COPY . /app

RUN pip install -r requir.txt

RUN echo "hello i am send file from image" > cat /app/okay.txt

EXPOSE 8080

CMD ["python","-u","app.py"]
