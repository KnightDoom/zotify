FROM python:3.11-alpine as base

RUN apk --update add git ffmpeg

FROM base as builder

WORKDIR /install
COPY requirements.txt /requirements.txt

RUN apk add gcc libc-dev zlib zlib-dev jpeg-dev
RUN pip install --prefix="/install" -r /requirements.txt
RUN pip install --prefix="/install" "git+https://github.com/KnightDoom/zotify.git"

FROM base

COPY --from=builder /install /usr/local/lib/python3.11/site-packages
RUN mv /usr/local/lib/python3.11/site-packages/lib/python3.11/site-packages/* /usr/local/lib/python3.11/site-packages/

COPY zotify /app/zotify

WORKDIR /app
CMD ["python3", "-m", "zotify"]
