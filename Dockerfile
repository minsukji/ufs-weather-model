From minsukjinoaa/ufs-weather-model-ci-docker-data:v1

RUN useradd -ms /bin/bash tester
COPY . /home/tester/ufs-weather-model
RUN cp -r /tmp/ufs-weather-model-ci-docker/data/FV3_input_data /home/tester/ufs-weather-model
RUN chown -R tester:tester /home/tester/ufs-weather-model

RUN lscpu

USER tester
ENV HOME /home/tester

RUN mkdir ${HOME}/stmp2 && mkdir ${HOME}/stmp4 && mkdir -p ${HOME}/data/NEMSfv3gfs/develop-20200202
RUN mv ${HOME}/ufs-weather-model/FV3_input_data ${HOME}/data/NEMSfv3gfs/develop-20200202
RUN . /etc/bashrc && export USER=tester && cd ${HOME}/ufs-weather-model/tests && ./utest -n fv3_control -c std
RUN . /etc/bashrc && export USER=tester && cd ${HOME}/ufs-weather-model/tests && ./utest -n fv3_control -r std
