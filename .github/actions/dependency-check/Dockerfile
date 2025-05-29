FROM owasp/dependency-check:7.4.4

WORKDIR /opt/action

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/opt/action/entrypoint.sh"]
