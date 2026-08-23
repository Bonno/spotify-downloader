FROM python:3.10-alpine AS base

RUN apk --update add ffmpeg git

FROM base AS builder

WORKDIR /install

RUN apk add gcc libc-dev zlib zlib-dev jpeg-dev
RUN python -m pip install --prefix=/install git+https://github.com/Googolplexed0/zotify.git

FROM base

COPY --from=builder /install/lib/python3.10/site-packages/ /usr/local/lib/python3.10/site-packages/
COPY --from=builder /install/bin/ /usr/local/bin/

RUN adduser -D zotify

WORKDIR /app
RUN chown -R zotify:zotify /app

USER zotify

RUN mkdir -p ~/.config/zotify

EXPOSE 4381
CMD ["zotify"]
