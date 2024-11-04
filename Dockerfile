# Need to be logged into ECR
ARG AWS_ACCOUNT_ID=override_me
FROM ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/client

# Declaring env
ENV NODE_ENV=prod

RUN set -xe

# Install Nginx, curl, and other dependencies
RUN apt-get update && apt-get install -y \
    nginx curl unzip net-tools && \
    # Install AWS CLI v2 in case we need it
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/ && \
    rm -rf /var/lib/apt/lists/*

# Overwrite the default nginx settings
COPY packer/templates/cfpdxweb.config.template /etc/nginx/sites-available/cfpdxweb.config

RUN ln -s /etc/nginx/sites-available/cfpdxweb.config /etc/nginx/sites-enabled/ && \
    unlink /etc/nginx/sites-available/default && \
    unlink /etc/nginx/sites-enabled/default && \
    nginx -t

# Setting up the work directory
WORKDIR /app

# Copy files
COPY \
    app.js \
    package.json \
    package-lock.json \
    ./

# Copy dirs
COPY bin/ bin/
COPY routes/ routes/

# Installing dependencies
RUN npm ci

# Move client dir into app dir
RUN mv ../client/ .

# Exposing server port
EXPOSE 80

# Starting our application
CMD [ "sh", "-c", "nginx -g 'daemon off;' & npm start" ]

# CMD USED FOR BUILD TESTING
# CMD ["/bin/bash"]