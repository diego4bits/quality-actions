# .github/actions/dependency-check/Dockerfile
FROM owasp/dependency-check:7.4.4

WORKDIR /opt/action

COPY entrypoint.sh .

# ENTRYPOINT invocado por shell, no necesita +x
ENTRYPOINT ["sh", "./entrypoint.sh"]
