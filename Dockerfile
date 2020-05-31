From develop-20200202-fv3-input:v1 AS dataBase

From utest-base:v2

ENV HOME=/home/tester

COPY --chown=tester:tester . $HOME/ufs-weather-model
COPY --from=dataBase --chown=tester:tester /tmp/FV3_input_data /home/tester/data/NEMSfv3gfs/develop-20200202/FV3_input_data

USER tester
ENV USER=tester

RUN mkdir ${HOME}/stmp2 && mkdir ${HOME}/stmp4

ARG test_name
ARG build_case
ARG run_case

ENV test_name=$test_name
ENV build_case=$build_case
ENV run_case=$run_case

WORKDIR $HOME/ufs-weather-model/tests
#ENV PATH
RUN . /etc/bashrc && ./utest -n $test_name -c $build_case -z
CMD . /etc/bashrc && ./utest -n $test_name -c $build_case -x && ./utest -n $test_name -r $run_case -x
