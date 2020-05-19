From minsukjinoaa/ufs-weather-model-ci-docker-data-2:v1

COPY --chown=tester:tester . /home/tester/ufs-weather-model

USER tester
ENV HOME /home/tester

RUN mkdir ${HOME}/stmp2 && mkdir ${HOME}/stmp4
RUN . /etc/bashrc && export USER=tester && cd ${HOME}/ufs-weather-model/tests && ./utest -n fv3_control -c std,32bit,debug \
 && ./utest -n fv3_control -r std,restart,32bit,debug && ./gitHubActionsTest.sh
