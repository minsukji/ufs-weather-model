From minsukjinoaa/ufs-weather-model-ci-docker-data-2:v1

COPY --chown=tester:tester . /home/tester/ufs-weather-model

USER tester
ENV HOME /home/tester

RUN mkdir ${HOME}/stmp2 && mkdir ${HOME}/stmp4
CMD . /etc/bashrc && export USER=tester && cd /home/tester/ufs-weather-model/tests && ./utest -n fv3_control -c std && ./utest -n fv3_control -r std && ./gitHubActionsTest.sh
