FROM centos:7

RUN yum -y install make

# Download and install Coverity binaries
WORKDIR /cov-analysis
RUN curl \
  -o cov-analysis-linux64.tgz \
  https://scan.coverity.com/download/linux64 \
  --form project="test-coverity-python" \
  --form token="AS11Ccp0RBzXimZIYT8dLQ"
RUN tar xfz cov-analysis-linux64.tgz
RUN command rm cov-analysis-linux64.tgz
RUN mv cov-analysis-linux64-* cov-analysis-linux64
ENV PATH="/cov-analysis/cov-analysis-linux64/bin:${PATH}"

# Create project
WORKDIR /project
ADD /project/ /project/

# Run Coverity tools on project
RUN cov-configure \
  --python

RUN cov-build \
  --dir cov \
  --no-command \
  --fs-capture-search ./

# Analyze not available in the free version
# RUN cov-analyze \
#   --dir cov \
#   --all \
#   --aggressiveness-level high