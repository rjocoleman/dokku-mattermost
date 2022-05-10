FROM mattermost/mattermost-enterprise-edition:6.6.1

# Install shdotenv to use .env
USER root
RUN curl -sfL https://github.com/ko1nksm/shdotenv/releases/latest/download/shdotenv | install /dev/stdin /usr/bin/shdotenv
USER mattermost

COPY .env /
COPY dokku-entrypoint.sh /
ENTRYPOINT ["/dokku-entrypoint.sh"]
CMD ["mattermost"]
