FROM python

RUN git clone --single-branch --branch k8_support https://github.com/bridgecrewio/checkov.git /tmp/checkov
RUN pip install /tmp/checkov/

# TODO - Check K8S version and use appropriate kubectl?
# kubectl version -o json | jq -r '.serverVersion.minor'

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x kubectl && mv kubectl /usr/local/bin
RUN groupadd -g 12000 -r checkov && useradd -u 12000 --no-log-init -r -g checkov checkov
RUN mkdir /data && mkdir /app && mkdir /home/checkov
RUN chown checkov:checkov /data /app /home/checkov
USER checkov


COPY run_checkov.sh /app
RUN chmod +x /app/run_checkov.sh

ENTRYPOINT ["/app/run_checkov.sh"]
